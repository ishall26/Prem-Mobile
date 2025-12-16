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
  List<Pizza> pizzaData = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/pizzalist.json',
      );
      final data = jsonDecode(response) as List<dynamic>;
      setState(() {
        pizzaData = data
            .map((item) => Pizza.fromJson(item as Map<String, dynamic>))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading pizza data: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Pizza")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : pizzaData.isEmpty
          ? const Center(child: Text("Tidak ada data pizza"))
          : ListView.builder(
              itemCount: pizzaData.length,
              itemBuilder: (context, index) {
                final pizza = pizzaData[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: const Icon(Icons.local_pizza, size: 40),
                    title: Text(
                      pizza.pizzaName.isEmpty ? 'No Name' : pizza.pizzaName,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pizza.description.isEmpty
                              ? 'No Description'
                              : pizza.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text("Harga: Rp ${pizza.price}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
