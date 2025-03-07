import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_project/register/bloc/register_bloc.dart';
import 'package:news_app_project/register/view/register_form.dart';

import '../../authentication/services/authentication_repository.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const RegisterPage());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: BlocProvider(
        create: (context) => RegisterBloc(
          authenticationRepository: context.read<AuthenticationRepository>(),
        ),
        child: const RegisterForm(),
      ),
    );
  }
}
