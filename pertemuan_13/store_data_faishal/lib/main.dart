import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
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
  int appCounter = 0;

  @override
  void initState() {
    super.initState();
    readAndWritePreference();
    loadJsonData();
  }

  // Konstanta untuk SharedPreferences key
  static const String keyAppCounter = 'appCounter';

  // Method untuk membaca dan menulis preference
  Future<void> readAndWritePreference() async {
    final prefs = await SharedPreferences.getInstance();

    // Baca nilai counter dari storage
    final counter = prefs.getInt(keyAppCounter) ?? 0;

    // Increment counter
    final newCounter = counter + 1;

    // Simpan nilai baru
    await prefs.setInt(keyAppCounter, newCounter);

    // Update UI
    setState(() {
      appCounter = newCounter;
    });
  }

  // Method untuk menghapus preference
  Future<void> deletePreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    setState(() {
      appCounter = 0;
    });
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
      appBar: AppBar(title: const Text("Pizza Store App"), centerTitle: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : Column(
              children: [
                // Counter Display Section
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.blue.shade50,
                  child: Column(
                    children: [
                      const Text(
                        'App Open Counter',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'You have opened the app $appCounter times',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton.icon(
                        onPressed: deletePreference,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset Counter'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // Pizza List Section
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Daftar Pizza',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: pizzaData.isEmpty
                      ? const Center(child: Text("Tidak ada data pizza"))
                      : ListView.builder(
                          itemCount: pizzaData.length,
                          itemBuilder: (context, index) {
                            final pizza = pizzaData[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.local_pizza,
                                  size: 40,
                                  color: Colors.orange,
                                ),
                                title: Text(
                                  pizza.pizzaName.isEmpty
                                      ? 'No Name'
                                      : pizza.pizzaName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Harga: Rp ${pizza.price}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  'ID: ${pizza.id}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
