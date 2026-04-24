/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i1;
import 'package:serverpod_client/serverpod_client.dart' as _i2;
import 'dart:async' as _i3;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i4;
import 'package:menu_assistant_client/src/protocol/admin_metrics.dart' as _i5;
import 'package:menu_assistant_client/src/protocol/restaurant.dart' as _i6;
import 'package:menu_assistant_client/src/protocol/admin_user_row.dart' as _i7;
import 'package:menu_assistant_client/src/protocol/curated_dish.dart' as _i8;
import 'package:menu_assistant_client/src/protocol/dish_catalog_row.dart'
    as _i9;
import 'package:menu_assistant_client/src/protocol/translation_row.dart'
    as _i10;
import 'package:menu_assistant_client/src/protocol/dish_translation.dart'
    as _i11;
import 'package:menu_assistant_client/src/protocol/photo_review_row.dart'
    as _i12;
import 'package:menu_assistant_client/src/protocol/curated_dish_image.dart'
    as _i13;
import 'package:menu_assistant_client/src/protocol/audit_log.dart' as _i14;
import 'package:menu_assistant_client/src/protocol/process_menu_result.dart'
    as _i15;
import 'package:menu_assistant_client/src/protocol/menu_page_input.dart'
    as _i16;
import 'package:menu_assistant_client/src/protocol/category.dart' as _i17;
import 'package:menu_assistant_client/src/protocol/menu_item_view.dart' as _i18;
import 'package:menu_assistant_client/src/protocol/user_profile.dart' as _i19;
import 'package:menu_assistant_client/src/protocol/greetings/greeting.dart'
    as _i20;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i21;
