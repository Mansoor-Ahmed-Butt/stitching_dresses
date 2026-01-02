import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../services/notification_service.dart';
import '../controllers/auth_controller.dart';

class SignInPage extends GetView<AuthController> {
  const SignInPage({super.key});

  void _login(BuildContext context) {
    final email = controller.emailController.text.trim();
    final pass = controller.passwordController.text;
    final ok = controller.signIn(email, pass);
    if (ok) {
      context.go('/home');
    } else {
      final navCtx = NotificationService.instance.navigatorKey.currentContext;
      if (navCtx != null) {
        ScaffoldMessenger.of(navCtx).showSnackBar(const SnackBar(content: Text('Invalid credentials')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: controller.passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => _login(context), child: const Text('Sign In')),
            TextButton(onPressed: () => context.push('/signup'), child: const Text('Create account')),
          ],
        ),
      ),
    );
  }
}
