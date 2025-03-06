abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {
  final String error;

  AuthenticationError(this.error);
}

class AuthenticationSuccess extends AuthenticationState {
  final String token;

  AuthenticationSuccess({required this.token});
}