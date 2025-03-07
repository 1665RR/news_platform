import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/token_service.dart';
import 'authentication_event.dart';
import '../services/authentication_repository.dart';
import 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    required SecureStorageService secureStorageService,
  })
      : _authenticationRepository = authenticationRepository,
        _secureStorageService = secureStorageService,
        super(const AuthenticationState.unknown()) {
    on<AuthenticationSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthenticationLogoutPressed>(_onLogoutPressed);
  }

  final AuthenticationRepository _authenticationRepository;
  final SecureStorageService _secureStorageService;


  Future<void> _onSubscriptionRequested(
      AuthenticationSubscriptionRequested event,
      Emitter<AuthenticationState> emit,
      ) async {
    final token = await _tryGetToken();
    if (token != null) {
      return emit(const AuthenticationState.authenticated());
    }
    return emit.onEach(
      _authenticationRepository.status,
      onData: (status) async {
        switch (status) {
          case AuthenticationStatus.unauthenticated:
            return emit(const AuthenticationState.unauthenticated());
          case AuthenticationStatus.authenticated:
            return emit(const AuthenticationState.authenticated());
          case AuthenticationStatus.unknown:
            return emit(const AuthenticationState.unknown());
        }
      },
      onError: addError,
    );
  }

  void _onLogoutPressed(
      AuthenticationLogoutPressed event,
      Emitter<AuthenticationState> emit,
      ) {
    _authenticationRepository.logOut();
    emit(const AuthenticationState.unauthenticated());
  }

  Future<String?> _tryGetToken() async {
    try {
      final token = await _secureStorageService.getJwt();
      return token;
    } catch (_) {
      return null;
    }
  }
}