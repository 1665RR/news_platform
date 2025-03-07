import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';

import '../utils/debug_long_print.dart';
import '../authentication/services/expiry_token_retry_service.dart';
import 'http_interceptor.dart';


class HttpService {

  static http.Client _httpClient = InterceptedClient.build(
    interceptors: [
      AuthInterceptor(),
    ],
    retryPolicy: ExpiredTokenRetryPolicy(),
  );

  static final HttpService _instance = HttpService._();

  HttpService._();

  factory HttpService() {
    return _instance;
  }

  Future<http.Response> get(
      Uri url, {
        Map<String, String>? headers,
      }) async {
    debugLongPrint('GET: $url');
    return _httpClient
        .get(
      url,
      headers: headers,
    );
  }

  Future<http.Response> post(
      Uri url, {
        Map<String, String>? headers,
        Object? body,
      }) async {
    debugLongPrint('POST: $url');
    return _httpClient
        .post(
      url,
      headers: headers,
      body: body,
    );
  }

  Future<http.Response> delete(
      Uri url, {
        Map<String, String>? headers,
        Object? body,
      }) async {
    debugLongPrint('DELETE: $url');
    return _httpClient
        .delete(
      url,
      headers: headers,
      body: body,
    );
  }
}
