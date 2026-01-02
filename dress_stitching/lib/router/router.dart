import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../bindings/auth_binding.dart';
import '../pages/sign_in_page.dart';
import '../pages/sign_up_page.dart';
import '../pages/home_page.dart';
import '../pages/add_product_page.dart';
import '../pages/receipt_page.dart';
import '../models/product.dart';

class AppRouter {
  static final router = GoRouter(
    navigatorKey: NotificationService.instance.navigatorKey,
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) {
          AuthBinding().dependencies();
          return const SignInPage();
        },
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) {
          AuthBinding().dependencies();
          return const SignUpPage();
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          AuthBinding().dependencies();
          return const HomePage();
        },
      ),
      GoRoute(
        path: '/add',
        builder: (context, state) {
          AuthBinding().dependencies();
          final extra = state.extra as Map<String, dynamic>?;
          final product = extra == null ? null : extra['product'] as Product?;
          final index = extra == null ? null : extra['index'] as int?;
          return AddProductPage(product: product, index: index);
        },
      ),
      GoRoute(
        path: '/receipt',
        builder: (context, state) {
          AuthBinding().dependencies();
          final extra = state.extra as Map<String, dynamic>?;
          final product = extra == null ? null : extra['product'] as Product?;
          if (product == null) return const SizedBox.shrink();
          return ReceiptPage(product: product);
        },
      ),
    ],
  );
}
