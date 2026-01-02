import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/product_controller.dart';

class AuthBinding {
  void dependencies() {
    if (!Get.isRegistered<AuthController>()) Get.put(AuthController());
    if (!Get.isRegistered<ProductController>()) Get.put(ProductController());
  }
}
