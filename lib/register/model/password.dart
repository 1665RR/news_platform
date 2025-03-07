import 'package:formz/formz.dart';

enum PasswordValidationError { empty, tooShort, missingUpperCase, missingLowerCase, missingNumber, missingSpecialChar }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty(super.value) : super.dirty();

  static final _passwordRegExp = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#\$&*~])[A-Za-z0-9!@#\$&*~]{8,}$',
  );

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) return PasswordValidationError.empty;
    if (value.length < 8) return PasswordValidationError.tooShort;
    if (!RegExp(r'[A-Z]').hasMatch(value)) return PasswordValidationError.missingUpperCase;
    if (!RegExp(r'[a-z]').hasMatch(value)) return PasswordValidationError.missingLowerCase;
    if (!RegExp(r'[0-9]').hasMatch(value)) return PasswordValidationError.missingNumber;
    if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) return PasswordValidationError.missingSpecialChar;
    return null;
  }
}
