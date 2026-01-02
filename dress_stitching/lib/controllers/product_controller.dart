import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../models/product.dart';
import 'auth_controller.dart';

class ProductController extends GetxController {
  late Box<Product> productsBox;
  // store entries (key -> Product) so we can update/delete specific keys
  var products = <MapEntry<dynamic, Product>>[].obs;

  @override
  void onInit() {
    super.onInit();
    productsBox = Hive.box<Product>('products');
    loadProducts();
  }

  void loadProducts() {
    final current = Get.find<AuthController>().currentUserEmail;
    if (current == null) {
      products.value = [];
      return;
    }
    final map = productsBox.toMap();
    products.value = map.entries.where((e) => e.value.ownerEmail == current).toList();
  }

  Future<void> addProduct(Product p) async {
    await productsBox.add(p);
    loadProducts();
  }

  Future<void> updateByKey(dynamic key, Product p) async {
    await productsBox.put(key, p);
    loadProducts();
  }

  Future<void> deleteByKey(dynamic key) async {
    await productsBox.delete(key);
    loadProducts();
  }
}
