import 'dart:async';
import 'dart:math';

class RandomNumberBloc {
  // StreamController sebagai pengelola event dan data
  final _controller = StreamController<int>();

  // Getter Stream untuk dibaca UI
  Stream<int> get stream => _controller.stream;

  // Constructor → generate angka acak setiap kali dipanggil
  RandomNumberBloc() {
    generateRandomNumber();
  }

  // Fungsi untuk menghasilkan angka acak
  void generateRandomNumber() {
    final random = Random().nextInt(10);
    _controller.sink.add(random);
  }

  // Bersihkan stream
  void dispose() {
    _controller.close();
  }
}
