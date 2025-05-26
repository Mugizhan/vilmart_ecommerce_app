import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:io';

class QRGeneratorScreen extends StatefulWidget {
  const QRGeneratorScreen({super.key});

  @override
  State<QRGeneratorScreen> createState() => _QRGeneratorScreenState();
}

class _QRGeneratorScreenState extends State<QRGeneratorScreen> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final GlobalKey qrKey = GlobalKey();

  String shopId = '';
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadShopId();
  }

  Future<void> _loadShopId() async {
    final id = await storage.read(key: 'shopId');
    setState(() {
      shopId = id ?? 'No Shop ID Found';
    });
  }

  Future<void> _saveQrCode() async {
    setState(() => isSaving = true);

    try {
      // Request storage permissions
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')),
        );
        setState(() => isSaving = false);
        return;
      }

      // Capture QR image from the widget
      RenderRepaintBoundary boundary =
      qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Failed to convert image to byte data');
      }

      Uint8List pngBytes = byteData.buffer.asUint8List();

      // Save to gallery (works for Android & iOS)
      final result = await ImageGallerySaver.saveImage(
        pngBytes,
        quality: 100,
        name: "shop_qr_${DateTime.now().millisecondsSinceEpoch}",
      );

      if (result['isSuccess'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('QR code saved to gallery!'),
          behavior:SnackBarBehavior.floating,
          backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to save image');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving QR code: $e'),
          behavior:SnackBarBehavior.floating,
          backgroundColor: Colors.green,
        ),
      );
    }

    setState(() => isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop QR Generator'),
      ),
      body: Center(
        child: shopId.isEmpty
            ? const CircularProgressIndicator()
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RepaintBoundary(
              key: qrKey,
              child: QrImageView(
                data: shopId,
                version: QrVersions.auto,
                size: 250.0,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: isSaving ? null : _saveQrCode,
              icon: isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.download),
              label: const Text('Download QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}
