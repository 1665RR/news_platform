import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../../login/model/email.dart';
import '../model/password.dart';

final class RegisterState extends Equatable {
  const RegisterState({
    this.status = FormzSubmissionStatus.initial,
    this.firstName = '',
    this.lastName = '',
    this.phoneNumber = '',
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.isValid = false,
    this.error,
  });

  final FormzSubmissionStatus status;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final Email email;
  final Password password;
  final bool isValid;
  final String? error;

  RegisterState copyWith({
    FormzSubmissionStatus? status,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    Email? email,
    Password? password,
    bool? isValid,
    String? error,
  }) {
    return RegisterState(
      status: status ?? this.status,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    firstName,
    lastName,
    phoneNumber,
    email,
    password,
    isValid,
    error,
  ];
}
