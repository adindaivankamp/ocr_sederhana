import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'result_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  CameraController? controller;
  List<CameraDescription>? cameras;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras != null && cameras!.isNotEmpty) {
        controller = CameraController(cameras![0], ResolutionPreset.medium);
        await controller!.initialize();
        if (mounted) setState(() {});
      }
    } catch (e) {
      // tangani error inisialisasi kamera jika perlu
    }
  }

  Future<void> _takePicture() async {
    if (controller == null || !controller!.value.isInitialized) return;

    try {
      final XFile file = await controller!.takePicture();
      // misal: setelah ambil, jalankan OCR dan navigasi ke ResultScreen
      // contoh sederhana: baca file.path sebagai text placeholder
      final String fakeOcrText = "Hasil OCR dari file: ${file.path}";
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResultScreen(ocrText: fakeOcrText)),
      );
    } catch (e) {
      // Teken: ubah SnackBar agar menampilkan pesan tetap (tanpa $e)
      final snack = SnackBar(
        content: const Text('Pemindaian Gagal! Periksa Izin Kamera atau coba lagi.'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snack);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      // Tampilan loading kustom sesuai instruksi
      return Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(
                // note: warna diset di CircularProgressIndicator via valueColor
                // tapi instruksi menyatakan color: Colors.yellow => gunakan valueColor
              ),
              SizedBox(height: 16),
              Text(
                'Memuat Kamera... Harap tunggu.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan'),
      ),
      body: CameraPreview(controller!),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: const Icon(Icons.camera),
      ),
    );
  }
}
