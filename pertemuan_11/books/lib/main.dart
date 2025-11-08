import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Books Async Harist',
      home: FuturePage(),
    );
  }
}

class FuturePage extends StatefulWidget {
  const FuturePage({super.key});

  @override
  State<FuturePage> createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> {
  String _result = "";

  // 🔹 Langkah 1 — Tiga method asynchronous
  Future<int> returnOneAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 1;
  }

  Future<int> returnTwoAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 2;
  }

  Future<int> returnThreeAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 3;
  }

  // 🔹 Langkah 2 — Method count()
  Future<void> count() async {
    int total = 0;

    total += await returnOneAsync(); // tunggu sampai selesai (3 detik)
    total += await returnTwoAsync(); // tunggu sampai selesai (3 detik)
    total += await returnThreeAsync(); // tunggu sampai selesai (3 detik)

    // total = 1 + 2 + 3 = 6

    setState(() {
      _result = "Total: $total";
    });
  }

  // 🔹 Langkah 3 — Panggil count() di tombol
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Async Await Demo - Harist")),
      body: Center(
        child: _result.isEmpty
            ? const Text("Tekan tombol untuk mulai menghitung...")
            : Text(_result, style: const TextStyle(fontSize: 24)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: count,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
