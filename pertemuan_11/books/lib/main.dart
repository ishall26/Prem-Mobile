import 'package:flutter/material.dart';
import 'package:async/async.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Books Error Handling Harist',
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

  // ==================================================
  // Langkah 1: Tambahkan method dengan error handling
  // ==================================================
  Future<String> getDataWithError(bool throwError) async {
    await Future.delayed(const Duration(seconds: 2));

    if (throwError) {
      throw Exception("Terjadi kesalahan saat mengambil data!");
    } else {
      return "Data berhasil diambil!";
    }
  }

  // ==================================================
  // Langkah 2: Tombol untuk menjalankan Future + catchError
  // ==================================================
  void _runWithCatchError() {
    setState(() {
      result = "Mengambil data...";
    });

    getDataWithError(true)
        .then((value) {
          setState(() {
            result = value;
          });
        })
        .catchError((error) {
          setState(() {
            result = "Error: ${error.toString()}";
          });
        })
        .whenComplete(() {
          debugPrint("Complete"); // tampil di debug console
        });
  }

  // ==================================================
  // Langkah 4: Method handleError() menggunakan try-catch async/await
  // ==================================================
  Future<void> handleError() async {
    setState(() {
      result = "Menunggu hasil async/await...";
    });

    try {
      final data = await getDataWithError(true);
      setState(() {
        result = data;
      });
    } catch (e) {
      setState(() {
        result = "Terjadi error (try-catch): $e";
      });
    } finally {
      debugPrint("Complete (async/await)");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Async Error Handling - Harist")),
      body: Center(
        child: Text(
          result.isEmpty ? "Tekan tombol untuk mulai!" : result,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: _runWithCatchError, // Langkah 2
            label: const Text("Run then().catchError()"),
            icon: const Icon(Icons.error_outline),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            onPressed: handleError, // Langkah 4
            label: const Text("Run try-catch (async/await)"),
            icon: const Icon(Icons.bug_report),
          ),
        ],
      ),
    );
  }
}
