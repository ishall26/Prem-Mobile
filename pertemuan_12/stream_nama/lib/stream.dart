import 'dart:async';
import 'package:flutter/material.dart';

class ColorStream {
  // Langkah 4: variabel colors
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,

    // Tambahan 5 warna lain (Soal 2)
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.pink,
    Colors.cyan,
  ];

  // Langkah 5 & 6: method getColors + yield*
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
