import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/authentication_bloc.dart';
import '../bloc/authentication_event.dart';
import '../bloc/authentication_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _tenantIdController = TextEditingController();
  bool _isGuest = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationLoading) {
          // Show loading indicator
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Logging in...'),
              duration: const Duration(milliseconds: 500),
            ),
          );
        } else if (state is AuthenticationSuccess) {
          // Handle successful login
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Login Successful'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AuthenticationError) {
          // Show error message on login failure
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login Failed: ${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _tenantIdController,
              decoration: InputDecoration(
                labelText: 'Tenant ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _isGuest,
                  onChanged: (value) {
                    setState(() {
                      _isGuest = value ?? false;
                    });
                  },
                ),
                const Text('Login as Guest'),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Trigger the login event when the button is pressed
                context.read<AuthenticationBloc>().add(
                  LoginEvent(
                    email: _emailController.text,
                    password: _passwordController.text,
                    tenantId: _tenantIdController.text,
                    isGuest: _isGuest,
                  ),
                );
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
