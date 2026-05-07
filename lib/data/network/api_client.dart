import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:ongi_app/data/repositories/secure_storage_repository.dart';
import 'package:ongi_app/data/services/auth_service.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late Dio _dio;

  factory ApiClient() => _instance;

  ApiClient._internal() {
    final baseUrl = dotenv.get('base_url', fallback: 'http://localhost:8080/');

    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Token Interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final skip = options.extra['skipAuthToken'] == true;
          if (!skip) {
            final storage = GetIt.instance<SecureStorageRepository>();
            final token = await storage.readAccessToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
              log('[Interceptor] Authorization header 설정됨');
            } else {
              log('[Interceptor] 토큰 없음, path=${options.path}');
            }
          }
          return handler.next(options);
        } catch (e) {
          log('[Interceptor] onRequest 예외: $e');
          return handler.next(options);
        }
      },
      onResponse: (response, handler) {
        log(
            '[Interceptor] 응답 ${response.statusCode} — ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        final requestOptions = e.requestOptions;
        log(
            '[Interceptor] 에러 — path=${requestOptions.path}, status=${e.response?.statusCode}');

        if (requestOptions.extra['skipAuthToken'] == true) {
          log('[Interceptor] skipAuthToken=true, 재발급 시도 안 함');
          return handler.next(e);
        }

        if (requestOptions.extra['retry'] == true ||
            requestOptions.path.contains('reissue')) {
          log('[Interceptor] 재발급 요청 실패 또는 이미 재시도함. 중단.');
          return handler.reject(e);
        }

        if (e.response?.statusCode == 401) {
          try {
            log(
                '[Interceptor] 401 → 토큰 재발급 시도 (path=${requestOptions.path})');

            final authService = GetIt.instance<AuthService>();
            await authService.reissueToken();

            final storage = GetIt.instance<SecureStorageRepository>();
            final newToken = await storage.readAccessToken();
            if (newToken == null) throw Exception('재발급된 토큰이 없습니다.');

            log('[Interceptor] 토큰 재발급 성공 → 요청 재시도');
            final clonedRequest = await _dio.request(
              requestOptions.path,
              data: requestOptions.data,
              queryParameters: requestOptions.queryParameters,
              options: Options(
                method: requestOptions.method,
                responseType: requestOptions.responseType,
                headers: {
                  ...requestOptions.headers,
                  'Authorization': 'Bearer $newToken',
                },
                extra: {
                  ...requestOptions.extra,
                  'retry': true,
                  'skipAuthToken': true,
                },
              ),
            );
            return handler.resolve(clonedRequest);
          } catch (refreshError) {
            log('[Interceptor] 토큰 재발급 실패: $refreshError');
            return handler.reject(e);
          }
        }

        return handler.next(e);
      },
    ));

    // Log Interceptor
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      logPrint: (obj) => log('서버통신 $obj'),
    ));
  }

  Dio get dio => _dio;
}
