import 'dart:async';
import 'dart:convert';
import 'package:news_app_project/authentication/services/token_service.dart';
import 'package:news_app_project/globals/constants/api_data_routes.dart';
import 'package:news_app_project/http/api_service.dart';

import '../../globals/constants/contants.dart';
import '../../utils/debug_long_print.dart';
import '../model/token_model.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final SecureStorageService _storageService = SecureStorageService();
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<String?> login({
    required String email,
    required String password,
    required bool isGuest,
  }) async {
    final body = jsonEncode({
      'email': email,
      'password': password,
      'tenantId': AppConstants.tenantId,
      'isGuest': isGuest,
    });
    try {
      final response = await ApiService.post(
        "${ApiRoutes.auth}/token",
        body: body,
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final accessToken = data['result']['accessToken']['token'];
        final refreshToken = data['result']['refreshToken']['token'];
        _controller.add(AuthenticationStatus.authenticated);
        if (accessToken != null && refreshToken != null) {
          await _storageService.saveToken(
              jwt: accessToken, refreshToken: refreshToken);
          return accessToken;
        } else {
          throw Exception('Access or refresh token missing');
        }
      } else {
        if (data['errors'] != null &&
            data['errors'] is List &&
            (data['errors'] as List).isNotEmpty) {
          throw Exception('${data['errors'].join(", ")}');
        } else {
          throw Exception(
              'Failed to login with status code: ${response.statusCode}.');
        }
      }
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    }
  }

  static Future<TokenModel?> refreshTokens({required String token}) async {
    final body = jsonEncode({
      'email': token,
      'tenantId': AppConstants.tenantId,
    });
    final response = await ApiService.post(
      "${ApiRoutes.auth}/token-refresh",
      body: body,
    );
    debugLongPrint("Response: ${response.body}");

    if (response.statusCode == 200) {
      return TokenModel.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  Future<bool> register({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    final body = jsonEncode({
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'password': password,
      'tenantId': AppConstants.tenantId,
    });

    try {
      final response = await ApiService.post(
        "${ApiRoutes.account}/register",
        body: body,
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return true;
      } else {
        if (data['errors'] != null &&
            data['errors'] is List &&
            (data['errors'] as List).isNotEmpty) {
          throw Exception('${data['errors'].join(", ")}');
        } else {
          throw Exception(
              'Failed to register with status code: ${response.statusCode}.');
        }
      }
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    }
  }

  Future<void> logOut() async {
    await _storageService.deleteTokens();
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
