import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_project/authentication/bloc/authentication_bloc.dart';

import '../services/authentication_repository.dart';
import 'login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocProvider(
          create: (context) => AuthenticationBloc(
             context.read<AuthenticationRepository>(),
          ),
          child: const LoginForm(),
        ),
      ),
    );
  }
}