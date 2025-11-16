import 'package:flutter/material.dart';
import 'stream.dart';

void main() {
  runApp(const StreamApp());
}

class StreamApp extends StatelessWidget {
  const StreamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  late NumberStream numberStream;
  late Stream<int> stream;

  @override
  void initState() {
    super.initState();
    numberStream = NumberStream();
    stream = numberStream.getNumbers();   // langkah 6
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Praktikum 6: StreamBuilder")),
      body: Center(
        child: StreamBuilder<int>(
          stream: stream,                          // langkah 7
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            return Text(
              "${snapshot.data}",
              style: const TextStyle(fontSize: 40),
            );
          },
        ),
      ),
    );
  }
}
