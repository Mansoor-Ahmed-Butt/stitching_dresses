import 'package:flutter/material.dart';

class CostItem {
  String name;
  String icon;
  Color color;
  TextEditingController controller;
  bool isEnabled;

  CostItem({required this.name, required this.icon, required this.color, this.isEnabled = false}) : controller = TextEditingController(text: '0');

  double get amount => double.tryParse(controller.text) ?? 0.0;
}

class SelectedDress {
  String type;
  int qty;
  double pricePer;

  SelectedDress({required this.type, required this.qty, required this.pricePer});

  double get total => qty * pricePer;
}

class DressOrder {
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController dressTypeController = TextEditingController();
  final List<CostItem> costItems;
  int dressCount;
  String dressName;

  final List<SelectedDress> selectedDresses = [];

  DressOrder(this.dressCount, this.dressName, this.costItems);

  double get costItemsTotal => costItems.fold(0.0, (sum, item) => sum + (item.isEnabled ? item.amount : 0.0));

  double get selectedDressesTotal => selectedDresses.fold(0.0, (sum, d) => sum + d.total);

  double get totalAmount => costItemsTotal + selectedDressesTotal;

  double get totalForAllDresses => totalAmount;

  void dispose() {
    for (var item in costItems) {
      item.controller.dispose();
    }
    customerNameController.dispose();
    dressTypeController.dispose();
  }
}
