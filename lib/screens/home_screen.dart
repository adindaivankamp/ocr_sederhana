import 'package:flutter/material.dart';
import 'scan_screen.dart'; // pastikan path benar

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OCR Sederhana'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text('Mulai Pindai Teks Baru'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScanScreen()),
                );
              },
            ),
          ),
          // Anda dapat menyimpan elemen lain di home sesuai kebutuhan
        ],
      ),
    );
  }
}
