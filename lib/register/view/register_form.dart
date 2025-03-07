import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:news_app_project/register/bloc/register_bloc.dart';
import 'package:news_app_project/register/bloc/register_event.dart';
import 'package:news_app_project/register/bloc/register_state.dart';

import '../../onboarding/confirm_email_page.dart';
import '../model/password.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          final errorMessage = state.error ?? 'Registration Failure';
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(errorMessage)),
            );
        } else if (state.status.isSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Registration Successful')),
            );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ConfirmationEmailPage(),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FirstNameInput(controller: _firstNameController),
            const SizedBox(height: 16),
            _LastNameInput(controller: _lastNameController),
            const SizedBox(height: 16),
            _PhoneNumberInput(controller: _phoneNumberController),
            const SizedBox(height: 16),
            _EmailInput(controller: _emailController),
            const SizedBox(height: 16),
            _PasswordInput(controller: _passwordController),
            const SizedBox(height: 16),
            _RegisterButton(
              firstNameController: _firstNameController,
              lastNameController: _lastNameController,
              phoneNumberController: _phoneNumberController,
              emailController: _emailController,
              passwordController: _passwordController,
            ),
          ],
        ),
      ),
    );
  }
}

class _FirstNameInput extends StatelessWidget {
  final TextEditingController controller;
  const _FirstNameInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (firstName) {
        context.read<RegisterBloc>().add(RegisterFirstNameChanged(firstName));
      },
      decoration: const InputDecoration(
        labelText: 'First Name',
        border: OutlineInputBorder(),
      ),
    );
  }
}

class _LastNameInput extends StatelessWidget {
  final TextEditingController controller;
  const _LastNameInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      key: const Key('registerForm_lastNameInput_textField'),
      onChanged: (lastName) {
        context.read<RegisterBloc>().add(RegisterLastNameChanged(lastName));
      },
      decoration: const InputDecoration(
        labelText: 'Last Name',
        border: OutlineInputBorder(),
      ),
    );
  }
}

class _PhoneNumberInput extends StatelessWidget {
  final TextEditingController controller;
  const _PhoneNumberInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      key: const Key('registerForm_phoneNumberInput_textField'),
      onChanged: (phoneNumber) {
        context.read<RegisterBloc>().add(RegisterPhoneNumberChanged(phoneNumber));
      },
      decoration: const InputDecoration(
        labelText: 'Phone Number',
        border: OutlineInputBorder(),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  final TextEditingController controller;
  const _EmailInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
          (RegisterBloc bloc) => bloc.state.email.displayError,
    );

    return TextField(
      controller: controller,
      key: const Key('registerForm_emailInput_textField'),
      onChanged: (email) {
        context.read<RegisterBloc>().add(RegisterEmailChanged(email));
      },
      decoration: InputDecoration(
        labelText: 'Email',
        errorText: displayError != null ? 'Invalid Email' : null,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  final TextEditingController controller;
  const _PasswordInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
          (RegisterBloc bloc) => bloc.state.password.displayError,
    );
    String? mapPasswordError(PasswordValidationError? error) {
      switch (error) {
        case PasswordValidationError.empty:
          return 'Password cannot be empty.';
        case PasswordValidationError.tooShort:
          return 'Password must be at least 8 characters long.';
        case PasswordValidationError.missingUpperCase:
          return 'Password must contain at least one uppercase letter.';
        case PasswordValidationError.missingLowerCase:
          return 'Password must contain at least one lowercase letter.';
        case PasswordValidationError.missingNumber:
          return 'Password must contain at least one number.';
        case PasswordValidationError.missingSpecialChar:
          return 'Password must contain at least one special character.';
        default:
          return null;
      }
    }

    return TextField(
      controller: controller,
      key: const Key('registerForm_passwordInput_textField'),
      onChanged: (password) {
        context.read<RegisterBloc>().add(RegisterPasswordChanged(password));
      },
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: mapPasswordError(displayError),
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneNumberController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _RegisterButton({
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneNumberController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final isInProgressOrSuccess = context.select(
          (RegisterBloc bloc) => bloc.state.status.isInProgressOrSuccess,
    );
    final isValid = context.select((RegisterBloc bloc) => bloc.state.isValid);

    if (isInProgressOrSuccess) {
      return const CircularProgressIndicator();
    }

    return ElevatedButton(
      onPressed: isValid
          ? () {
        context.read<RegisterBloc>().add(const RegisterSubmitted());
      }
          : null,
      child: const Text('Register'),
    );
  }
}

