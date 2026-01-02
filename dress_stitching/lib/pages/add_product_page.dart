import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/product_controller.dart';
import '../controllers/auth_controller.dart';
import '../models/product.dart';

class AddProductPage extends StatefulWidget {
  final Product? product;
  final dynamic index;

  const AddProductPage({super.key, this.product, this.index});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  DateTime? _expiry;
  String? _imagePath;
  final pc = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    if (p != null) {
      _nameCtrl.text = p.name;
      _priceCtrl.text = p.price.toString();
      _expiry = p.expiryDate;
      _imagePath = p.imagePath;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 800);
    if (picked != null) {
      setState(() => _imagePath = picked.path);
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(context: context, initialDate: now, firstDate: DateTime(now.year - 1), lastDate: DateTime(now.year + 5));
    if (d != null) setState(() => _expiry = d);
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    final price = double.tryParse(_priceCtrl.text) ?? 0.0;
    final expiry = _expiry ?? DateTime.now();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a product name')));
      return;
    }
    final auth = Get.find<AuthController>();
    final owner = auth.currentUserEmail;
    final p = Product(name: name, imagePath: _imagePath, price: price, expiryDate: expiry, ownerEmail: owner);
    if (widget.index != null) {
      await pc.updateByKey(widget.index, p);
    } else {
      await pc.addProduct(p);
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Product name'),
              ),
              TextField(
                controller: _priceCtrl,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton(onPressed: _pickDate, child: const Text('Pick expiry date')),
                  const SizedBox(width: 12),
                  Text(_expiry == null ? 'No date' : _expiry!.toLocal().toString().split(' ').first),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton(onPressed: _pickImage, child: const Text('Pick image')),
                  const SizedBox(width: 12),
                  _imagePath != null ? Image.file(File(_imagePath!), width: 80, height: 80, fit: BoxFit.cover) : const SizedBox.shrink(),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _save, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
