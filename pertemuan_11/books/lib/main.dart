import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Books - Harist',
      home: FuturePage(),
    );
  }
}

class FuturePage extends StatefulWidget {
  const FuturePage({super.key});

  @override
  State<FuturePage> createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> {
  String _result = "";

  // 🔹 Langkah 4: Method untuk mengambil data dari API
  Future<void> getData() async {
    const String baseUrl = 'https://www.googleapis.com/books/v1/volumes/';
    const String path = 'RS7GDwAAQBAJ'; // Ganti dengan ID buku favoritmu
    final Uri url = Uri.parse('$baseUrl$path');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _result = jsonEncode(jsonDecode(response.body));
        });
      } else {
        setState(() {
          _result = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    }
  }

  // 🔹 build() menampilkan tampilan aplikasi
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Books App - Harist")),
      body: Center(
        child: _result.isEmpty
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Text(_result),
              ),
      ),
      // 🔹 Langkah 5: Tombol untuk memanggil getData()
      floatingActionButton: ElevatedButton(
        onPressed: () {
          getData().then((_) {
            setState(() {
              _result = _result.substring(0, 500); // tampilkan 500 karakter pertama
            });
          }).catchError((error) {
            setState(() {
              _result = 'Error: $error';
            });
          });
        },
        child: const Text('Get Data'),
      ),
    );
  }
}
