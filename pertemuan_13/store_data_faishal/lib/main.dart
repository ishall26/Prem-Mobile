import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'model/pizza.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pizza Store App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PizzaListScreen(),
    );
  }
}

class PizzaListScreen extends StatefulWidget {
  const PizzaListScreen({Key? key}) : super(key: key);

  @override
  State<PizzaListScreen> createState() => _PizzaListScreenState();
}

class _PizzaListScreenState extends State<PizzaListScreen> {
  List<dynamic> pizzaData = [];

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    final String response =
        await rootBundle.loadString('assets/pizzalist.json');
    final data = jsonDecode(response);
    setState(() {
      pizzaData = data["menu"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Pizza"),
      ),
      body: pizzaData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pizzaData.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: const Icon(Icons.local_pizza, size: 40),
                    title: Text(pizzaData[index]["nama"]),
                    subtitle:
                        Text("Harga: Rp ${pizzaData[index]["harga"]}"),
                  ),
                );
              },
            ),
    );
  }
}
