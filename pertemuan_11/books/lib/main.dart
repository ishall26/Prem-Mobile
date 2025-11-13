import 'package:flutter/material.dart';
import 'navigation_first.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Praktikum 8 - Harist',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NavigationFirst(),
    );
  }
}
