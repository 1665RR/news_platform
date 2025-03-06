sealed class AuthenticationEvent {
  const AuthenticationEvent();
}

final class LoginEvent extends AuthenticationEvent {
  final String email;
  final String password;
  final String tenantId;
  final bool isGuest;

  const LoginEvent({
    required this.email,
    required this.password,
    required this.tenantId,
    required this.isGuest,
  });

}

class RegisterEvent extends AuthenticationEvent {}

class LogoutEvent extends AuthenticationEvent {}
