import 'dart:async';

class NumberStream {
  Stream<int> getNumbers() {
    return Stream.periodic(
      const Duration(seconds: 1),
      (i) => i,
    );
  }
}
