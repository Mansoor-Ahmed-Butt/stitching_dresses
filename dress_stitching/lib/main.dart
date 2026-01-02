// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// import 'models/user.dart';
// import 'models/product.dart';
// import 'router/router.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Hive.initFlutter();

//   Hive.registerAdapter(UserAdapter());
//   Hive.registerAdapter(ProductAdapter());

//   await Hive.openBox<User>('users');
//   await Hive.openBox<Product>('products');
//   await Hive.openBox('session');

//   // Do not pre-register controllers here; bindings will register them per-route.

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp.router(
//       title: 'Sign In with Hive',
//       debugShowCheckedModeBanner: false,
//       routerDelegate: AppRouter.router.routerDelegate,
//       routeInformationParser: AppRouter.router.routeInformationParser,
//       routeInformationProvider: AppRouter.router.routeInformationProvider,
//       theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
//     );
//   }
// }

//////////////////////////    UI for Taylor
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Register the controller so Get.find / GetView can locate it
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
      theme: ThemeData(primarySwatch: Colors.purple, scaffoldBackgroundColor: const Color(0xFFF5F7FA), useMaterial3: true),
      home: const DressCostingScreen(),
    );
  }
}

class CostItem {
  String name;
  String icon;
  Color color;
  TextEditingController controller;
  bool isEnabled;

  CostItem({required this.name, required this.icon, required this.color, this.isEnabled = false}) : controller = TextEditingController(text: '0');

  double get amount => double.tryParse(controller.text) ?? 0.0;
}

class DressOrder {
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController dressTypeController = TextEditingController();
  final List<CostItem> costItems;
  int dressCount;
  String dressName;

  // selected dress types with price and qty
  final List<SelectedDress> selectedDresses = [];

  DressOrder(this.dressCount, this.dressName, this.costItems);

  double get costItemsTotal => costItems.fold(0.0, (sum, item) => sum + (item.isEnabled ? item.amount : 0.0));
  double get selectedDressesTotal => selectedDresses.fold(0.0, (sum, d) => sum + d.total);
  double get totalAmount => costItemsTotal + selectedDressesTotal;
  double get totalForAllDresses => totalAmount; // selectedDresses already include qty

  @override
  void dispose() {
    for (var item in costItems) {
      item.controller.dispose();
    }
    customerNameController.dispose();
    dressTypeController.dispose();
  }
}

class SelectedDress {
  String type;
  int qty;
  double pricePer;

  SelectedDress({required this.type, required this.qty, required this.pricePer});

  double get total => qty * pricePer;
}

// Controller
class DressCostingController extends GetxController {
  final RxList<DressOrder> orders = <DressOrder>[].obs;
  final RxInt currentOrderIndex = 0.obs;
  final TextEditingController dressCountController = TextEditingController(text: '1');
  // Available dress types with base price
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

  @override
  void onClose() {
    dressCountController.dispose();
    dressTypeQtyController.dispose();
    super.onClose();
  }

  void deleteCurrentOrder() {
    if (orders.length > 1) {
      orders.removeAt(currentOrderIndex.value);
      if (currentOrderIndex.value >= orders.length) {
        currentOrderIndex.value = orders.length - 1;
      }
      orders.refresh();
    }
  }

  DressOrder get currentOrder => orders[currentOrderIndex.value];
}

