import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const StreamApp());
}

class StreamApp extends StatelessWidget {
  const StreamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream Harist', // Soal 1
      theme: ThemeData(
        primarySwatch: Colors.blue, // ganti ke warna favorit
      ),
      home: const StreamHomePage(),
    );
  }
}

// ============================
// CLASS STREAM DIGABUNG DI SINI
// ============================
class ColorStream {
  // Langkah 4 (Soal 2): Tambah warna
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

  // Langkah 5–6: getColors() + yield*
  Stream<Color> getColors() async* {
    yield* Stream.periodic(
      const Duration(seconds: 1),
      (int t) {
        int index = t % colors.length;
        return colors[index];
      },
    );
  }
}

// ============================
// HALAMAN STREAM
// ============================
class StreamHomePage extends StatefulWidget {
  const StreamHomePage({super.key});

  @override
  State<StreamHomePage> createState() => _StreamHomePageState();
}

class _StreamHomePageState extends State<StreamHomePage> {
  // Langkah 8: Variabel
  late ColorStream colorStream;
  late Stream<Color> colors;
  Color currentColor = Colors.white;

  // Langkah 13: changeColor() versi await for
  void changeColor() async {
    await for (var event in colors) {
      setState(() {
        currentColor = event;
      });
    }
  }

  // Langkah 10: initState()
  @override
  void initState() {
    super.initState();
    colorStream = ColorStream();
    colors = colorStream.getColors();
    changeColor();
  }

  // Langkah 11: Scaffold
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentColor,
      appBar: AppBar(
        title: const Text("Stream Harist"),
      ),
    );
  }
}
