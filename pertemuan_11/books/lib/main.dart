import 'package:flutter/material.dart';
import 'package:async/async.dart'; // penting! FutureGroup ada di sini

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Books FutureGroup Harist',
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
  String result = "";

  // ----------------------------------
  // Langkah 1: Tambahkan tiga Future
  // ----------------------------------
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

  // ----------------------------------
  // Langkah 1: Gunakan FutureGroup
  // ----------------------------------
  Future<void> runParallelWithFutureGroup() async {
    setState(() {
      result = "Menjalankan FutureGroup...";
    });

    final group = FutureGroup<int>();

    group.add(returnOneAsync());
    group.add(returnTwoAsync());
    group.add(returnThreeAsync());

    group.close(); // wajib ditutup agar FutureGroup tahu kapan selesai

    final results = await group.future; // tunggu semua Future selesai
    final sum = results.reduce((a, b) => a + b);

    setState(() {
      result = "Hasil penjumlahan: $sum";
    });
  }

  // ----------------------------------
  // Langkah 4: Versi Future.wait
  // ----------------------------------
  Future<void> runParallelWithFutureWait() async {
    setState(() {
      result = "Menjalankan Future.wait...";
    });

    final futures = Future.wait<int>([
      returnOneAsync(),
      returnTwoAsync(),
      returnThreeAsync(),
    ]);

    final results = await futures;
    final sum = results.reduce((a, b) => a + b);

    setState(() {
      result = "Hasil penjumlahan (Future.wait): $sum";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Future Parallel - Harist")),
      body: Center(
        child: Text(
          result.isEmpty ? "Tekan tombol di bawah untuk mulai!" : result,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: runParallelWithFutureGroup, // langkah 1–3
            label: const Text("FutureGroup"),
            icon: const Icon(Icons.group),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            onPressed: runParallelWithFutureWait, // langkah 4
            label: const Text("Future.wait"),
            icon: const Icon(Icons.timer),
          ),
        ],
      ),
    );
  }
}
