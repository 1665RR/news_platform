import 'package:http/http.dart';
import 'package:http_interceptor/models/retry_policy.dart';
import 'package:news_app_project/authentication/services/token_service.dart';

import '../../main.dart';
import '../../utils/debug_long_print.dart';
import '../../utils/parse_jwt_token.dart';
import '../model/token_model.dart';
import 'authentication_repository.dart';

class ExpiredTokenRetryPolicy extends RetryPolicy {
  @override
  int get maxRetryAttempts => 2;

  final SecureStorageService _storageService = SecureStorageService();
  final SecureStorageService _tokenService = SecureStorageService();

  /// determines whether the request should be retried based on an exception - right now it doesn't retry request
  @override
  Future<bool> shouldAttemptRetryOnException(
      Exception reason, BaseRequest request) async {
    debugLongPrint(reason.toString());
    return false;
  }

  /// adds delay between retries based on retry attempt
  delayRetryAttemptOnResponse({required int retryAttempt}) {
    return const Duration(milliseconds: 250) * 4;
  }

  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    /// check if the response indicates the token has expired
    if (response.statusCode == 401) {
      debugLongPrint('Retrying request...');

      /// attempt to refresh the access token
      String? refreshToken = await _tokenService.getRefreshToken();
      if (refreshToken == null) {
        return false;
      }

      /// if the refresh token is expired, return failure
      if (Jwt.isExpired(refreshToken)) {
        return false;
      } else {
        /// call API to refresh the tokens
        final token =
            await AuthenticationRepository.refreshTokens(token: refreshToken);

        /// if the new tokens are returned, save them and return success
        if (token is TokenModel) {
          _tokenService.saveToken(
              jwt: token.accessToken, refreshToken: token.refreshToken);
          return true;
        } else {
          return false;
        }
      }
    }

    /// no need to retry for non-401 responses
    return false;
  }
}
