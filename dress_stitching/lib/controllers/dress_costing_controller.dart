import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/dress_costing_models.dart';

class DressCostingController extends GetxController {
  final RxList<DressOrder> orders = <DressOrder>[].obs;
  final RxInt currentOrderIndex = 0.obs;
  final TextEditingController dressCountController = TextEditingController(text: '1');

  final Map<String, double> dressTypePrices = {'Party Dress': 1200.0, 'Casual Dress': 800.0, 'Bridal': 5000.0, 'Kids Dress': 500.0};

  final RxString selectedDressType = 'Party Dress'.obs;
  final TextEditingController dressTypeQtyController = TextEditingController(text: '1');

  @override
  void onInit() {
    super.onInit();
    _initializeFirstOrder();
  }

  void _initializeFirstOrder() {
    final costItems = [
      CostItem(name: 'Stitching', icon: '✂️', color: const Color(0xFF6366F1)),
      CostItem(name: 'Fabric', icon: '🧵', color: const Color(0xFFEC4899)),
      CostItem(name: 'Ribbon', icon: '🎀', color: const Color(0xFF8B5CF6)),
      CostItem(name: 'Buttons', icon: '🔘', color: const Color(0xFF10B981)),
      CostItem(name: 'Zipper', icon: '🔗', color: const Color(0xFFF59E0B)),
      CostItem(name: 'Thread', icon: '🧶', color: const Color(0xFF06B6D4)),
      CostItem(name: 'Lace', icon: '🪡', color: const Color(0xFFF97316)),
      CostItem(name: 'Embroidery', icon: '✨', color: const Color(0xFFA855F7)),
      CostItem(name: 'Beads', icon: '💎', color: const Color(0xFFEF4444)),
      CostItem(name: 'Other', icon: '➕', color: const Color(0xFF6B7280)),
    ];

    orders.add(DressOrder(1, 'Dress 1', costItems));
  }

  void addNewDress() {
    final newIndex = orders.length + 1;
    final costItems = [
      CostItem(name: 'Stitching', icon: '✂️', color: const Color(0xFF6366F1)),
      CostItem(name: 'Fabric', icon: '🧵', color: const Color(0xFFEC4899)),
      CostItem(name: 'Ribbon', icon: '🎀', color: const Color(0xFF8B5CF6)),
      CostItem(name: 'Buttons', icon: '🔘', color: const Color(0xFF10B981)),
      CostItem(name: 'Zipper', icon: '🔗', color: const Color(0xFFF59E0B)),
      CostItem(name: 'Thread', icon: '🧶', color: const Color(0xFF06B6D4)),
      CostItem(name: 'Lace', icon: '🪡', color: const Color(0xFFF97316)),
      CostItem(name: 'Embroidery', icon: '✨', color: const Color(0xFFA855F7)),
      CostItem(name: 'Beads', icon: '💎', color: const Color(0xFFEF4444)),
      CostItem(name: 'Other', icon: '➕', color: const Color(0xFF6B7280)),
    ];

    orders.add(DressOrder(int.tryParse(dressCountController.text) ?? 1, 'Dress $newIndex', costItems));
    currentOrderIndex.value = orders.length - 1;
  }

  void toggleCostItem(int orderIndex, int itemIndex) {
    final order = orders[orderIndex];
    final item = order.costItems[itemIndex];
    item.isEnabled = !item.isEnabled;
    if (!item.isEnabled) {
      item.controller.text = '0';
    }
    orders.refresh();
  }

  void updateDressCount(String count) {
    final dressCount = int.tryParse(count) ?? 1;
    if (orders.isNotEmpty) {
      orders[currentOrderIndex.value].dressCount = dressCount;
      orders.refresh();
    }
  }

  void resetCurrentOrder() {
    final order = orders[currentOrderIndex.value];
    for (var item in order.costItems) {
      item.controller.text = '0';
      item.isEnabled = false;
    }
    order.customerNameController.clear();
    order.dressTypeController.clear();
    order.selectedDresses.clear();
    orders.refresh();
  }

  void addSelectedDress() {
    final order = currentOrder;
    final type = selectedDressType.value;
    final qty = int.tryParse(dressTypeQtyController.text) ?? 1;
    final price = dressTypePrices[type] ?? 0.0;

    final existing = order.selectedDresses.indexWhere((d) => d.type == type && d.pricePer == price);
    if (existing >= 0) {
      order.selectedDresses[existing].qty += qty;
    } else {
      order.selectedDresses.add(SelectedDress(type: type, qty: qty, pricePer: price));
    }
    dressTypeQtyController.text = '1';
    orders.refresh();
  }

  void removeSelectedDress(int index) {
    final order = currentOrder;
    if (index >= 0 && index < order.selectedDresses.length) {
      order.selectedDresses.removeAt(index);
      orders.refresh();
    }
  }

  void deleteCurrentOrder() {
    if (orders.length > 1) {
      final removed = orders.removeAt(currentOrderIndex.value);
      removed.dispose();
      if (currentOrderIndex.value >= orders.length) {
        currentOrderIndex.value = orders.length - 1;
      }
      orders.refresh();
    }
  }

  DressOrder get currentOrder => orders[currentOrderIndex.value];

  @override
  void onClose() {
    for (final o in orders) {
      o.dispose();
    }
    dressCountController.dispose();
    dressTypeQtyController.dispose();
    super.onClose();
  }
}
