import 'package:bangunarta_portal/core/auth/auth_repository.dart';
import 'package:bangunarta_portal/core/navigation/navigation_service.dart';
import 'package:bangunarta_portal/core/network/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

class DioClient {
  DioClient._();

  static final DioClient instance = DioClient._();

  void Function()? onUnauthorized;

  late final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {'Accept': 'application/json'},
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final token = await AuthRepository.instance.getAccessToken();

              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
              }

              handler.next(options);
            },
            onError: (error, handler) async {
              final statusCode = error.response?.statusCode;
              final requestOptions = error.requestOptions;
              final hasRetried = requestOptions.extra['retried'] == true;
              final isRefreshRequest =
                  requestOptions.path == ApiEndpoints.refresh;

              if (statusCode != 401 || hasRetried || isRefreshRequest) {
                handler.next(error);
                return;
              }

              try {
                final refreshedToken = await AuthRepository.instance
                    .refreshToken();
                final retryOptions = Options(
                  method: requestOptions.method,
                  headers: {
                    ...requestOptions.headers,
                    'Authorization': 'Bearer ${refreshedToken.accessToken}',
                  },
                  responseType: requestOptions.responseType,
                  contentType: requestOptions.contentType,
                  followRedirects: requestOptions.followRedirects,
                  validateStatus: requestOptions.validateStatus,
                  receiveDataWhenStatusError:
                      requestOptions.receiveDataWhenStatusError,
                  extra: {...requestOptions.extra, 'retried': true},
                );

                final response = await dio.request<dynamic>(
                  requestOptions.path,
                  data: requestOptions.data,
                  queryParameters: requestOptions.queryParameters,
                  options: retryOptions,
                );

                handler.resolve(response);
              } catch (_) {
                await AuthRepository.instance.logout();
                if (onUnauthorized != null) {
                  onUnauthorized!();
                } else {
                  _redirectToLogin();
                }
                handler.next(error);
              }
            },
          ),
        );

  void _redirectToLogin() {
    final context = NavigationService.navigatorKey.currentContext;

    if (context == null) return;

    GoRouter.of(context).go('/login');
  }
}
