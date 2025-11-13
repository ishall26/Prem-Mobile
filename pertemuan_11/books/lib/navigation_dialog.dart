import 'package:flutter/material.dart';

class NavigationDialog extends StatefulWidget {
  const NavigationDialog({super.key});

  @override
  State<NavigationDialog> createState() => _NavigationDialogState();
}

class _NavigationDialogState extends State<NavigationDialog> {
  Color color = Colors.white;

  // Langkah 3: Method async untuk menampilkan dialog
  Future<void> _showColorDialog() async {
    Color? selectedColor = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Warna - Harist'),
          content: const Text('Silakan pilih warna favorit Anda'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, Colors.purple),
              child: const Text('Ungu'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, Colors.teal),
              child: const Text('Hijau Tosca'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, Colors.yellow),
              child: const Text('Kuning'),
            ),
          ],
        );
      },
    );

    // Setelah dialog ditutup, update warna background
    if (selectedColor != null) {
      setState(() {
        color = selectedColor;
      });
    }
  }

  // Langkah 4: Panggil method di ElevatedButton
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        title: const Text('Praktikum 9 - Harist'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _showColorDialog,
          child: const Text('Pilih Warna dari Dialog'),
        ),
      ),
    );
  }
}