// View
class DressCostingScreen extends GetView<DressCostingController> {
  const DressCostingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8F9FF), Color(0xFFFFF0F8), Color(0xFFF5F3FF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildOrderSelector(),
                      const SizedBox(height: 16),
                      _buildCustomerInfoCard(),
                      const SizedBox(height: 12),
                      _buildSelectedDressesContainer(),
                      const SizedBox(height: 20),
                      _buildTotalCard(),
                      const SizedBox(height: 20),
                      _buildCostItemsGrid(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeader() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899)]),
          boxShadow: [BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: const Text('👗', style: TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dress Costing',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    '${controller.orders.length} Dress${controller.orders.length > 1 ? 'es' : ''} Order',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: controller.resetCurrentOrder,
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              style: IconButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.2)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Row(
        children: [
          const Icon(Icons.layers, color: Color(0xFF6366F1)),
          const SizedBox(width: 12),
          const Text('Order: ', style: TextStyle(fontWeight: FontWeight.w600)),
          Expanded(
            child: Obx(
              () => DropdownButton<int>(
                value: controller.currentOrderIndex.value,
                isExpanded: true,
                underline: Container(),
                items: controller.orders
                    .asMap()
                    .entries
                    .map((entry) => DropdownMenuItem(value: entry.key, child: Text(entry.value.dressName)))
                    .toList(),
                onChanged: (index) {
                  if (index != null) controller.currentOrderIndex.value = index;
                },
              ),
            ),
          ),
          IconButton(
            onPressed: controller.addNewDress,
            icon: const Icon(Icons.add_circle_outline, color: Color(0xFF6366F1)),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfoCard() {
    return Obx(() {
      final order = controller.currentOrder;
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Customer Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1F2937)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: order.customerNameController,
              label: 'Customer Name',
              icon: Icons.person_outline,
              hint: 'Enter customer name',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.selectedDressType.value,
                        isExpanded: true,
                        items: controller.dressTypePrices.keys
                            .map((k) => DropdownMenuItem(value: k, child: Text('$k (Rs. ${controller.dressTypePrices[k]!.toStringAsFixed(0)})')))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) controller.selectedDressType.value = v;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: controller.dressTypeQtyController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Qty',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: controller.addSelectedDress,
                  icon: const Icon(Icons.add_circle, color: Color(0xFF6366F1)),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTotalCard() {
    return Obx(() {
      final order = controller.currentOrder;
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899)],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.4), blurRadius: 30, offset: const Offset(0, 15))],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Per Dress',
                      style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 4),
                    Text('💰', style: TextStyle(fontSize: 20)),
                  ],
                ),
                Text(
                  'Rs. ${order.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total (${order.dressCount}x)',
                      style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 4),
                    Text('💎', style: TextStyle(fontSize: 20)),
                  ],
                ),
                Text(
                  'Rs. ${order.totalForAllDresses.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCostItemsGrid() {
    return Obx(() {
      final order = controller.currentOrder;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: order.costItems.length,
        itemBuilder: (context, index) => _buildCostItemCard(order.costItems[index], index),
      );
    });
  }

  Widget _buildSelectedDressesContainer() {
    return Obx(() {
      final order = controller.currentOrder;
      if (order.selectedDresses.isEmpty) {
        return Container();
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Selected Dresses', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ...order.selectedDresses.asMap().entries.map((e) {
              final idx = e.key;
              final sd = e.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('${sd.type}  x${sd.qty}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                    Text('Rs. ${sd.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => controller.removeSelectedDress(idx),
                      icon: const Icon(Icons.delete, size: 20, color: Colors.redAccent),
                    ),
                  ],
                ),
              );
            }),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Selected Dresses Total', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                Text(
                  'Rs. ${order.selectedDresses.fold(0.0, (s, d) => s + d.total).toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCostItemCard(CostItem item, int index) {
    return GestureDetector(
      onTap: () => controller.toggleCostItem(controller.currentOrderIndex.value, index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: item.isEnabled ? Colors.white : Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: item.isEnabled ? item.color : Colors.grey.shade300, width: item.isEnabled ? 2.5 : 1.5),
          boxShadow: item.isEnabled ? [BoxShadow(color: item.color.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))] : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: item.color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Text(item.icon, style: const TextStyle(fontSize: 24)),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(color: item.isEnabled ? item.color : Colors.grey.shade300, shape: BoxShape.circle),
                  child: item.isEnabled ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: item.isEnabled ? const Color(0xFF1F2937) : Colors.grey),
            ),
            const SizedBox(height: 8),
            if (item.isEnabled)
              TextField(
                controller: item.controller,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1F2937)),
                decoration: InputDecoration(
                  prefix: const Text('Rs. ', style: TextStyle(color: Colors.grey)),
                  hintText: '0.00',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: item.color.withOpacity(0.1),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                onChanged: (_) => controller.orders.refresh(),
              )
            else
              Text(
                'Tap to add',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, required String hint}) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF6366F1)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildFloatingButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FloatingActionButton.extended(
              heroTag: "summary",
              onPressed: () => _showSummary(),
              backgroundColor: Colors.white,
              elevation: 8,
              icon: const Icon(Icons.receipt_long, color: Color(0xFF6366F1)),
              label: const Text(
                'View Summary',
                style: TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSummary() {
    Get.bottomSheet(_buildSummarySheet(), isScrollControlled: true, backgroundColor: Colors.transparent);
  }

  Widget _buildSummarySheet() {
    return Obx(() {
      final orders = controller.orders;
      final overallTotal = orders.fold<double>(0.0, (sum, o) => sum + o.totalForAllDresses);

      return Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 30, offset: const Offset(0, 10))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899)]),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                    child: const Text('📋', style: TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cost Summary',
                          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                        ),
                        Text('${orders.length} Orders', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close, color: Colors.white),
                    style: IconButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.2)),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Render each order with its selected dresses and enabled cost items
                    ...orders.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final o = entry.value;
                      final enabled = o.costItems.where((item) => item.isEnabled).toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${o.dressName}  (${o.dressCount}x)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          if (o.customerNameController.text.isNotEmpty) _buildSummaryRow('Customer', o.customerNameController.text, Icons.person),
                          if (o.selectedDresses.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            const Text('Selected Dresses', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 6),
                            ...o.selectedDresses.map(
                              (d) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${d.type} x${d.qty}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                    Text('Rs. ${d.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          if (enabled.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            const Text('Cost Items', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 6),
                            ...enabled.map((item) => _buildCostSummaryRow(item)),
                          ],
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Order Total', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                              Text(
                                'Rs. ${o.totalForAllDresses.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                        ],
                      );
                    }),
                    const Divider(height: 32, thickness: 2),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFFEC4899)]),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Per Dress Total',
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                'Rs. ${overallTotal.toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Grand Total',
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Rs. ${overallTotal.toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFF6366F1).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: const Color(0xFF6366F1), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1F2937)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCostSummaryRow(CostItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: item.color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Text(item.icon, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1F2937)),
            ),
          ),
          Text(
            'Rs. ${item.amount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: item.color),
          ),
        ],
      ),
    );
  }
}
