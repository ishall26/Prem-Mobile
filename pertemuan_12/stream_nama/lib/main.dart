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

  void addNumberWithError() {
    controller.sink.addError("Error: Angka tidak valid!");
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

  StreamSubscription? subscription;
  int lastNumber = 0;

  @override
  void initState() {
    super.initState();

    // Langkah 2
    subscription = numberStream.controller.stream.listen(
      (event) {
        setState(() {
          lastNumber = event;
        });
      },

      // Langkah 3 – onError
      onError: (error) {
        debugPrint("Terjadi error: $error");
      },

      // Langkah 4 – onDone
      onDone: () {
        debugPrint("Stream telah selesai.");
      },
    );
  }

  // Langkah 5
  void stopSubscription() {
    subscription?.cancel();
    debugPrint("Subscription dihentikan!");
  }

  @override
  void dispose() {
    // Langkah 6
    subscription?.cancel();
    numberStream.close();
    super.dispose();
  }

  // Langkah 8
  void addRandomNumber() {
    Random random = Random();
    int myNum = random.nextInt(10);

    numberStream.addNumberToSink(myNum);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Praktikum 4 Stream Subscription"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Last number from stream:",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "$lastNumber",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // Button 1: Add Number
            ElevatedButton(
              onPressed: addRandomNumber,
              child: const Text("Add Random Number"),
            ),

            const SizedBox(height: 20),

            // Langkah 7 – Button Stop Subscription
            ElevatedButton(
              onPressed: stopSubscription,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text("Stop Subscription"),
            ),
          ],
        ),
      ),
    );
  }
}
