import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../service_registry.dart';

/// Scope для moderation panel. Полностью изолирован от B2C auth —
/// `requireLogin = false` (см. gotcha #22), identity парсится вручную
/// из Cloudflare Access header `Cf-Access-Authenticated-User-Email`.
/// В dev-режиме (`ADMIN_DEV_BYPASS=true`) та же identity принимается
/// из query param `_adminEmail`, чтобы локально работать без туннеля.
///
/// Каждый метод начинает с `final admin = await _requireAdmin(session)`.
/// Без валидной identity бросается [AdminAuthException] → Serverpod
/// вернёт 500 с сообщением; клиент разбирает по тексту.
class AdminEndpoint extends Endpoint {
  // ── Read-only: metrics / lists ───────────────────────────────────────────

  Future<AdminMetrics> getMetrics(Session session) async {
    await _requireAdmin(session);

    final totalRestaurants = await Restaurant.db.count(session);
    final totalCuratedDishes = await CuratedDish.db.count(session);
    final totalDishesInCatalog = await DishCatalog.db.count(session);

    final usersRow = await session.db.unsafeQuery(
      'SELECT COUNT(*) AS c FROM serverpod_auth_core_user WHERE NOT blocked',
    );
    final totalUsers = usersRow.isEmpty
        ? 0
        : (usersRow.first.toColumnMap()['c'] as num?)?.toInt() ?? 0;

    final menuRow = await session.db.unsafeQuery(
      'SELECT COUNT(DISTINCT "restaurantId") AS c FROM category',
    );
    final totalMenus = menuRow.isEmpty
        ? 0
        : (menuRow.first.toColumnMap()['c'] as num?)?.toInt() ?? 0;

    final costRow = await session.db.unsafeQuery(
      'SELECT COALESCE(SUM("estimatedCostUsd"), 0) AS c FROM llm_usage',
    );
    final totalLlmCostUsd = costRow.isEmpty
        ? 0.0
        : ((costRow.first.toColumnMap()['c'] as num?)?.toDouble() ?? 0.0);

    return AdminMetrics(
      totalRestaurants: totalRestaurants,
      totalUsers: totalUsers,
      totalMenus: totalMenus,
      totalDishesInCatalog: totalDishesInCatalog,
      totalCuratedDishes: totalCuratedDishes,
      totalLlmCostUsd: totalLlmCostUsd,
    );
  }

  Future<List<Restaurant>> listRestaurants(
    Session session, {
    int? offset,
    int? limit,
    String? search,
  }) async {
    await _requireAdmin(session);

    // Serverpod 3.4 генерирует named params как required в dispatcher'е
    // (игнорирует Dart default values). Поэтому на уровне сигнатуры
    // делаем nullable, а дефолты применяем здесь.
    final effOffset = offset ?? 0;
    final clamped = (limit ?? 50).clamp(1, 500);
    if (search == null || search.trim().isEmpty) {
      return Restaurant.db.find(
        session,
        orderBy: (t) => t.createdAt,
        orderDescending: true,
        offset: effOffset,
        limit: clamped,
      );
    }

    final needle = '%${search.trim().toLowerCase()}%';
    return Restaurant.db.find(
      session,
      where: (t) => t.normalizedName.ilike(needle) | t.name.ilike(needle),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      offset: effOffset,
      limit: clamped,
    );
  }

