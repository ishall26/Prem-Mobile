import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const StreamApp());
}

class StreamApp extends StatelessWidget {
  const StreamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream Harist',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StreamHomePage(),
    );
  }
}

// =====================================
// PRAKTIKUM 1: COLOR STREAM
// =====================================
class ColorStream {
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.pink,
    Colors.cyan,
  ];

  Stream<Color> getColors() async* {
    yield* Stream.periodic(
      const Duration(seconds: 1),
      (int t) => colors[t % colors.length],
    );
  }
}

// =====================================
// PRAKTIKUM 2: NUMBER STREAM
// =====================================
class NumberStream {
  StreamController<int> controller = StreamController<int>();

  Stream<int> get stream => controller.stream;

  void addNumberToSink(int newNumber) {
    controller.sink.add(newNumber);
  }

  void addError() {
    controller.sink.addError("ERROR: Angka tidak valid!");
  }

  void close() {
    controller.close();
  }
}

// =====================================
// UI APLIKASI
// =====================================
class StreamHomePage extends StatefulWidget {
  const StreamHomePage({super.key});

  @override
  State<StreamHomePage> createState() => _StreamHomePageState();
}

class _StreamHomePageState extends State<StreamHomePage> {
  // Variabel Praktikum 1
  late ColorStream colorStream;
  late Stream<Color> colors;
  Color currentColor = Colors.white;

  // Variabel Praktikum 2
  late NumberStream numberStream;
  int latestNumber = 0;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();

    // Praktikum 1
    colorStream = ColorStream();
    colors = colorStream.getColors();
    changeColor();

    // Praktikum 2
    numberStream = NumberStream();
    numberStream.stream.listen(
      (event) {
        setState(() {
          latestNumber = event;
          errorMessage = "";
        });
      },
      onError: (err) {
        setState(() {
          errorMessage = err.toString();
        });
      },
    );
  }

  @override
  void dispose() {
    numberStream.close();
    super.dispose();
  }

  void changeColor() async {
    await for (var event in colors) {
      setState(() {
        currentColor = event;
      });
    }
  }

  // LANGKAH 10 — addRandomNumber()
  void addRandomNumber() {
    Random random = Random();
    int myNum = random.nextInt(10);

    // numberStream.addError();  // Langkah 15 (JANGAN AKTIFKAN SETELAH JAWAB SOAL)
    numberStream.addNumberToSink(myNum);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentColor,
      appBar: AppBar(
        title: const Text("Stream Controller Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Latest Number:",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "$latestNumber",
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addRandomNumber,
              child: const Text("Generate Random Number"),
            ),
          ],
        ),
      ),
    );
  }
}
