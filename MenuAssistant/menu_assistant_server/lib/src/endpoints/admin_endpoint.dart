import 'dart:async';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

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