  Future<List<AdminUserRow>> listUsers(
    Session session, {
    int? offset,
    int? limit,
    String? search,
  }) async {
    await _requireAdmin(session);

    final effOffset = offset ?? 0;
    final clamped = (limit ?? 50).clamp(1, 500);
    final pattern = (search == null || search.trim().isEmpty)
        ? null
        : '%${search.trim().toLowerCase()}%';

    // B2C users хранятся в двух таблицах auth-ядра Serverpod'а:
    // - serverpod_auth_core_user (id uuid, createdAt, blocked)
    // - serverpod_auth_idp_email_account (email, authUserId → core_user.id)
    // `app_user_profile` — наши post-registration поля (fullName, birthDate).
    // userIdentifier из session = core_user.id::text. Last sign-in пока
    // null — потребует JOIN с auth_core_session, отложим до нужды в UI.
    final sql = StringBuffer()
      ..writeln('SELECT u.id::text AS user_id,')
      ..writeln('       e.email AS email,')
      ..writeln('       p."fullName" AS display_name,')
      ..writeln('       u."createdAt" AS created_at')
      ..writeln('FROM serverpod_auth_core_user u')
      ..writeln('LEFT JOIN serverpod_auth_idp_email_account e ON e."authUserId" = u.id')
      ..writeln('LEFT JOIN app_user_profile p ON p."userId" = u.id::text')
      ..writeln('WHERE NOT u.blocked');
    if (pattern != null) {
      sql.writeln(
        'AND (LOWER(COALESCE(e.email, \'\')) LIKE @q '
        'OR LOWER(COALESCE(p."fullName", \'\')) LIKE @q)',
      );
    }
    sql
      ..writeln('ORDER BY u."createdAt" DESC')
      ..writeln('OFFSET @off LIMIT @lim');

    final rows = await session.db.unsafeQuery(
      sql.toString(),
      parameters: QueryParameters.named({
        'q': ?pattern,
        'off': effOffset,
        'lim': clamped,
      }),
    );

    return rows.map((r) {
      final m = r.toColumnMap();
      return AdminUserRow(
        userId: m['user_id'] as String,
        email: m['email'] as String?,
        displayName: m['display_name'] as String?,
        createdAt: m['created_at'] as DateTime,
        lastSignInAt: null,
      );
    }).toList();
  }

  // ── Phase C.1 · Dish Library (CuratedDish + DishCatalog CRUD) ───────────

  Future<List<CuratedDish>> listCuratedDishes(
    Session session, {
    String? status,
    String? cuisine,
    String? search,
    int? offset,
    int? limit,
  }) async {
    await _requireAdmin(session);

    final effOffset = offset ?? 0;
    final clamped = (limit ?? 50).clamp(1, 500);
    final needle = (search == null || search.trim().isEmpty)
        ? null
        : '%${search.trim().toLowerCase()}%';

    return CuratedDish.db.find(
      session,
      where: (t) {
        Expression expr = Constant.bool(true);
        if (status != null) expr = expr & t.status.equals(status);
        if (cuisine != null) expr = expr & t.cuisine.equals(cuisine);
        if (needle != null) {
          expr = expr &
              (t.canonicalName.ilike(needle) |
                  t.displayName.ilike(needle));
        }
        return expr;
      },
      orderBy: (t) => t.updatedAt,
      orderDescending: true,
      offset: effOffset,
      limit: clamped,
    );
  }

  /// Патч subset полей. Любой аргумент null трактуется как "не менять";
  /// чтобы занулить nullable-поле, клиент шлёт пустую строку (или
  /// дополнительный `clear*` флаг в будущем). MVP — минимальный набор.
  Future<CuratedDish> updateCuratedDish(
    Session session,
    int id, {
    String? displayName,
    String? cuisine,
    String? countryCode,
    String? courseType,
    String? description,
    String? status,
  }) async {
    final admin = await _requireAdmin(session);
    final existing = await CuratedDish.db.findById(session, id);
    if (existing == null) {
      throw StateError('CuratedDish $id not found');
    }

    final prev = <String, Object?>{
      'displayName': existing.displayName,
      'cuisine': existing.cuisine,
      'countryCode': existing.countryCode,
      'courseType': existing.courseType,
      'description': existing.description,
      'status': existing.status,
    };

    final updated = existing.copyWith(
      displayName: displayName ?? existing.displayName,
      cuisine: cuisine ?? existing.cuisine,
      countryCode: countryCode ?? existing.countryCode,
      courseType: courseType ?? existing.courseType,
      description: description ?? existing.description,
      status: status ?? existing.status,
      approvedBy: status == 'approved' ? admin.email : existing.approvedBy,
      updatedAt: DateTime.now(),
    );
    final saved = await CuratedDish.db.updateRow(session, updated);

    await ServiceRegistry.instance.auditService.logAction(
      session,
      actorEmail: admin.email,
      action: status != null && status != existing.status
          ? 'status_changed'
          : 'edited',
      objectType: 'curated_dish',
      objectId: id.toString(),
      diff: jsonEncode({'before': prev, 'after': _dishPatchMap(saved)}),
    );
    return saved;
  }

