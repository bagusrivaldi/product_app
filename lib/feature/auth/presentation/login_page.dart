import 'package:bagus_project/core/widget/app_button.dart';
import 'package:bagus_project/core/widget/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController(text: 'emilys');
  final passwordController = TextEditingController(text: 'emilyspass');

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final authProvider = context.read<AuthProvider>();

    await authProvider.login(
      usernameController.text.trim(),
      passwordController.text.trim(),
    );

    if (!mounted) return;

    if (authProvider.user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppTextField(controller: usernameController, label: 'Username'),
            // TextField(
            //   controller: usernameController,
            //   decoration: const InputDecoration(
            //     labelText: 'Username',
            //     border: OutlineInputBorder(),
            //   ),
            // ),
            const SizedBox(height: 12),
            // TextField(
            //   controller: passwordController,
            //   obscureText: true,
            //   decoration: const InputDecoration(
            //     labelText: 'Password',
            //     border: OutlineInputBorder(),
            //   ),
            // ),
            AppTextField(
              controller: passwordController,
              label: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 12),
            if (authProvider.errorMessage != null)
              Text(
                authProvider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 12),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: authProvider.isLoading ? null : _login,
            //     child: authProvider.isLoading
            //         ? const CircularProgressIndicator()
            //         : const Text('Login'),
            //   ),
            // ),
            AppButton(
              onPressed: _login,
              title: 'Login',
              isLoading: authProvider.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
