import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const StreamHomePage(),
    );
  }
}

class NumberStream {
  final StreamController<int> controller = StreamController<int>();

  void addNumberToSink(int newNumber) {
    controller.sink.add(newNumber);
  }

  void close() {
    controller.close();
  }
}

class StreamHomePage extends StatefulWidget {
  const StreamHomePage({super.key});

  @override
  State<StreamHomePage> createState() => _StreamHomePageState();
}

class _StreamHomePageState extends State<StreamHomePage> {
  NumberStream numberStream = NumberStream();

  StreamSubscription? subscription1;
  StreamSubscription? subscription2;

  int value1 = 0;
  int value2 = 0;

  @override
  void initState() {
    super.initState();

    // LANGKAH 4 — UBAH JADI BROADCAST STREAM
    Stream<int> broadcastStream = numberStream.controller.stream.asBroadcastStream();

    // LANGKAH 2 — LISTENER 1
    subscription1 = broadcastStream.listen((event) {
      setState(() {
        value1 = event;
      });
    });

    // LISTENER 2
    subscription2 = broadcastStream.listen((event) {
      setState(() {
        value2 = event;
      });
    });
  }

  void addRandomNumber() {
    Random random = Random();
    int num = random.nextInt(10);
    numberStream.addNumberToSink(num);
  }

  @override
  void dispose() {
    subscription1?.cancel();
    subscription2?.cancel();
    numberStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Praktikum 5 — Multiple Subscriptions"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LANGKAH 5
            Text("Listener 1 menerima: $value1", style: TextStyle(fontSize: 22)),
            const SizedBox(height: 20),
            Text("Listener 2 menerima: $value2", style: TextStyle(fontSize: 22)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: addRandomNumber,
              child: const Text("New Random Number"),
            ),
          ],
        ),
      ),
    );
  }
}