  Future<List<DishCatalogRow>> listDishCatalog(
    Session session, {
    bool? linked,
    String? search,
    int? offset,
    int? limit,
  }) async {
    await _requireAdmin(session);

    final effOffset = offset ?? 0;
    final clamped = (limit ?? 50).clamp(1, 500);
    final pattern = (search == null || search.trim().isEmpty)
        ? null
        : '%${search.trim().toLowerCase()}%';

    final where = StringBuffer('WHERE 1=1');
    if (linked == true) where.write(' AND dc."curatedDishId" IS NOT NULL');
    if (linked == false) where.write(' AND dc."curatedDishId" IS NULL');
    if (pattern != null) {
      where.write(
        ' AND (LOWER(dc."canonicalName") LIKE @q OR LOWER(dc."normalizedName") LIKE @q)',
      );
    }

    final rows = await session.db.unsafeQuery(
      '''
SELECT dc.id AS id,
       dc."normalizedName" AS normalized_name,
       dc."canonicalName" AS canonical_name,
       dc."cuisineType" AS cuisine_type,
       dc.description AS description,
       dc."curatedDishId" AS curated_dish_id,
       cd."displayName" AS curated_display_name,
       (
         SELECT di."imageUrl" FROM dish_image di
         WHERE di."dishCatalogId" = dc.id AND di."isPrimary" = true
         LIMIT 1
       ) AS primary_image_url,
       dc."enrichmentStatus" AS enrichment_status,
       dc."createdAt" AS created_at,
       dc."updatedAt" AS updated_at
FROM dish_catalog dc
LEFT JOIN curated_dish cd ON cd.id = dc."curatedDishId"
$where
ORDER BY dc."updatedAt" DESC
OFFSET @off LIMIT @lim
''',
      parameters: QueryParameters.named({
        'q': ?pattern,
        'off': effOffset,
        'lim': clamped,
      }),
    );

    return rows.map((r) {
      final m = r.toColumnMap();
      return DishCatalogRow(
        id: m['id'] as int,
        normalizedName: m['normalized_name'] as String,
        canonicalName: m['canonical_name'] as String,
        cuisineType: m['cuisine_type'] as String?,
        description: m['description'] as String?,
        curatedDishId: m['curated_dish_id'] as int?,
        curatedDisplayName: m['curated_display_name'] as String?,
        primaryImageUrl: m['primary_image_url'] as String?,
        enrichmentStatus: m['enrichment_status'] as String,
        createdAt: m['created_at'] as DateTime,
        updatedAt: m['updated_at'] as DateTime,
      );
    }).toList();
  }

  // ── Phase C.3 · Translations ────────────────────────────────────────────

  Future<List<TranslationRow>> listTranslations(
    Session session, {
    required String language,
    String? search,
    int? offset,
    int? limit,
  }) async {
    await _requireAdmin(session);

    final effOffset = offset ?? 0;
    final clamped = (limit ?? 100).clamp(1, 500);
    final pattern = (search == null || search.trim().isEmpty)
        ? null
        : '%${search.trim().toLowerCase()}%';

    final where = StringBuffer(
      'WHERE (tr.language = @lang OR tr.language IS NULL)',
    );
    if (pattern != null) {
      where.write(
        ' AND (LOWER(cd."displayName") LIKE @q OR LOWER(COALESCE(tr.name, \'\')) LIKE @q)',
      );
    }

    final rows = await session.db.unsafeQuery(
      '''
SELECT tr.id AS translation_id,
       cd.id AS curated_dish_id,
       cd."displayName" AS dish_display_name,
       @lang AS language,
       tr.name AS name,
       tr.description AS description,
       tr.source AS source,
       tr."createdAt" AS created_at
FROM curated_dish cd
LEFT JOIN dish_translation tr
       ON tr."curatedDishId" = cd.id AND tr.language = @lang
$where
ORDER BY cd."displayName"
OFFSET @off LIMIT @lim
''',
      parameters: QueryParameters.named({
        'lang': language,
        'q': ?pattern,
        'off': effOffset,
        'lim': clamped,
      }),
    );

    return rows.map((r) {
      final m = r.toColumnMap();
      return TranslationRow(
        translationId: m['translation_id'] as int?,
        curatedDishId: m['curated_dish_id'] as int,
        dishDisplayName: m['dish_display_name'] as String,
        language: m['language'] as String,
        name: m['name'] as String?,
        description: m['description'] as String?,
        source: m['source'] as String?,
        createdAt: m['created_at'] as DateTime?,
      );
    }).toList();
  }

