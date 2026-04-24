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
import 'package:serverpod/serverpod.dart' as _i1;
import '../auth/email_idp_endpoint.dart' as _i2;
import '../auth/jwt_refresh_endpoint.dart' as _i3;
import '../endpoints/admin_endpoint.dart' as _i4;
import '../endpoints/ai_processing_endpoint.dart' as _i5;
import '../endpoints/restaurant_endpoint.dart' as _i6;
import '../endpoints/user_account_endpoint.dart' as _i7;
import '../greetings/greeting_endpoint.dart' as _i8;
import 'package:menu_assistant_server/src/generated/menu_page_input.dart'
    as _i9;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i10;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i11;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i12;
import 'package:menu_assistant_server/src/generated/future_calls.dart' as _i13;
export 'future_calls.dart' show ServerpodFutureCallsGetter;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'emailIdp': _i2.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _i3.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'admin': _i4.AdminEndpoint()
        ..initialize(
          server,
          'admin',
          null,
        ),
      'aiProcessing': _i5.AiProcessingEndpoint()
        ..initialize(
          server,
          'aiProcessing',
          null,
        ),
      'restaurant': _i6.RestaurantEndpoint()
        ..initialize(
          server,
          'restaurant',
          null,
        ),
      'userAccount': _i7.UserAccountEndpoint()
        ..initialize(
          server,
          'userAccount',
          null,
        ),
      'greeting': _i8.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['emailIdp'] = _i1.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'startRegistration': _i1.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _i1.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _i1.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _i1.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _i1.ParameterDescription(
              name: 'refreshToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['jwtRefresh'] as _i3.JwtRefreshEndpoint)
                  .refreshAccessToken(
                    session,
                    refreshToken: params['refreshToken'],
                  ),
        ),
      },
    );
    connectors['admin'] = _i1.EndpointConnector(
      name: 'admin',
      endpoint: endpoints['admin']!,
      methodConnectors: {
        'getMetrics': _i1.MethodConnector(
          name: 'getMetrics',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).getMetrics(session),
        ),
        'listRestaurants': _i1.MethodConnector(
          name: 'listRestaurants',
          params: {
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'search': _i1.ParameterDescription(
              name: 'search',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).listRestaurants(
                    session,
                    offset: params['offset'],
                    limit: params['limit'],
                    search: params['search'],
                  ),
        ),
        'listUsers': _i1.MethodConnector(
          name: 'listUsers',
          params: {
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'search': _i1.ParameterDescription(
              name: 'search',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint).listUsers(
                session,
                offset: params['offset'],
                limit: params['limit'],
                search: params['search'],
              ),
        ),
        'listCuratedDishes': _i1.MethodConnector(
          name: 'listCuratedDishes',
          params: {
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'cuisine': _i1.ParameterDescription(
              name: 'cuisine',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'search': _i1.ParameterDescription(
              name: 'search',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).listCuratedDishes(
                    session,
                    status: params['status'],
                    cuisine: params['cuisine'],
                    search: params['search'],
                    offset: params['offset'],
                    limit: params['limit'],
                  ),
        ),
        'updateCuratedDish': _i1.MethodConnector(
          name: 'updateCuratedDish',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'displayName': _i1.ParameterDescription(
              name: 'displayName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'cuisine': _i1.ParameterDescription(
              name: 'cuisine',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'countryCode': _i1.ParameterDescription(
              name: 'countryCode',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'courseType': _i1.ParameterDescription(
              name: 'courseType',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).updateCuratedDish(
                    session,
                    params['id'],
                    displayName: params['displayName'],
                    cuisine: params['cuisine'],
                    countryCode: params['countryCode'],
                    courseType: params['courseType'],
                    description: params['description'],
                    status: params['status'],
                  ),
        ),
        'listDishCatalog': _i1.MethodConnector(
          name: 'listDishCatalog',
          params: {
            'linked': _i1.ParameterDescription(
              name: 'linked',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
            'search': _i1.ParameterDescription(
              name: 'search',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).listDishCatalog(
                    session,
                    linked: params['linked'],
                    search: params['search'],
                    offset: params['offset'],
                    limit: params['limit'],
                  ),
        ),
        'listTranslations': _i1.MethodConnector(
          name: 'listTranslations',
          params: {
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'search': _i1.ParameterDescription(
              name: 'search',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).listTranslations(
                    session,
                    language: params['language'],
                    search: params['search'],
                    offset: params['offset'],
                    limit: params['limit'],
                  ),
        ),
        'upsertTranslation': _i1.MethodConnector(
          name: 'upsertTranslation',
          params: {
            'curatedDishId': _i1.ParameterDescription(
              name: 'curatedDishId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).upsertTranslation(
                    session,
                    curatedDishId: params['curatedDishId'],
                    language: params['language'],
                    name: params['name'],
                    description: params['description'],
                  ),
        ),
        'listLowQualityPhotos': _i1.MethodConnector(
          name: 'listLowQualityPhotos',
          params: {
            'maxQuality': _i1.ParameterDescription(
              name: 'maxQuality',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .listLowQualityPhotos(
                    session,
                    maxQuality: params['maxQuality'],
                    offset: params['offset'],
                    limit: params['limit'],
                  ),
        ),
        'setPhotoQuality': _i1.MethodConnector(
          name: 'setPhotoQuality',
          params: {
            'imageId': _i1.ParameterDescription(
              name: 'imageId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'qualityScore': _i1.ParameterDescription(
              name: 'qualityScore',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).setPhotoQuality(
                    session,
                    params['imageId'],
                    params['qualityScore'],
                  ),
        ),
        'deletePhoto': _i1.MethodConnector(
          name: 'deletePhoto',
          params: {
            'imageId': _i1.ParameterDescription(
              name: 'imageId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint).deletePhoto(
                session,
                params['imageId'],
              ),
        ),
        'listAuditLog': _i1.MethodConnector(
          name: 'listAuditLog',
          params: {
            'actorEmail': _i1.ParameterDescription(
              name: 'actorEmail',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'objectType': _i1.ParameterDescription(
              name: 'objectType',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'action': _i1.ParameterDescription(
              name: 'action',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint).listAuditLog(
                session,
                actorEmail: params['actorEmail'],
                objectType: params['objectType'],
                action: params['action'],
                offset: params['offset'],
                limit: params['limit'],
              ),
        ),
        'listMenuQueue': _i1.MethodConnector(
          name: 'listMenuQueue',
          params: {
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'search': _i1.ParameterDescription(
              name: 'search',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).listMenuQueue(
                    session,
                    status: params['status'],
                    search: params['search'],
                    offset: params['offset'],
                    limit: params['limit'],
                  ),
        ),
        'getMenuForValidation': _i1.MethodConnector(
          name: 'getMenuForValidation',
          params: {
            'restaurantId': _i1.ParameterDescription(
              name: 'restaurantId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getMenuForValidation(
                    session,
                    params['restaurantId'],
                  ),
        ),
        'updateMenuItem': _i1.MethodConnector(
          name: 'updateMenuItem',
          params: {
            'itemId': _i1.ParameterDescription(
              name: 'itemId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'price': _i1.ParameterDescription(
              name: 'price',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'approvalStatus': _i1.ParameterDescription(
              name: 'approvalStatus',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).updateMenuItem(
                    session,
                    params['itemId'],
                    name: params['name'],
                    price: params['price'],
                    approvalStatus: params['approvalStatus'],
                  ),
        ),
        'updateCategory': _i1.MethodConnector(
          name: 'updateCategory',
          params: {
            'categoryId': _i1.ParameterDescription(
              name: 'categoryId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'approvalStatus': _i1.ParameterDescription(
              name: 'approvalStatus',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).updateCategory(
                    session,
                    params['categoryId'],
                    name: params['name'],
                    approvalStatus: params['approvalStatus'],
                  ),
        ),
        'approveMenu': _i1.MethodConnector(
          name: 'approveMenu',
          params: {
            'restaurantId': _i1.ParameterDescription(
              name: 'restaurantId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint).approveMenu(
                session,
                params['restaurantId'],
              ),
        ),
        'rejectMenu': _i1.MethodConnector(
          name: 'rejectMenu',
          params: {
            'restaurantId': _i1.ParameterDescription(
              name: 'restaurantId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'reason': _i1.ParameterDescription(
              name: 'reason',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint).rejectMenu(
                session,
                params['restaurantId'],
                params['reason'],
              ),
        ),
      },
    );
    connectors['aiProcessing'] = _i1.EndpointConnector(
      name: 'aiProcessing',
      endpoint: endpoints['aiProcessing']!,
      methodConnectors: {
        'processMenuUpload': _i1.MethodConnector(
          name: 'processMenuUpload',
          params: {
            'fileName': _i1.ParameterDescription(
              name: 'fileName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'fileBytes': _i1.ParameterDescription(
              name: 'fileBytes',
              type: _i1.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['aiProcessing'] as _i5.AiProcessingEndpoint)
                  .processMenuUpload(
                    session,
                    params['fileName'],
                    params['fileBytes'],
                  ),
        ),
        'processMultiPageMenu': _i1.MethodConnector(
          name: 'processMultiPageMenu',
          params: {
            'pages': _i1.ParameterDescription(
              name: 'pages',
              type: _i1.getType<List<_i9.MenuPageInput>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['aiProcessing'] as _i5.AiProcessingEndpoint)
                  .processMultiPageMenu(
                    session,
                    params['pages'],
                  ),
        ),
      },
    );
    connectors['restaurant'] = _i1.EndpointConnector(
      name: 'restaurant',
      endpoint: endpoints['restaurant']!,
      methodConnectors: {
        'getRestaurantRevision': _i1.MethodConnector(
          name: 'getRestaurantRevision',
          params: {
            'restaurantId': _i1.ParameterDescription(
              name: 'restaurantId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['restaurant'] as _i6.RestaurantEndpoint)
                  .getRestaurantRevision(
                    session,
                    params['restaurantId'],
                  ),
        ),
        'getAllRestaurants': _i1.MethodConnector(
          name: 'getAllRestaurants',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['restaurant'] as _i6.RestaurantEndpoint)
                  .getAllRestaurants(session),
        ),
        'getRestaurantById': _i1.MethodConnector(
          name: 'getRestaurantById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['restaurant'] as _i6.RestaurantEndpoint)
                  .getRestaurantById(
                    session,
                    params['id'],
                  ),
        ),
        'getCategoriesForRestaurant': _i1.MethodConnector(
          name: 'getCategoriesForRestaurant',
          params: {
            'restaurantId': _i1.ParameterDescription(
              name: 'restaurantId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['restaurant'] as _i6.RestaurantEndpoint)
                  .getCategoriesForRestaurant(
                    session,
                    params['restaurantId'],
                  ),
        ),
        'getMenuItemsForCategory': _i1.MethodConnector(
          name: 'getMenuItemsForCategory',
          params: {
            'categoryId': _i1.ParameterDescription(
              name: 'categoryId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['restaurant'] as _i6.RestaurantEndpoint)
                  .getMenuItemsForCategory(
                    session,
                    params['categoryId'],
                  ),
        ),
        'toggleRestaurantFavorite': _i1.MethodConnector(
          name: 'toggleRestaurantFavorite',
          params: {
            'restaurantId': _i1.ParameterDescription(
              name: 'restaurantId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['restaurant'] as _i6.RestaurantEndpoint)
                  .toggleRestaurantFavorite(
                    session,
                    params['restaurantId'],
                  ),
        ),
        'toggleMenuItemFavorite': _i1.MethodConnector(
          name: 'toggleMenuItemFavorite',
          params: {
            'menuItemId': _i1.ParameterDescription(
              name: 'menuItemId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['restaurant'] as _i6.RestaurantEndpoint)
                  .toggleMenuItemFavorite(
                    session,
                    params['menuItemId'],
                  ),
        ),
        'getFavoriteRestaurants': _i1.MethodConnector(
          name: 'getFavoriteRestaurants',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['restaurant'] as _i6.RestaurantEndpoint)
                  .getFavoriteRestaurants(
                    session,
                    limit: params['limit'],
                  ),
        ),
        'getFavoriteMenuItems': _i1.MethodConnector(
          name: 'getFavoriteMenuItems',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['restaurant'] as _i6.RestaurantEndpoint)
                  .getFavoriteMenuItems(
                    session,
                    limit: params['limit'],
                  ),
        ),
        'isRestaurantFavorite': _i1.MethodConnector(
          name: 'isRestaurantFavorite',
          params: {
            'restaurantId': _i1.ParameterDescription(
              name: 'restaurantId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['restaurant'] as _i6.RestaurantEndpoint)
                  .isRestaurantFavorite(
                    session,
                    params['restaurantId'],
                  ),
        ),
        'confirmMatch': _i1.MethodConnector(
          name: 'confirmMatch',
          params: {
            'pendingRestaurantId': _i1.ParameterDescription(
              name: 'pendingRestaurantId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'matchedId': _i1.ParameterDescription(
              name: 'matchedId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['restaurant'] as _i6.RestaurantEndpoint)
                  .confirmMatch(
                    session,
                    params['pendingRestaurantId'],
                    params['matchedId'],
                  ),
        ),
      },
    );
    connectors['userAccount'] = _i1.EndpointConnector(
      name: 'userAccount',
      endpoint: endpoints['userAccount']!,
      methodConnectors: {
        'checkEmailExists': _i1.MethodConnector(
          name: 'checkEmailExists',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userAccount'] as _i7.UserAccountEndpoint)
                  .checkEmailExists(
                    session,
                    params['email'],
                  ),
        ),
        'getProfile': _i1.MethodConnector(
          name: 'getProfile',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userAccount'] as _i7.UserAccountEndpoint)
                  .getProfile(session),
        ),
        'saveProfile': _i1.MethodConnector(
          name: 'saveProfile',
          params: {
            'fullName': _i1.ParameterDescription(
              name: 'fullName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'birthDate': _i1.ParameterDescription(
              name: 'birthDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userAccount'] as _i7.UserAccountEndpoint)
                  .saveProfile(
                    session,
                    fullName: params['fullName'],
                    birthDate: params['birthDate'],
                  ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _i8.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    modules['serverpod_auth'] = _i10.Endpoints()..initializeEndpoints(server);
    modules['serverpod_auth_idp'] = _i11.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i12.Endpoints()
      ..initializeEndpoints(server);
  }

  @override
  _i1.FutureCallDispatch? get futureCalls {
    return _i13.FutureCalls();
  }
}
