import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../services/notification_service.dart';

import '../controllers/auth_controller.dart';

class SignUpPage extends GetView<AuthController> {
  const SignUpPage({super.key});

  void _signup(BuildContext context) {
    final email = controller.emailController.text.trim();
    final pass = controller.passwordController.text;
    final ok = controller.signUp(email, pass);
    final navCtx = NotificationService.instance.navigatorKey.currentContext;
    if (ok) {
      if (navCtx != null) ScaffoldMessenger.of(navCtx).showSnackBar(const SnackBar(content: Text('Account created')));
      controller.emailController.clear();
      controller.passwordController.clear();
      context.pop();
    } else {
      if (navCtx != null) ScaffoldMessenger.of(navCtx).showSnackBar(const SnackBar(content: Text('Account already exists')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
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
            ElevatedButton(onPressed: () => _signup(context), child: const Text('Sign Up')),
          ],
        ),
      ),
    );
  }
}
