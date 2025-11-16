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
      title: 'Stream Transformation',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const StreamHomePage(),
    );
  }
}

class StreamHomePage extends StatefulWidget {
  const StreamHomePage({super.key});

  @override
  State<StreamHomePage> createState() => _StreamHomePageState();
}

class _StreamHomePageState extends State<StreamHomePage> {

  //  Langkah 1: Tambah variabel di class state
  late StreamController<int> numberStream;
  late Stream<int> transformedStream;

  @override
  void initState() {
    super.initState();

    //  Langkah 2: Inisialisasi stream & transformer
    numberStream = StreamController<int>();

    final transformer = StreamTransformer<int, int>.fromHandlers(
      handleData: (value, sink) {
        // Filter: hanya angka kelipatan 10
        if (value % 10 == 0) {
          sink.add(value);
        }
      },
    );

    //  Langkah 3: Sambungkan transformer ke stream
    transformedStream = numberStream.stream.transform(transformer);

    // Mengirim data 0–100 setiap 100ms
    generateNumbers();
  }

  void generateNumbers() async {
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      numberStream.add(i);
    }
  }

  @override
  void dispose() {
    numberStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stream Transformer")),
      body: Center(
        child: StreamBuilder(
          stream: transformedStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text(
                "Menunggu data...",
                style: TextStyle(fontSize: 24),
              );
            }
            return Text(
              snapshot.data.toString(),
              style: const TextStyle(fontSize: 48),
            );
          },
        ),
      ),
    );
  }
}
