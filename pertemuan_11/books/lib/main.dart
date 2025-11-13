import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Future Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FuturePage(),
    );
  }
}

class FuturePage extends StatefulWidget {
  const FuturePage({super.key});

  @override
  State<FuturePage> createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> {
  late Completer<int> completer;

  @override
  void initState() {
    super.initState();
    completer = Completer<int>();
    _calculateSum();
  }

  Future<void> _calculateSum() async {
    int result = await _sumNumbers(10);
    completer.complete(result);
  }

  Future<int> _sumNumbers(int n) async {
    int sum = 0;
    for (int i = 1; i <= n; i++) {
      await Future.delayed(const Duration(milliseconds: 300)); // simulasi proses
      sum += i;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum 3 - Future'),
      ),
      body: Center(
        child: FutureBuilder<int>(
          future: completer.future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return Text(
                'Hasil penjumlahan: ${snapshot.data}',
                style: const TextStyle(fontSize: 20),
              );
            } else {
              return const Text('Tidak ada data');
            }
          },
        ),
      ),
    );
  }
}