  /// Создаёт или обновляет перевод. Источник помечаем как `manual`
  /// (в отличие от `claude_auto` — последние были сгенерены промптом).
  Future<DishTranslation> upsertTranslation(
    Session session, {
    required int curatedDishId,
    required String language,
    required String name,
    required String description,
  }) async {
    final admin = await _requireAdmin(session);
    final existing = await DishTranslation.db.findFirstRow(
      session,
      where: (t) =>
          t.curatedDishId.equals(curatedDishId) & t.language.equals(language),
    );
    final now = DateTime.now();

    DishTranslation saved;
    if (existing == null) {
      saved = await DishTranslation.db.insertRow(
        session,
        DishTranslation(
          curatedDishId: curatedDishId,
          language: language,
          name: name,
          description: description,
          source: 'manual',
          createdAt: now,
        ),
      );
    } else {
      saved = await DishTranslation.db.updateRow(
        session,
        existing.copyWith(
          name: name,
          description: description,
          source: 'manual',
        ),
      );
    }

    await ServiceRegistry.instance.auditService.logAction(
      session,
      actorEmail: admin.email,
      action: existing == null ? 'created' : 'edited',
      objectType: 'translation',
      objectId: '$curatedDishId/$language',
      diff: jsonEncode({
        'name': name,
        'description': description,
      }),
    );
    return saved;
  }

  // ── Phase C.4 · Photo review ────────────────────────────────────────────

  Future<List<PhotoReviewRow>> listLowQualityPhotos(
    Session session, {
    int? maxQuality,
    int? offset,
    int? limit,
  }) async {
    await _requireAdmin(session);

    final effMax = maxQuality ?? 3;
    final effOffset = offset ?? 0;
    final clamped = (limit ?? 60).clamp(1, 300);

    final rows = await session.db.unsafeQuery(
      '''
SELECT img.id AS image_id,
       img."curatedDishId" AS curated_dish_id,
       cd."displayName" AS dish_display_name,
       img."imageUrl" AS image_url,
       img.source AS source,
       img."qualityScore" AS quality_score,
       img."isPrimary" AS is_primary,
       img.width AS width,
       img.height AS height,
       img."createdAt" AS created_at
FROM curated_dish_image img
JOIN curated_dish cd ON cd.id = img."curatedDishId"
WHERE img."qualityScore" <= @max
ORDER BY img."qualityScore" ASC, img."createdAt" ASC
OFFSET @off LIMIT @lim
''',
      parameters: QueryParameters.named({
        'max': effMax,
        'off': effOffset,
        'lim': clamped,
      }),
    );

    return rows.map((r) {
      final m = r.toColumnMap();
      return PhotoReviewRow(
        imageId: m['image_id'] as int,
        curatedDishId: m['curated_dish_id'] as int,
        dishDisplayName: m['dish_display_name'] as String,
        imageUrl: m['image_url'] as String,
        source: m['source'] as String,
        qualityScore: m['quality_score'] as int,
        isPrimary: m['is_primary'] as bool,
        width: m['width'] as int?,
        height: m['height'] as int?,
        createdAt: m['created_at'] as DateTime,
      );
    }).toList();
  }

  Future<CuratedDishImage> setPhotoQuality(
    Session session,
    int imageId,
    int qualityScore,
  ) async {
    final admin = await _requireAdmin(session);
    if (qualityScore < 1 || qualityScore > 5) {
      throw ArgumentError.value(qualityScore, 'qualityScore', 'must be 1..5');
    }
    final existing = await CuratedDishImage.db.findById(session, imageId);
    if (existing == null) {
      throw StateError('CuratedDishImage $imageId not found');
    }
    final saved = await CuratedDishImage.db.updateRow(
      session,
      existing.copyWith(qualityScore: qualityScore),
    );
    await ServiceRegistry.instance.auditService.logAction(
      session,
      actorEmail: admin.email,
      action: 'rated_photo',
      objectType: 'photo',
      objectId: imageId.toString(),
      diff: jsonEncode({
        'from': existing.qualityScore,
        'to': qualityScore,
      }),
    );
    return saved;
  }

