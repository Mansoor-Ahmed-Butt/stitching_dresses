import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../models/user.dart';
import 'product_controller.dart';

class AuthController extends GetxController {
  late Box<User> usersBox;
  late Box sessionBox;

  // Form controllers (used by SignIn/SignUp pages)
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    usersBox = Hive.box<User>('users');
    sessionBox = Hive.box('session');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  bool signUp(String email, String password) {
    if (usersBox.containsKey(email)) return false;
    final user = User(email: email, password: password);
    usersBox.put(email, user);
    return true;
  }

  bool signIn(String email, String password) {
    final user = usersBox.get(email);
    if (user == null) return false;
    if (user.password != password) return false;
    sessionBox.put('currentUser', email);
    if (Get.isRegistered<ProductController>()) {
      Get.find<ProductController>().loadProducts();
    }
    return true;
  }

  void signOut() {
    sessionBox.delete('currentUser');
    if (Get.isRegistered<ProductController>()) {
      Get.find<ProductController>().loadProducts();
    }
  }

  String? get currentUserEmail => sessionBox.get('currentUser') as String?;
}
