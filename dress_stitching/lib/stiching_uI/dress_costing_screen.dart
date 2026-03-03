import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../controllers/dress_costing_controller.dart';
import '../models/dress_costing_models.dart';

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
                  if (index != null) {
                    controller.currentOrderIndex.value = index;
                  }
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
                          if (v != null) {
                            controller.selectedDressType.value = v;
                          }
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
                      style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    const Text('💎', style: TextStyle(fontSize: 20)),
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
                  'Rs. ${order.selectedDresses.fold<double>(0.0, (s, d) => s + d.total).toStringAsFixed(2)}',
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
              heroTag: 'summary',
              onPressed: _generateSummaryPdf,
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

  Future<void> _generateSummaryPdf() async {
    final orders = controller.orders;
    final overallTotal = orders.fold<double>(0.0, (sum, o) => sum + o.totalForAllDresses);

    // Load background image from Flutter assets
    final bgData = await rootBundle.load('assets/pdf_background.png');
    final bgImage = pw.MemoryImage(bgData.buffer.asUint8List());

    final pdf = pw.Document();

    final pageTheme = pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.Opacity(opacity: 0.15, child: pw.Image(bgImage, fit: pw.BoxFit.cover)),
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text('Dress Cost Summary', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Text('Total Orders: ${orders.length}', style: const pw.TextStyle(fontSize: 12)),
          pw.SizedBox(height: 16),
          ...orders.asMap().entries.map((entry) {
            final idx = entry.key;
            final o = entry.value;
            final enabled = o.costItems.where((item) => item.isEnabled).toList();

            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Order ${idx + 1}: ${o.dressName}  (${o.dressCount}x)', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                if (o.customerNameController.text.isNotEmpty)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 4),
                    child: pw.Text('Customer: ${o.customerNameController.text}', style: const pw.TextStyle(fontSize: 12)),
                  ),
                if (o.selectedDresses.isNotEmpty) ...[
                  pw.SizedBox(height: 6),
                  pw.Text('Selected Dresses:', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: o.selectedDresses
                        .map(
                          (d) => pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 2),
                            child: pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text('${d.type} x${d.qty}', style: const pw.TextStyle(fontSize: 12)),
                                pw.Text('Rs. ${d.total.toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
                if (enabled.isNotEmpty) ...[
                  pw.SizedBox(height: 6),
                  pw.Text('Cost Items:', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: enabled
                        .map(
                          (item) => pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 2),
                            child: pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(item.name, style: const pw.TextStyle(fontSize: 12)),
                                pw.Text('Rs. ${item.amount.toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
                pw.SizedBox(height: 6),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Order Total:', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
                    pw.Text('Rs. ${o.totalForAllDresses.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.Divider(),
                pw.SizedBox(height: 8),
              ],
            );
          }),
          pw.SizedBox(height: 16),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              borderRadius: pw.BorderRadius.circular(8),
              border: pw.Border.all(color: PdfColors.deepPurple),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Per Dress Total', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.Text('Rs. ${overallTotal.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Grand Total', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    pw.Text('Rs. ${overallTotal.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(name: 'dress_cost_summary.pdf', onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