  Future<bool> deletePhoto(Session session, int imageId) async {
    final admin = await _requireAdmin(session);
    final existing = await CuratedDishImage.db.findById(session, imageId);
    if (existing == null) return false;
    await CuratedDishImage.db.deleteRow(session, existing);
    await ServiceRegistry.instance.auditService.logAction(
      session,
      actorEmail: admin.email,
      action: 'deleted_photo',
      objectType: 'photo',
      objectId: imageId.toString(),
      diff: jsonEncode({
        'imageUrl': existing.imageUrl,
        'source': existing.source,
        'qualityScore': existing.qualityScore,
      }),
    );
    return true;
  }

  // ── Phase C.5 · Audit log ───────────────────────────────────────────────

  Future<List<AuditLog>> listAuditLog(
    Session session, {
    String? actorEmail,
    String? objectType,
    String? action,
    int? offset,
    int? limit,
  }) async {
    await _requireAdmin(session);

    final effOffset = offset ?? 0;
    final clamped = (limit ?? 100).clamp(1, 500);

    return AuditLog.db.find(
      session,
      where: (t) {
        Expression expr = Constant.bool(true);
        if (actorEmail != null) expr = expr & t.actorEmail.equals(actorEmail);
        if (objectType != null) expr = expr & t.objectType.equals(objectType);
        if (action != null) expr = expr & t.action.equals(action);
        return expr;
      },
      orderBy: (t) => t.timestamp,
      orderDescending: true,
      offset: effOffset,
      limit: clamped,
    );
  }

  // ── Phase D · Queue + Menu Validator ────────────────────────────────────

  Future<List<MenuQueueEntry>> listMenuQueue(
    Session session, {
    String? status,
    String? search,
    int? offset,
    int? limit,
  }) async {
    await _requireAdmin(session);

    final effOffset = offset ?? 0;
    final clamped = (limit ?? 50).clamp(1, 500);
    final pattern = (search == null || search.trim().isEmpty)
        ? null
        : '%${search.trim().toLowerCase()}%';

    // Статус-фильтр. 'legacy' = moderationStatus IS NULL (трактуется
    // клиентом как 'auto'). Null / 'all' = без фильтра.
    final statusClause = switch (status) {
      'under_review' => 'AND r."moderationStatus" = \'under_review\'',
      'approved' => 'AND r."moderationStatus" = \'approved\'',
      'rejected' => 'AND r."moderationStatus" = \'rejected\'',
      'legacy' => 'AND r."moderationStatus" IS NULL',
      _ => '',
    };

    final rows = await session.db.unsafeQuery(
      '''
SELECT r.id AS restaurant_id,
       r.name AS name,
       r."cityHint" AS city_hint,
       r."countryCode" AS country_code,
       r."createdAt" AS parsed_at,
       r."updatedAt" AS updated_at,
       r."moderationStatus" AS moderation_status,
       (SELECT COUNT(*) FROM category c WHERE c."restaurantId" = r.id) AS category_count,
       (SELECT COUNT(*) FROM menu_item mi
          JOIN category c ON c.id = mi."categoryId"
         WHERE c."restaurantId" = r.id) AS dish_count,
       (SELECT COUNT(*) FROM menu_source_page p WHERE p."restaurantId" = r.id) AS page_count
FROM restaurant r
WHERE 1=1
  ${pattern != null ? 'AND (LOWER(r.name) LIKE @q OR LOWER(r."normalizedName") LIKE @q)' : ''}
  $statusClause
ORDER BY COALESCE(r."updatedAt", r."createdAt") DESC
OFFSET @off LIMIT @lim
''',
      parameters: QueryParameters.named({
        'q': ?pattern,
        'off': effOffset,
        'lim': clamped,
      }),
    );

    return rows.map((r) {
      final m = r.toColumnMap();
      return MenuQueueEntry(
        restaurantId: m['restaurant_id'] as int,
        name: m['name'] as String,
        cityHint: m['city_hint'] as String?,
        countryCode: m['country_code'] as String?,
        parsedAt: m['parsed_at'] as DateTime,
        updatedAt: m['updated_at'] as DateTime?,
        dishCount: (m['dish_count'] as num).toInt(),
        categoryCount: (m['category_count'] as num).toInt(),
        pageCount: (m['page_count'] as num).toInt(),
        moderationStatus: m['moderation_status'] as String?,
      );
    }).toList();
  }

