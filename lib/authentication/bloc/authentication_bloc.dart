import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../services/token_service.dart';
import 'authentication_event.dart';
import '../services/authentication_repository.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;
  final SecureStorageService _storageService = SecureStorageService();

  AuthenticationBloc(this.authenticationRepository)
      : super(AuthenticationInitial()) {
    on<LoginEvent>(_onLogin);
//    on<RegisterEvent>(_onRegister);
    //   on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLogin(
      LoginEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      final response = await authenticationRepository.login(
        email: event.email,
        password: event.password,
        tenantId: event.tenantId,
        isGuest: event.isGuest,
      );
      if (response != null) {
        emit(AuthenticationSuccess(
          token: response,
        ));
      } else {
        emit(AuthenticationUnauthenticated());
      }
    } catch (e) {
      emit(AuthenticationError(e.toString()));
    }
  }
}
