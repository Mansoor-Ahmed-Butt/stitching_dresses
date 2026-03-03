import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/dress_costing_controller.dart';
import 'stiching_uI/dress_costing_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(DressCostingController());
  runApp(const DressCostingApp());
}

class DressCostingApp extends StatelessWidget {
  const DressCostingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dress Costing Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        useMaterial3: true,
      ),
      home: const DressCostingScreen(),
    );
  }
}
