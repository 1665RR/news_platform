import 'dart:async';
import 'dart:convert';
import 'package:news_app_project/authentication/services/token_service.dart';
import 'package:news_app_project/globals/constants/api_data_routes.dart';
import 'package:news_app_project/http/api_service.dart';

class AuthenticationRepository {
  final SecureStorageService _storageService = SecureStorageService();

  Future<String?> login({
    required String email,
    required String password,
    required String tenantId,
    required bool isGuest,
  }) async {
    final body = jsonEncode({
      'email': email,
      'password': password,
      'tenantId': tenantId,
      'isGuest': isGuest,
    });
    try {
      final response = await ApiService.post(
        "${ApiRoutes.auth}/token",
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accessToken = data['result']['accessToken']['token'];
        final refreshToken = data['result']['refreshToken']['token'];
        if (accessToken != null && refreshToken != null) {
          await _storageService.saveToken(
              jwt: accessToken, refreshToken: refreshToken);
          return accessToken;
        } else {
          throw Exception('Access or refresh token missing');
        }
      } else {
        throw Exception(
            'Failed to login with status code: ${response.statusCode}. Response body: ${response.body}');
      }
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
