import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ResultScreen extends StatefulWidget {
  final String ocrText;
  const ResultScreen({Key? key, required this.ocrText}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late final FlutterTts _flutterTts;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      await _flutterTts.setLanguage('id-ID');
      // optional: set speech rate, volume, pitch if diperlukan
      // await _flutterTts.setSpeechRate(0.5);
      // await _flutterTts.setVolume(1.0);
      // await _flutterTts.setPitch(1.0);

      _flutterTts.setStartHandler(() {
        setState(() {
          _isSpeaking = true;
        });
      });

      _flutterTts.setCompletionHandler(() {
        setState(() {
          _isSpeaking = false;
        });
      });

      _flutterTts.setErrorHandler((msg) {
        setState(() {
          _isSpeaking = false;
        });
      });
    } catch (e) {
      // jika gagal inisialisasi, tampilkan SnackBar sederhana
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal inisialisasi TTS.')),
        );
      });
    }
  }

  Future<void> _speak() async {
    if (widget.ocrText.trim().isEmpty) return;
    await _flutterTts.stop(); // hentikan jika ada yang berjalan
    await _flutterTts.speak(widget.ocrText);
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Pindai'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            widget.ocrText, // newline tetap utuh, sesuai instruksi
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'homeFab',
            tooltip: 'Kembali ke Home',
            child: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'ttsFab',
            tooltip: _isSpeaking ? 'Sedang Membaca...' : 'Baca Teks',
            child: const Icon(Icons.volume_up),
            onPressed: _isSpeaking ? null : _speak,
          ),
        ],
      ),
    );
  }
}
