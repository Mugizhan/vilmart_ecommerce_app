import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'dart:io';
import 'package:go_router/go_router.dart';

class QRViewScreen extends StatefulWidget {
  const QRViewScreen({Key? key}) : super(key: key);

  @override
  State<QRViewScreen> createState() => _QRViewScreenState();
}

class _QRViewScreenState extends State<QRViewScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isDecoding = false;
  String? galleryScanResult;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  Future<void> _pickImageAndScan() async {
    setState(() {
      isDecoding = true;
    });

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      try {
        final String? qrCode = await QrCodeToolsPlugin.decodeFrom(image.path);
        if (qrCode != null && qrCode.isNotEmpty) {
          setState(() {
            galleryScanResult = qrCode;
          });

          // Navigate to product page using GoRouter
          if (context.mounted) {
            context.go('/product/$qrCode');
          }
        } else {
          setState(() {
            galleryScanResult = 'No QR code found in image';
          });
        }
      } catch (e) {
        setState(() {
          galleryScanResult = 'Failed to decode QR code: $e';
        });
      }
    } else {
      setState(() {
        galleryScanResult = 'No image selected';
      });
    }

    setState(() {
      isDecoding = false;
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      final shopId = scanData.code;

      if (shopId != null && shopId.isNotEmpty && mounted) {
        context.push('/product/$shopId');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.photo),
            tooltip: 'Scan from Gallery',
            onPressed: isDecoding ? null : _pickImageAndScan,
          ),
        ],
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          if (galleryScanResult != null)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                color: Colors.white70,
                padding: const EdgeInsets.all(20),
                child: Text("Gallery Scan Result: $galleryScanResult"),
              ),
            ),
          if (isDecoding)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
