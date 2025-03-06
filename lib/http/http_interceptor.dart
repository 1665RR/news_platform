import 'dart:async';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:news_app_project/authentication/services/token_service.dart';

class AuthInterceptor implements InterceptorContract {
  final SecureStorageService _storageService = SecureStorageService();

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    String? accessToken = await _storageService.getJwt();

    // Attach the access token to the request headers
    if (accessToken != null) {
      request.headers['Authorization'] = 'Bearer $accessToken';
    }

    // Set headers for HTTP methods
    request.headers['accept'] = '*/*';
    request.headers['Content-Type'] = 'application/json';
    request.headers['X-Api-Version'] = '1.0';

    return request;
  }

  @override
  Future<BaseResponse> interceptResponse(
      {required BaseResponse response}) async {
    // You can handle responses here if needed, e.g., checking token expiration or other response status codes.
    return response;
  }

  @override
  Future<bool> shouldInterceptRequest() {
    // TODO: implement shouldInterceptRequest
    throw UnimplementedError();
  }

  @override
  Future<bool> shouldInterceptResponse() {
    // TODO: implement shouldInterceptResponse
    throw UnimplementedError();
  }

}