import 'protocol.dart' as _i22;

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _i1.EndpointEmailIdpBase {
  EndpointEmailIdp(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<_i4.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _i3.Future<_i2.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i3.Future<String> verifyRegistrationCode({
    required _i2.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _i3.Future<_i4.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i3.Future<_i2.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i3.Future<String> verifyPasswordResetCode({
    required _i2.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _i3.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _i4.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _i3.Future<_i4.AuthSuccess> refreshAccessToken({
    required String refreshToken,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'jwtRefresh',
    'refreshAccessToken',
    {'refreshToken': refreshToken},
    authenticated: false,
  );
}

/// Scope для moderation panel. Полностью изолирован от B2C auth —
/// `requireLogin = false` (см. gotcha #22), identity парсится вручную
/// из Cloudflare Access header `Cf-Access-Authenticated-User-Email`.
/// В dev-режиме (`ADMIN_DEV_BYPASS=true`) та же identity принимается
/// из query param `_adminEmail`, чтобы локально работать без туннеля.
///
/// Каждый метод начинает с `final admin = await _requireAdmin(session)`.
/// Без валидной identity бросается [AdminAuthException] → Serverpod
/// вернёт 500 с сообщением; клиент разбирает по тексту.
/// {@category Endpoint}
class EndpointAdmin extends _i2.EndpointRef {
  EndpointAdmin(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'admin';

  _i3.Future<_i5.AdminMetrics> getMetrics() =>
      caller.callServerEndpoint<_i5.AdminMetrics>(
        'admin',
        'getMetrics',
        {},
      );

  _i3.Future<List<_i6.Restaurant>> listRestaurants({
    int? offset,
    int? limit,
    String? search,
  }) => caller.callServerEndpoint<List<_i6.Restaurant>>(
    'admin',
    'listRestaurants',
    {
      'offset': offset,
      'limit': limit,
      'search': search,
    },
  );

  _i3.Future<List<_i7.AdminUserRow>> listUsers({
    int? offset,
    int? limit,
    String? search,
  }) => caller.callServerEndpoint<List<_i7.AdminUserRow>>(
    'admin',
    'listUsers',
    {
      'offset': offset,
      'limit': limit,
      'search': search,
    },
  );

  _i3.Future<List<_i8.CuratedDish>> listCuratedDishes({
    String? status,
    String? cuisine,
    String? search,
    int? offset,
    int? limit,
  }) => caller.callServerEndpoint<List<_i8.CuratedDish>>(
    'admin',
    'listCuratedDishes',
    {
      'status': status,
      'cuisine': cuisine,
      'search': search,
      'offset': offset,
      'limit': limit,
    },
  );

  /// Патч subset полей. Любой аргумент null трактуется как "не менять";
  /// чтобы занулить nullable-поле, клиент шлёт пустую строку (или
  /// дополнительный `clear*` флаг в будущем). MVP — минимальный набор.
  _i3.Future<_i8.CuratedDish> updateCuratedDish(
    int id, {
    String? displayName,
    String? cuisine,
    String? countryCode,
    String? courseType,
    String? description,
    String? status,
  }) => caller.callServerEndpoint<_i8.CuratedDish>(
    'admin',
    'updateCuratedDish',
    {
      'id': id,
      'displayName': displayName,
      'cuisine': cuisine,
      'countryCode': countryCode,
      'courseType': courseType,
      'description': description,
      'status': status,
    },
  );

  _i3.Future<List<_i9.DishCatalogRow>> listDishCatalog({
    bool? linked,
    String? search,
    int? offset,
    int? limit,
  }) => caller.callServerEndpoint<List<_i9.DishCatalogRow>>(
    'admin',
    'listDishCatalog',
    {
      'linked': linked,
      'search': search,
      'offset': offset,
      'limit': limit,
    },
  );

  _i3.Future<List<_i10.TranslationRow>> listTranslations({
    required String language,
    String? search,
    int? offset,
    int? limit,
  }) => caller.callServerEndpoint<List<_i10.TranslationRow>>(
    'admin',
    'listTranslations',
    {
      'language': language,
      'search': search,
      'offset': offset,
      'limit': limit,
    },
  );

  /// Создаёт или обновляет перевод. Источник помечаем как `manual`
  /// (в отличие от `claude_auto` — последние были сгенерены промптом).
  _i3.Future<_i11.DishTranslation> upsertTranslation({
    required int curatedDishId,
    required String language,
    required String name,
    required String description,
  }) => caller.callServerEndpoint<_i11.DishTranslation>(
    'admin',
    'upsertTranslation',
    {
      'curatedDishId': curatedDishId,
      'language': language,
      'name': name,
      'description': description,
    },
  );

  _i3.Future<List<_i12.PhotoReviewRow>> listLowQualityPhotos({
    int? maxQuality,
    int? offset,
    int? limit,
  }) => caller.callServerEndpoint<List<_i12.PhotoReviewRow>>(
    'admin',
    'listLowQualityPhotos',
    {
      'maxQuality': maxQuality,
      'offset': offset,
      'limit': limit,
    },
  );

  _i3.Future<_i13.CuratedDishImage> setPhotoQuality(
    int imageId,
    int qualityScore,
  ) => caller.callServerEndpoint<_i13.CuratedDishImage>(
    'admin',
    'setPhotoQuality',
    {
      'imageId': imageId,
      'qualityScore': qualityScore,
    },
  );

  _i3.Future<bool> deletePhoto(int imageId) => caller.callServerEndpoint<bool>(
    'admin',
    'deletePhoto',
    {'imageId': imageId},
  );

  _i3.Future<List<_i14.AuditLog>> listAuditLog({
    String? actorEmail,
    String? objectType,
    String? action,
    int? offset,
    int? limit,
  }) => caller.callServerEndpoint<List<_i14.AuditLog>>(
    'admin',
    'listAuditLog',
    {
      'actorEmail': actorEmail,
      'objectType': objectType,
      'action': action,
      'offset': offset,
      'limit': limit,
    },
  );
}

/// {@category Endpoint}
class EndpointAiProcessing extends _i2.EndpointRef {
  EndpointAiProcessing(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'aiProcessing';

  /// Backward-compat single-page wrapper — the existing Flutter client
  /// (pre-4.7) still calls this.
  _i3.Future<_i15.ProcessMenuResult> processMenuUpload(
    String fileName,
    List<int> fileBytes,
  ) => caller.callServerEndpoint<_i15.ProcessMenuResult>(
    'aiProcessing',
    'processMenuUpload',
    {
      'fileName': fileName,
      'fileBytes': fileBytes,
    },
  );

  /// Multi-page menu upload. Pages are parsed as a single document, then
  /// - the restaurant is dedup'd against existing rows (pg_trgm + geo),
  /// - a [UserRestaurantVisit] is recorded for the current user,
  /// - a [MenuSourcePage] is stored per page,
  /// - menu items are linked to the shared [DishCatalog],
  /// - one [LlmUsage] row is written covering all pages.
  _i3.Future<_i15.ProcessMenuResult> processMultiPageMenu(
    List<_i16.MenuPageInput> pages,
  ) => caller.callServerEndpoint<_i15.ProcessMenuResult>(
    'aiProcessing',
    'processMultiPageMenu',
    {'pages': pages},
  );
}

/// {@category Endpoint}
class EndpointRestaurant extends _i2.EndpointRef {
  EndpointRestaurant(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'restaurant';

  /// Returns every restaurant the current user has ever uploaded a menu
  /// for — tracked via `user_restaurant_visit`.
  _i3.Future<List<_i6.Restaurant>> getAllRestaurants() =>
      caller.callServerEndpoint<List<_i6.Restaurant>>(
        'restaurant',
        'getAllRestaurants',
        {},
      );

  /// Returns a single restaurant by id — only if the current user has
  /// visited it. Restaurants are global, but access is still per-user.
  _i3.Future<_i6.Restaurant?> getRestaurantById(int id) =>
      caller.callServerEndpoint<_i6.Restaurant?>(
        'restaurant',
        'getRestaurantById',
        {'id': id},
      );

  /// Get Categories for a restaurant. Gated on the user having visited it.
  _i3.Future<List<_i17.Category>> getCategoriesForRestaurant(
    int restaurantId,
  ) => caller.callServerEndpoint<List<_i17.Category>>(
    'restaurant',
    'getCategoriesForRestaurant',
    {'restaurantId': restaurantId},
  );

  /// Get MenuItems for a category. Returns client-facing [MenuItemView]
  /// payloads with `description` and `imageUrl` resolved via JOIN on
  /// `dish_catalog` and `dish_image` (denorm snapshots removed in 4.6).
  _i3.Future<List<_i18.MenuItemView>> getMenuItemsForCategory(int categoryId) =>
      caller.callServerEndpoint<List<_i18.MenuItemView>>(
        'restaurant',
        'getMenuItemsForCategory',
        {'categoryId': categoryId},
      );

  /// Toggle Favorite status for a restaurant.
  _i3.Future<bool> toggleRestaurantFavorite(int restaurantId) =>
      caller.callServerEndpoint<bool>(
        'restaurant',
        'toggleRestaurantFavorite',
        {'restaurantId': restaurantId},
      );

  /// Toggle Favorite status for a menu item.
  _i3.Future<bool> toggleMenuItemFavorite(int menuItemId) =>
      caller.callServerEndpoint<bool>(
        'restaurant',
        'toggleMenuItemFavorite',
        {'menuItemId': menuItemId},
      );

  /// Get favorite restaurants.
  _i3.Future<List<_i6.Restaurant>> getFavoriteRestaurants({
    required int limit,
  }) => caller.callServerEndpoint<List<_i6.Restaurant>>(
    'restaurant',
    'getFavoriteRestaurants',
    {'limit': limit},
  );

  /// Get favorite menu items as hydrated views.
  _i3.Future<List<_i18.MenuItemView>> getFavoriteMenuItems({
    required int limit,
  }) => caller.callServerEndpoint<List<_i18.MenuItemView>>(
    'restaurant',
    'getFavoriteMenuItems',
    {'limit': limit},
  );

  /// Checks if a restaurant is favorited by the current user.
  _i3.Future<bool> isRestaurantFavorite(int restaurantId) =>
      caller.callServerEndpoint<bool>(
        'restaurant',
        'isRestaurantFavorite',
        {'restaurantId': restaurantId},
      );

  /// Confirms whether the freshly uploaded [pendingRestaurantId] should be
  /// merged into an existing [matchedRestaurantId] candidate. Called by the
  /// client after it shows the "is this the same place?" modal with the
  /// dedup candidates returned from [AiProcessingEndpoint.processMenuUpload].
  ///
  /// - `matchedId == null` → user rejected the match; keep the pending row.
  /// - `matchedId != null` → migrate this user's visit to the existing
  ///   restaurant, reassign categories/menu items, and delete the pending row.
  _i3.Future<int> confirmMatch(
    int pendingRestaurantId,
    int? matchedId,
  ) => caller.callServerEndpoint<int>(
    'restaurant',
    'confirmMatch',
    {
      'pendingRestaurantId': pendingRestaurantId,
      'matchedId': matchedId,
    },
  );
}

/// `UserAccountEndpoint` mixes a PUBLIC method (`checkEmailExists` —
/// called during the registration-vs-login branch in the merged Auth
/// screen, before any session exists) with AUTHENTICATED methods
/// (`getProfile`, `saveProfile`). Serverpod's `requireLogin` override
/// applies to the whole class, so we can't gate only the profile
/// methods that way. Instead we leave `requireLogin = false` (default)
/// and assert `session.authenticated` manually inside the protected
/// methods. See gotcha #22 for the rationale.
/// {@category Endpoint}
class EndpointUserAccount extends _i2.EndpointRef {
  EndpointUserAccount(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'userAccount';

  /// Checks if an email is already registered. Public by design —
  /// invoked when the client has no session yet (deciding whether
  /// Submit should attempt login or start registration).
  _i3.Future<bool> checkEmailExists(String email) =>
      caller.callServerEndpoint<bool>(
        'userAccount',
        'checkEmailExists',
        {'email': email},
      );

  /// Returns the caller's profile (full name + birth date captured in
  /// the post-registration wizard). Returns null if the profile wasn't
  /// set up yet — the client routes through ProfileSetupScreen in that
  /// case. Requires authentication.
  _i3.Future<_i19.AppUserProfile?> getProfile() =>
      caller.callServerEndpoint<_i19.AppUserProfile?>(
        'userAccount',
        'getProfile',
        {},
      );

  /// Upserts the caller's profile. Creates the row on first call (post-
  /// registration), overwrites the fields on subsequent calls (edit flow).
  /// Requires authentication.
  _i3.Future<_i19.AppUserProfile> saveProfile({
    required String fullName,
    DateTime? birthDate,
  }) => caller.callServerEndpoint<_i19.AppUserProfile>(
    'userAccount',
    'saveProfile',
    {
      'fullName': fullName,
      'birthDate': birthDate,
    },
  );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i2.EndpointRef {
  EndpointGreeting(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i3.Future<_i20.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i20.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Modules {
  Modules(Client client) {
    auth = _i21.Caller(client);
    serverpod_auth_idp = _i1.Caller(client);
    serverpod_auth_core = _i4.Caller(client);
  }

  late final _i21.Caller auth;

  late final _i1.Caller serverpod_auth_idp;

  late final _i4.Caller serverpod_auth_core;
}

class Client extends _i2.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i2.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i2.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i22.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    admin = EndpointAdmin(this);
    aiProcessing = EndpointAiProcessing(this);
    restaurant = EndpointRestaurant(this);
    userAccount = EndpointUserAccount(this);
    greeting = EndpointGreeting(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointAdmin admin;

  late final EndpointAiProcessing aiProcessing;

  late final EndpointRestaurant restaurant;

  late final EndpointUserAccount userAccount;

  late final EndpointGreeting greeting;

  late final Modules modules;

  @override
  Map<String, _i2.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'admin': admin,
    'aiProcessing': aiProcessing,
    'restaurant': restaurant,
    'userAccount': userAccount,
    'greeting': greeting,
  };

  @override
  Map<String, _i2.ModuleEndpointCaller> get moduleLookup => {
    'auth': modules.auth,
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