  Future<MenuValidationView> getMenuForValidation(
    Session session,
    int restaurantId,
  ) async {
    await _requireAdmin(session);

    final restaurant = await Restaurant.db.findById(session, restaurantId);
    if (restaurant == null) {
      throw StateError('Restaurant $restaurantId not found');
    }

    final pages = await MenuSourcePage.db.find(
      session,
      where: (t) => t.restaurantId.equals(restaurantId),
      orderBy: (t) => t.ordinal,
    );
    final categories = await Category.db.find(
      session,
      where: (t) => t.restaurantId.equals(restaurantId),
      orderBy: (t) => t.createdAt,
    );
    final categoryIds = categories.map((c) => c.id!).toList();
    final items = categoryIds.isEmpty
        ? <MenuItem>[]
        : await MenuItem.db.find(
            session,
            where: (t) => t.categoryId.inSet(categoryIds.toSet()),
            orderBy: (t) => t.createdAt,
          );

    return MenuValidationView(
      restaurant: restaurant,
      pages: pages,
      categories: categories,
      items: items,
    );
  }

  Future<MenuItem> updateMenuItem(
    Session session,
    int itemId, {
    String? name,
    double? price,
    String? approvalStatus,
  }) async {
    final admin = await _requireAdmin(session);
    final existing = await MenuItem.db.findById(session, itemId);
    if (existing == null) {
      throw StateError('MenuItem $itemId not found');
    }

    final prev = <String, Object?>{
      'name': existing.name,
      'price': existing.price,
      'approvalStatus': existing.approvalStatus,
    };

    final saved = await MenuItem.db.updateRow(
      session,
      existing.copyWith(
        name: name ?? existing.name,
        price: price ?? existing.price,
        approvalStatus: approvalStatus ?? existing.approvalStatus,
      ),
    );

    await _touchRestaurantRevision(session, saved.categoryId);

    await ServiceRegistry.instance.auditService.logAction(
      session,
      actorEmail: admin.email,
      action: 'edited',
      objectType: 'menu_item',
      objectId: itemId.toString(),
      diff: jsonEncode({
        'before': prev,
        'after': {
          'name': saved.name,
          'price': saved.price,
          'approvalStatus': saved.approvalStatus,
        },
      }),
    );
    return saved;
  }

  Future<Category> updateCategory(
    Session session,
    int categoryId, {
    String? name,
    String? approvalStatus,
  }) async {
    final admin = await _requireAdmin(session);
    final existing = await Category.db.findById(session, categoryId);
    if (existing == null) {
      throw StateError('Category $categoryId not found');
    }

    final prev = <String, Object?>{
      'name': existing.name,
      'approvalStatus': existing.approvalStatus,
    };
    final saved = await Category.db.updateRow(
      session,
      existing.copyWith(
        name: name ?? existing.name,
        approvalStatus: approvalStatus ?? existing.approvalStatus,
      ),
    );

    await _touchRestaurantRevision(session, saved.restaurantId);

    await ServiceRegistry.instance.auditService.logAction(
      session,
      actorEmail: admin.email,
      action: 'edited',
      objectType: 'category',
      objectId: categoryId.toString(),
      diff: jsonEncode({
        'before': prev,
        'after': {
          'name': saved.name,
          'approvalStatus': saved.approvalStatus,
        },
      }),
    );
    return saved;
  }

  Future<Restaurant> approveMenu(Session session, int restaurantId) async {
    return _setModerationStatus(session, restaurantId, 'approved', reason: null);
  }

  Future<Restaurant> rejectMenu(
    Session session,
    int restaurantId,
    String reason,
  ) async {
    return _setModerationStatus(
      session,
      restaurantId,
      'rejected',
      reason: reason,
    );
  }

