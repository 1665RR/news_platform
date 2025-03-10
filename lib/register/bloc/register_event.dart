import 'package:equatable/equatable.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

final class RegisterFirstNameChanged extends RegisterEvent {
  const RegisterFirstNameChanged(this.firstName);

  final String firstName;

  @override
  List<Object> get props => [firstName];
}

final class RegisterLastNameChanged extends RegisterEvent {
  const RegisterLastNameChanged(this.lastName);

  final String lastName;

  @override
  List<Object> get props => [lastName];
}

final class RegisterPhoneNumberChanged extends RegisterEvent {
  const RegisterPhoneNumberChanged(this.phoneNumber);

  final String phoneNumber;

  @override
  List<Object> get props => [phoneNumber];
}

final class RegisterEmailChanged extends RegisterEvent {
  const RegisterEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

final class RegisterPasswordChanged extends RegisterEvent {
  const RegisterPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

final class RegisterSubmitted extends RegisterEvent {
  const RegisterSubmitted();
}
