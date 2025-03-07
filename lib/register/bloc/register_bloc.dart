import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:news_app_project/register/bloc/register_event.dart';

import '../../authentication/services/authentication_repository.dart';
import '../../login/model/email.dart';
import '../model/password.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const RegisterState()) {
    on<RegisterFirstNameChanged>(_onFirstNameChanged);
    on<RegisterLastNameChanged>(_onLastNameChanged);
    on<RegisterPhoneNumberChanged>(_onPhoneNumberChanged);
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterSubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onFirstNameChanged(
      RegisterFirstNameChanged event,
      Emitter<RegisterState> emit,
      ) {
    emit(
      state.copyWith(
        firstName: event.firstName,
        isValid: Formz.validate([state.password, state.email]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  void _onLastNameChanged(
      RegisterLastNameChanged event,
      Emitter<RegisterState> emit,
      ) {
    emit(
      state.copyWith(
        lastName: event.lastName,
        isValid: Formz.validate([state.password, state.email]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  void _onPhoneNumberChanged(
      RegisterPhoneNumberChanged event,
      Emitter<RegisterState> emit,
      ) {
    emit(
      state.copyWith(
        phoneNumber: event.phoneNumber,
        isValid: Formz.validate([state.password, state.email]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  void _onEmailChanged(
      RegisterEmailChanged event,
      Emitter<RegisterState> emit,
      ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([state.password, email]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  void _onPasswordChanged(
      RegisterPasswordChanged event,
      Emitter<RegisterState> emit,
      ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([password, state.email]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  Future<void> _onSubmitted(
      RegisterSubmitted event,
      Emitter<RegisterState> emit,
      ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        await _authenticationRepository.register(
          firstName: state.firstName,
          lastName: state.lastName,
          phoneNumber: state.phoneNumber,
          email: state.email.value,
          password: state.password.value,
        );
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } catch (e) {
        emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          error: e.toString(),
        ));
      }
    }
  }
}