  Future<Restaurant> _setModerationStatus(
    Session session,
    int restaurantId,
    String status, {
    String? reason,
  }) async {
    final admin = await _requireAdmin(session);
    final existing = await Restaurant.db.findById(session, restaurantId);
    if (existing == null) {
      throw StateError('Restaurant $restaurantId not found');
    }
    final now = DateTime.now();
    final saved = await Restaurant.db.updateRow(
      session,
      existing.copyWith(
        moderationStatus: status,
        updatedAt: now,
      ),
    );
    await ServiceRegistry.instance.auditService.logAction(
      session,
      actorEmail: admin.email,
      action: status == 'approved' ? 'approved_menu' : 'rejected_menu',
      objectType: 'restaurant',
      objectId: restaurantId.toString(),
      diff: jsonEncode({
        'before': {'moderationStatus': existing.moderationStatus},
        'after': {'moderationStatus': status},
        'reason': ?reason,
      }),
    );
    return saved;
  }

  /// Вызывается на каждое child mutation (updateMenuItem / updateCategory),
  /// чтобы Flutter poll увидел изменение через getRestaurantRevision.
  Future<void> _touchRestaurantRevision(
    Session session,
    int? categoryOrRestaurantId,
  ) async {
    if (categoryOrRestaurantId == null) return;
    // Находим ресторан по category.id если передан, иначе считаем что это уже restaurantId.
    final cat = await Category.db.findById(session, categoryOrRestaurantId);
    final restaurantId = cat?.restaurantId ?? categoryOrRestaurantId;
    final now = DateTime.now();
    await session.db.unsafeExecute(
      'UPDATE restaurant SET "updatedAt" = @t WHERE id = @id',
      parameters: QueryParameters.named({'t': now, 'id': restaurantId}),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  Map<String, Object?> _dishPatchMap(CuratedDish d) => <String, Object?>{
        'displayName': d.displayName,
        'cuisine': d.cuisine,
        'countryCode': d.countryCode,
        'courseType': d.courseType,
        'description': d.description,
        'status': d.status,
      };

  // ── Identity ────────────────────────────────────────────────────────────

  /// Резолвит identity из Cloudflare Access header (prod) или query param
  /// (`_adminEmail`) + env `ADMIN_DEV_BYPASS=true` (dev). Обновляет
  /// `lastLoginAt` на каждый hit (fire-and-forget).
  Future<AdminUser> _requireAdmin(Session session) async {
    if (session is! MethodCallSession) {
      throw AdminAuthException(
        'admin endpoints can only be called through the API surface',
      );
    }

    final headerEmail = session.request.headers['cf-access-authenticated-user-email']
        ?.firstOrNull
        ?.trim()
        .toLowerCase();

    String? candidate = headerEmail != null && headerEmail.isNotEmpty
        ? headerEmail
        : null;

    if (candidate == null && _devBypassEnabled) {
      final qp = session.queryParameters['_adminEmail'];
      if (qp is String && qp.trim().isNotEmpty) {
        candidate = qp.trim().toLowerCase();
      }
    }

    if (candidate == null) {
      throw AdminAuthException(
        'missing Cloudflare Access identity header',
      );
    }

    final admin = await AdminUser.db.findFirstRow(
      session,
      where: (t) => t.email.equals(candidate),
    );
    if (admin == null) {
      throw AdminAuthException(
        'email "$candidate" is not registered in admin_user',
      );
    }

    // Fire-and-forget: обновляем lastLoginAt, не блокируем основной flow.
    unawaited(_touchLastLogin(session, admin));

    return admin;
  }

  Future<void> _touchLastLogin(Session session, AdminUser admin) async {
    try {
      await AdminUser.db.updateRow(
        session,
        admin.copyWith(lastLoginAt: DateTime.now()),
      );
    } catch (_) {
      // не роняем основной запрос из-за housekeeping ошибки.
    }
  }

  bool get _devBypassEnabled =>
      Platform.environment['ADMIN_DEV_BYPASS']?.toLowerCase() == 'true';
}

/// Unified-сигнал для клиента, что запрос был отклонён на этапе admin
/// identity. Serverpod map'ит Dart exceptions в 500, клиент pattern-матчит
/// по message (гибче, чем отдельные status codes).
class AdminAuthException implements Exception {
  final String message;
  AdminAuthException(this.message);
  @override
  String toString() => 'AdminAuthException: $message';
}
