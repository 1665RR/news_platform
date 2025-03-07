import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:news_app_project/login/bloc/login_bloc.dart';

import '../../authentication/bloc/authentication_bloc.dart';
import '../../authentication/bloc/authentication_event.dart';
import '../../login/bloc/login_event.dart';
import '../../login/bloc/login_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          final errorMessage = state.error ?? 'Authentication Failure';
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
               SnackBar(content: Text(errorMessage)),
            );
        } else if(state.status.isSuccess) {
          context.read<AuthenticationBloc>().add(
            AuthenticationSubscriptionRequested(),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _EmailInput(controller: _emailController),
            const SizedBox(height: 16),
            _PasswordInput(controller: _passwordController),
            const SizedBox(height: 16),
            _LoginButton(
              emailController: _emailController,
              passwordController: _passwordController,
            ),
          ],
        ),
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
      (LoginBloc bloc) => bloc.state.email.displayError,
    );

    return TextField(
      controller: controller,
      key: const Key('loginForm_emailInput_textField'),
      onChanged: (email) {
        context.read<LoginBloc>().add(LoginEmailChanged(email));
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
      (LoginBloc bloc) => bloc.state.password.displayError,
    );

    return TextField(
      controller: controller,
      key: const Key('loginForm_passwordInput_textField'),
      onChanged: (password) {
        context.read<LoginBloc>().add(LoginPasswordChanged(password));
      },
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: displayError != null ? 'Invalid Password' : null,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _LoginButton({
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final isInProgressOrSuccess = context.select(
      (LoginBloc bloc) => bloc.state.status.isInProgressOrSuccess,
    );
    final isValid = context.select((LoginBloc bloc) => bloc.state.isValid);

    if (isInProgressOrSuccess) {
      return const CircularProgressIndicator();
    }

    return ElevatedButton(
      onPressed: isValid
          ? () {
              context.read<LoginBloc>().add(
                    const LoginSubmitted(),
                  );
            }
          : null,
      child: const Text('Login'),
    );
  }
}
