import 'package:flutter/material.dart';
import 'package:news_app_project/login/view/login_page.dart';

import '../register/view/register_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _LoginRegisterPageState();

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const OnboardingPage());
  }

}

class _LoginRegisterPageState extends State<OnboardingPage> {
  bool isLoginView = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoginView ? const LoginPage() : const RegisterPage(),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                setState(() {
                  isLoginView = !isLoginView;
                });
              },
              child: Text(
                isLoginView
                    ? 'Don\'t have an account? Register'
                    : 'Already have an account? Login',
                style: const TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
