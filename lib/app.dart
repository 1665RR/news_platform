import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:news_app_project/splash/view/splash_page.dart';
import 'package:toastification/toastification.dart';

import 'authentication/bloc/authentication_bloc.dart';
import 'authentication/bloc/authentication_state.dart';
import 'authentication/home/view/home_page.dart';
import 'authentication/services/authentication_repository.dart';
import 'authentication/view/login_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthenticationRepository()),
      ],
      child: BlocProvider(
        lazy: false,
        create: (context) => AuthenticationBloc(
          context.read<AuthenticationRepository>(),
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationSuccess) {
              _navigator.pushAndRemoveUntil<void>(
                HomePage.route(),
                (route) => false,
              );
            } else if (state is AuthenticationUnauthenticated) {
              _navigator.pushAndRemoveUntil<void>(
                LoginPage.route(),
                (route) => false,
              );
            } else if (state is AuthenticationError) {
              toastification.show(
                context: context,
                title: const Text("Authentication Error"),
                description: Text(state.error),
                backgroundColor: Colors.red,
                icon: const Icon(Icons.error, color: Colors.white),
                type: ToastificationType.error,
                autoCloseDuration: const Duration(seconds: 4),
              );
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => LoginPage.route(),
    );
  }
}
