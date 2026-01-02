import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/product.dart';

class ReceiptPage extends StatelessWidget {
  final Product product;

  const ReceiptPage({super.key, required this.product});

  Future<Uint8List> _buildPdf(PdfPageFormat format) async {
    final doc = pw.Document();
    debugPrint("ReceiptPage product: ================> $product");
    // Load image bytes if an image path is available
    Uint8List? imageBytes;
    if (product.imagePath != null) {
      try {
        imageBytes = await File(product.imagePath!).readAsBytes();
      } catch (e) {
        debugPrint('Could not read image file for PDF: $e');
        imageBytes = null;
      }
    }
    final pwImage = imageBytes != null ? pw.MemoryImage(imageBytes) : null;
    doc.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Receipt', style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 12),
                pw.Text('Product: ${product.name}', style: pw.TextStyle(fontSize: 16)),
                pw.SizedBox(height: 6),
                pw.Text('Price: \$${product.price.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 14)),
                pw.SizedBox(height: 6),
                pw.Text('Expiry: ${product.expiryDate.toLocal().toString().split(' ').first}', style: pw.TextStyle(fontSize: 14)),
                pw.SizedBox(height: 12),
                if (pwImage != null) pw.Container(height: 100, width: 100, child: pw.Image(pwImage, fit: pw.BoxFit.cover)),
                if (pwImage != null) pw.SizedBox(height: 12),
                pw.Spacer(),
                pw.Text('Generated: ${DateTime.now().toLocal().toString()}', style: pw.TextStyle(fontSize: 10, color: PdfColor.fromInt(0xFF666666))),
              ],
            ),
          );
        },
      ),
    );

    return doc.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receipt')),
      body: PdfPreview(
        build: (format) => _buildPdf(format),
        allowPrinting: true,
        allowSharing: true,
        canChangePageFormat: false,
        initialPageFormat: PdfPageFormat(
          80 * PdfPageFormat.mm, // width: 80mm
          120 * PdfPageFormat.mm, // double.infinity,// height: auto
        ), //PdfPageFormat.a4,
      ),
    );
  }
}
