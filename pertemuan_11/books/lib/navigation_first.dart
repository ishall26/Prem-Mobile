import 'package:flutter/material.dart';
import 'navigation_second.dart';

class NavigationFirst extends StatefulWidget {
  const NavigationFirst({super.key});

  @override
  State<NavigationFirst> createState() => _NavigationFirstState();
}

class _NavigationFirstState extends State<NavigationFirst> {
  Color color = Colors.white;

  // Langkah 3: Method untuk navigasi dan mendapatkan warna
  Future _navigateAndGetColor(BuildContext context) async {
    color = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NavigationSecond(),
          ),
        ) ??
        Colors.blue; // fallback jika tidak ada warna yang dikembalikan

    setState(() {}); // update UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        title: const Text('Praktikum 8 - Harist'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _navigateAndGetColor(context),
          child: const Text('Pilih Warna'),
        ),
      ),
    );
  }
}
