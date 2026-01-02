import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../controllers/auth_controller.dart';
import '../controllers/product_controller.dart';

class HomePage extends GetView<ProductController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final pc = controller;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            tooltip: 'Set session key',
            onPressed: () async {
              final box = Hive.box('session');
              await box.put('key', 'test-${DateTime.now().toIso8601String()}');
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('{session["key"] }set')));
            },
            icon: const Icon(Icons.save),
          ),
          IconButton(
            onPressed: () {
              auth.signOut();
              context.go('/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: Hive.box('session').listenable(),
            builder: (_, Box box, __) {
              final val = box.get('key');
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline),
                    const SizedBox(width: 8),
                    Expanded(child: Text(val?.toString() ?? 'No session value', style: Theme.of(context).textTheme.bodyMedium)),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: Obx(() {
              final products = pc.products;
              if (products.isEmpty) {
                return const Center(child: Text('No products yet'));
              }
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final entry = products[index];
                  final p = entry.value;
                  return ListTile(
                    leading: p.imagePath != null
                        ? Image.file(File(p.imagePath!), width: 56, height: 56, fit: BoxFit.cover)
                        : const Icon(Icons.image_not_supported),
                    title: Text(p.name),
                    subtitle: Text('Price: \$${p.price.toStringAsFixed(2)}\nExpiry: ${p.expiryDate.toLocal().toString().split(' ').first}'),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Print / Preview',
                          icon: const Icon(Icons.print),
                          onPressed: () async {
                            await context.push('/receipt', extra: {'product': p});
                          },
                        ),

                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            await context.push('/add', extra: {'product': p, 'index': entry.key});
                            pc.loadProducts();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            final ok =
                                await showDialog<bool>(
                                  context: context,
                                  builder: (c) => AlertDialog(
                                    title: const Text('Delete'),
                                    content: const Text('Delete this product?'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('Cancel')),
                                      TextButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('Delete')),
                                    ],
                                  ),
                                ) ??
                                false;
                            if (ok) {
                              await pc.deleteByKey(entry.key);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/add');
          pc.loadProducts();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
