# Dokumentasi Lengkap: Store Data Faishal

## Pertemuan 13: Praktikum 1 & 2 - Menangani Data JSON di Flutter

---

# PRAKTIKUM 1: Load dan Parse Data JSON

## Tujuan Praktikum 1

Membuat aplikasi Flutter yang dapat:
1. Membaca file JSON dari assets
2. Membuat model data (Pizza) dengan struktur yang tepat
3. Parse JSON menjadi object Dart
4. Menampilkan data di UI dengan ListView

## Langkah-Langkah Praktikum 1

### Langkah 1: Membuat Struktur Data JSON
**File: `assets/pizzalist.json`**

Dibuat file JSON berisi daftar pizza dengan struktur:
```json
{
  "id": 1,
  "pizzaName": "Margherita",
  "description": "Pizza with tomato, fresh mozzarella and basil",
  "price": 8.75,
  "imageUrl": "images/margherita.png"
}
```

Field yang digunakan:
- `id` (int): Identitas unik pizza
- `pizzaName` (String): Nama pizza
- `description` (String): Deskripsi pizza
- `price` (double): Harga pizza
- `imageUrl` (String): URL gambar pizza

### Langkah 2: Membuat Model Pizza
**File: `lib/model/pizza.dart`**

```dart
class Pizza {
  int id;
  String pizzaName;
  String description;
  double price;
  String imageUrl;

  Pizza({
    required this.id,
    required this.pizzaName,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
```

Model ini mendefinisikan struktur data yang akan digunakan di seluruh aplikasi.

### Langkah 3: Membuat Factory Constructor fromJson
**File: `lib/model/pizza.dart`**

```dart
factory Pizza.fromJson(Map<String, dynamic> json) {
  return Pizza(
    id: json['id'],
    pizzaName: json['pizzaName'],
    description: json['description'],
    price: json['price'],
    imageUrl: json['imageUrl'],
  );
}
```

Factory constructor ini mengubah Map JSON menjadi object Pizza.

### Langkah 4: Membuat Fungsi Load JSON
**File: `lib/main.dart`**

```dart
Future<void> loadJsonData() async {
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
}
```

Fungsi ini:
- Membaca file JSON dari assets
- Decode JSON string menjadi List
- Map setiap item menjadi object Pizza
- Update state dengan data yang telah diparsing

### Langkah 5: Menampilkan Data di UI
**File: `lib/main.dart`**

```dart
ListView.builder(
  itemCount: pizzaData.length,
  itemBuilder: (context, index) {
    final pizza = pizzaData[index];
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: const Icon(Icons.local_pizza, size: 40),
        title: Text(pizza.pizzaName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pizza.description),
            Text("Harga: Rp ${pizza.price}"),
          ],
        ),
      ),
    );
  },
)
```

Menampilkan data dalam bentuk list dengan Card dan ListTile.

### Langkah 6: Menjalankan Aplikasi
Aplikasi dapat dijalankan dengan `flutter run` dan menampilkan daftar pizza dengan data yang berhasil diparsing dari JSON.

## Hasil Praktikum 1
✅ Aplikasi dapat membaca JSON dari assets
✅ Data berhasil diparsing menjadi object Pizza
✅ UI menampilkan daftar pizza dengan informasi lengkap

---

# PRAKTIKUM 2: Handle Kompatibilitas Data JSON

## Tujuan Praktikum 2

Membuat aplikasi lebih tangguh dengan menangani:
1. Data JSON yang tidak konsisten (tipe data berbeda)
2. Field yang null atau missing
3. Error handling yang proper
4. UI yang user-friendly saat ada data yang tidak lengkap

## Langkah-Langkah Praktikum 2

### Langkah 1-2: Simulasi Error dengan Data Tidak Konsisten
**File: `assets/pizzalist_broken.json`** (Baru)

```json
[
  {
    "id": "1",
    "pizzaName": "Margherita",
    "price": "8.75"
  },
  {
    "id": 2,
    "pizzaName": null,
    "price": 7.50
  },
  {
    "id": "3",
    "description": "Pizza with tomato, garlic and anchovies",
    "price": "9.50"
  }
]
```

Masalah simulasi:
- ID sebagai String dan Integer (tidak konsisten)
- pizzaName yang null
- Field description yang hilang
- Price sebagai String dan Double (tidak konsisten)

### Langkah 3: Terapkan tryParse dan Null Coalescing pada ID
**File: `lib/model/pizza.dart`**

```dart
id: json['id'] is int
    ? json['id']
    : int.tryParse(json['id']?.toString() ?? '') ?? 0,
```

**Penjelasan:**
- `json['id'] is int`: Cek apakah value sudah integer
- Jika ya, gunakan langsung
- Jika tidak, `.toString()`: konversi ke string
- `int.tryParse()`: parse string ke integer (return null jika gagal)
- `?? 0`: gunakan default 0 jika parsing gagal atau null

**Benefit:**
- ID dari string "1" akan dikonversi ke integer 1
- ID dari integer 2 tetap menjadi 2
- ID yang null akan menjadi 0 (default)

### Langkah 4-5: Terapkan Null Coalescing pada String
**File: `lib/model/pizza.dart`**

```dart
pizzaName: json['pizzaName']?.toString() ?? 'No Name',
description: json['description']?.toString() ?? 'No Description',
imageUrl: json['imageUrl']?.toString() ?? '',
```

**Penjelasan:**
- `?.toString()`: safely convert ke string (return null jika source null)
- `??`: null coalescing operator
- `'No Name'`: default placeholder jika null

**Benefit:**
- Memastikan semua field String selalu bernilai String (tidak null)
- Menangani missing field dengan placeholder yang deskriptif

### Langkah 6: Gunakan toString() untuk Field String
Semua field String sudah menggunakan `.toString()` untuk memastikan:
- Nilai yang mungkin int/double akan dikonversi ke string
- Konsistensi tipe data di seluruh model

### Langkah 7-8: Terapkan double.tryParse pada Price
**File: `lib/model/pizza.dart`**

```dart
price: json['price'] is double
    ? json['price']
    : double.tryParse(json['price']?.toString() ?? '') ?? 0,
```

**Penjelasan:**
- `json['price'] is double`: Cek tipe data
- Jika bukan double, konversi string ke double
- Default 0 jika parsing gagal

**Benefit:**
- Price dari string "8.75" akan menjadi double 8.75
- Price dari integer 7 akan menjadi 7.0
- Price yang null akan menjadi 0.0 (default)

### Langkah 9: Observasi Output Null
Sebelum implementasi step 10, aplikasi mungkin menampilkan "null" di UI jika field kosong.

### Langkah 10: Tambahkan Operator Ternary untuk Output User-Friendly
**File: `lib/main.dart`**

```dart
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
```

**Penjelasan:**
- Ternary operator `condition ? valueIfTrue : valueIfFalse`
- Check apakah field isEmpty
- Tampilkan placeholder jika kosong
- `maxLines: 2, overflow: TextOverflow.ellipsis`: Truncate deskripsi yang panjang

**Benefit:**
- UI tidak menampilkan nilai "null"
- Tampilan lebih user-friendly dengan placeholder
- Deskripsi panjang tidak mengacaukan layout

### Langkah 11: Run Aplikasi
Aplikasi berjalan dengan menampilkan data yang ditangani dengan baik.

## File-File Implementasi

### 1. `lib/model/pizza.dart` - Model Data
- Constructor dengan required parameters
- Factory method `fromJson()` dengan type casting robust
- Method `toJson()` untuk serialisasi
- Penanganan: type casting, null coalescing, default values

### 2. `lib/main.dart` - Main Application & UI
- Import model Pizza
- Fungsi `loadJsonData()` dengan error handling try-catch
- State variables: `pizzaData`, `isLoading`, `errorMessage`
- UI dengan ListView.builder dan Card
- Ternary operator untuk user-friendly display

### 3. `assets/pizzalist.json` - Data Normal
- 5 item pizza dengan data konsisten
- Format yang sesuai dengan model

### 4. `assets/pizzalist_broken.json` - Data Tidak Konsisten (Testing)
- Data dengan berbagai masalah (string/int/null)
- Digunakan untuk memverifikasi robustness aplikasi

### 5. `pubspec.yaml` - Konfigurasi Project
- Assets registration untuk JSON files
- Dependencies management

## Teknik yang Digunakan

| Teknik | Kegunaan | Contoh |
|--------|----------|---------|
| **Type Casting** | Konversi tipe data berbeda | `int.tryParse()`, `double.tryParse()` |
| **Null Coalescing (`??`)** | Provide default value | `json['id'] ?? 0` |
| **Safe Navigation (`?.`)** | Akses field yang mungkin null | `json['name']?.toString()` |
| **Type Check (`is`)** | Cek tipe data | `json['id'] is int` |
| **Ternary Operator** | Conditional expression | `isEmpty ? 'placeholder' : value` |
| **Try-Catch** | Error handling | `try { ... } catch (e) { ... }` |

## Output yang Diharapkan

Aplikasi dapat menangani:
- ✅ ID sebagai String atau Integer → Dikonversi ke Integer
- ✅ Price sebagai String atau Double → Dikonversi ke Double
- ✅ Field String yang null → Menampilkan placeholder
- ✅ Field yang missing → Menggunakan default value
- ✅ UI tidak menampilkan "null" → Menggunakan ternary operator
- ✅ Error loading data → Ditampilkan dengan error message

## Kesimpulan

**Praktikum 1** mengajarkan dasar-dasar:
- Membuat model data
- Membaca dan parse JSON
- Menampilkan data di UI

**Praktikum 2** mengajarkan robustness:
- Type casting untuk data tidak konsisten
- Null handling dengan null coalescing
- Error handling dengan try-catch
- UI yang user-friendly dengan ternary operator

Kombinasi kedua praktikum ini menghasilkan aplikasi Flutter yang production-ready dan dapat menangani berbagai skenario data yang tidak ideal.

---

# PRAKTIKUM 3: Menangani Error JSON dengan Konstanta

## Tujuan Praktikum 3

Meningkatkan keamanan dan maintainability kode dengan:
1. Mengganti string literals dengan konstanta
2. Menghindari typo pada JSON keys
3. Membuat kode lebih mudah di-maintain
4. Meningkatkan code reusability

## Masalah dengan String Literals

**Contoh masalah:**
```dart
// ❌ String literals - rentan error
pizzaName: json['pizzaName']?.toString() ?? 'No Name',
description: json['description']?.toString() ?? 'No Description',
```

**Risiko:**
- Typo pada nama kunci: `json['pizzaNam']` (lupa huruf 'e')
- Kesulitan debugging - error terjadi saat runtime, bukan compile-time
- Jika ada banyak file yang menggunakan kunci yang sama, perlu mengupdate banyak file
- Tidak ada refactoring otomatis jika nama kunci berubah

## Solusi: Menggunakan Konstanta

**Langkah 1: Deklarasikan Konstanta di Atas Class**
**File: `lib/model/pizza.dart`**

```dart
// Konstanta untuk JSON keys
const String keyId = 'id';
const String keyPizzaName = 'pizzaName';
const String keyDescription = 'description';
const String keyPrice = 'price';
const String keyImageUrl = 'imageUrl';
```

**Benefit:**
- Semua kunci JSON terdefinisi di satu tempat
- Mudah untuk referensi dan maintain
- Compiler dapat mendeteksi typo saat compile-time

## Langkah 2: Perbarui fromJson() Menggunakan Konstanta

```dart
factory Pizza.fromJson(Map<String, dynamic> json) {
  return Pizza(
    id: json[keyId] is int
        ? json[keyId]
        : int.tryParse(json[keyId]?.toString() ?? '') ?? 0,

    pizzaName: json[keyPizzaName]?.toString() ?? 'No Name',

    description: json[keyDescription]?.toString() ?? 'No Description',

    price: json[keyPrice] is double
        ? json[keyPrice]
        : double.tryParse(json[keyPrice]?.toString() ?? '') ?? 0,

    imageUrl: json[keyImageUrl]?.toString() ?? '',
  );
}
```

**Perubahan:**
- `json['id']` → `json[keyId]`
- `json['pizzaName']` → `json[keyPizzaName]`
- `json['description']` → `json[keyDescription]`
- `json['price']` → `json[keyPrice]`
- `json['imageUrl']` → `json[keyImageUrl]`

## Langkah 3: Perbarui toJson() Menggunakan Konstanta

```dart
Map<String, dynamic> toJson() {
  return {
    keyId: id,
    keyPizzaName: pizzaName,
    keyDescription: description,
    keyPrice: price,
    keyImageUrl: imageUrl,
  };
}
```

**Perubahan:**
- `'id'` → `keyId`
- `'pizzaName'` → `keyPizzaName`
- `'description'` → `keyDescription`
- `'price'` → `keyPrice`
- `'imageUrl'` → `keyImageUrl`

## Langkah 4: Run Aplikasi

Aplikasi berjalan tanpa perubahan visual, tetapi code menjadi lebih aman dan maintainable.

## Soal 5: Jelaskan "Safe dan Maintainable"

### Safe (Aman)

**1. Compile-Time Error Detection**
```dart
// ❌ String literal - error terdeteksi saat runtime
json['pizzaNam']  // Typo, tidak terdeteksi sampai runtime

// ✅ Konstanta - error terdeteksi saat compile-time
json[keyPizzaNam]  // ERROR! Konstanta tidak ada - compiler akan error
```

**2. Refactoring Aman**
Jika nama kunci JSON berubah:
```dart
// ❌ String literal - harus update semua tempat secara manual
// File 1: json['pizzaName']
// File 2: json['pizzaName']
// File 3: json['pizzaName']
// ... risiko lupa update salah satu tempat

// ✅ Konstanta - update hanya di satu tempat
const String keyPizzaName = 'pizzaName'; // Update sini saja
```

**3. Menghindari Typo**
```dart
// ❌ Mudah typo pada string literal
json['pizzzaName']  // Lupa huruf 'a' - compiler tidak akan error
json['PIZZANAME']   // Salah case - compiler tidak akan error

// ✅ Konstanta - IDE akan auto-complete dan tidak ada typo
json[keyPizzaName]  // IDE otomatis melengkapi
```

### Maintainable (Mudah Dirawat)

**1. Centralized Definition**
```dart
// Semua kunci JSON terdefinisi di satu tempat
const String keyId = 'id';
const String keyPizzaName = 'pizzaName';
const String keyDescription = 'description';
const String keyPrice = 'price';
const String keyImageUrl = 'imageUrl';

// Mudah melihat semua kunci yang digunakan dalam model
```

**2. Documentation Clarity**
Konstanta membuat kode lebih self-documenting:
```dart
// ✅ Jelas apa yang diakses dari JSON
pizzaName: json[keyPizzaName]?.toString() ?? 'No Name',

// ❌ Kurang jelas
pizzaName: json['pizzaName']?.toString() ?? 'No Name',
```

**3. Easy Search & Replace**
Dengan konstanta, developer bisa dengan mudah:
- Mencari di mana kunci JSON digunakan dengan IDE search
- Refactor semua referensi sekaligus
- Memahami dependencies dengan lebih jelas

**4. Consistency Across Files**
Jika multiple files menggunakan model Pizza:
```dart
// ✅ Semua file menggunakan kunci yang sama
File 1: json[keyPizzaName]
File 2: json[keyPizzaName]
File 3: json[keyPizzaName]

// ❌ Risiko inkonsistensi dengan string literal
File 1: json['pizzaName']
File 2: json['pizzaNam']   // Typo!
File 3: json['PizzaName']  // Case sensitivity!
```

## Perbandingan Sebelum & Sesudah

| Aspek | String Literals | Konstanta |
|-------|-----------------|-----------|
| **Error Detection** | Runtime | Compile-time |
| **Typo Protection** | ❌ Tidak | ✅ Ya |
| **Refactoring** | Manual, risiko tinggi | Otomatis, aman |
| **Documentation** | Kurang jelas | Self-documenting |
| **Reusability** | Perlu copy-paste | Central definition |
| **Maintainability** | Sulit | Mudah |
| **IDE Support** | Minimal | Auto-complete |

## Best Practices

### 1. Letakkan Konstanta di Atas Class
```dart
const String keyId = 'id';
const String keyPizzaName = 'pizzaName';
// ... konstanta lainnya

class Pizza {
  // ... class definition
}
```

### 2. Gunakan Naming Convention yang Jelas
```dart
// ✅ Jelas ini adalah JSON key
const String keyPizzaName = 'pizzaName';

// ❌ Ambigu
const String pizzaName = 'pizzaName';
```

### 3. Group Konstanta Sesuai Model
Jika ada model lain, pisahkan konstanta:
```dart
// Pizza constants
const String keyId = 'id';
const String keyPizzaName = 'pizzaName';

// Jangan campur dengan konstanta model lain
```

## Kesimpulan Praktikum 3

Dengan menggunakan konstanta untuk JSON keys:
- ✅ **Safe**: Error terdeteksi lebih awal (compile-time)
- ✅ **Maintainable**: Mudah untuk refactor dan update
- ✅ **Professional**: Best practice dalam production code
- ✅ **Scalable**: Mudah dikembangkan ke file-file baru

Praktikum 3 menunjukkan pentingnya code quality dan best practices dalam development, bukan hanya fungsionalitas yang bekerja.

---

# PRAKTIKUM 4: Menyimpan Data dengan SharedPreferences

## Tujuan Praktikum 4

Mempelajari cara menyimpan data sederhana ke local storage menggunakan SharedPreferences:
1. Menambahkan package shared_preferences
2. Membaca dan menulis data dari/ke storage
3. Menggunakan null coalescing untuk default values
4. Menghapus data dari storage
5. Mengintegrasikan dengan JSON loading dari praktikum sebelumnya

## Konsep SharedPreferences

SharedPreferences adalah cara sederhana menyimpan data key-value pairs di local device storage. Cocok untuk menyimpan:
- User preferences
- App settings
- Simple counters
- Flags dan booleans
- Strings dan numbers

## Langkah-Langkah Implementasi

### Langkah 1-2: Tambah dan Install Dependensi
```bash
flutter pub add shared_preferences
flutter pub get
```

Ini akan menambahkan package ke `pubspec.yaml` dan mengunduh semua dependencies yang diperlukan.

### Langkah 3: Import SharedPreferences
```dart
import 'package:shared_preferences/shared_preferences.dart';
```

### Langkah 4: Deklarasikan Variabel Counter
```dart
class _PizzaListScreenState extends State<PizzaListScreen> {
  List<Pizza> pizzaData = [];
  bool isLoading = true;
  String? errorMessage;
  int appCounter = 0;  // ← Variabel untuk menyimpan counter
```

### Langkah 5-6: Buat Method readAndWritePreference()
```dart
Future<void> readAndWritePreference() async {
  final prefs = await SharedPreferences.getInstance();
  // ...
}
```

Method ini:
- `async`: Operasi bersifat asinkron (membutuhkan time)
- `await SharedPreferences.getInstance()`: Mendapatkan instance untuk mengakses storage

### Langkah 7: Baca, Cek Null, dan Increment Counter
```dart
final counter = prefs.getInt(keyAppCounter) ?? 0;
final newCounter = counter + 1;
```

**Penjelasan:**
- `prefs.getInt(keyAppCounter)`: Membaca nilai integer dari storage
- `?? 0`: Null coalescing - jika tidak ada data, gunakan default 0
- `counter + 1`: Increment nilai

### Langkah 8: Simpan Nilai Baru
```dart
await prefs.setInt(keyAppCounter, newCounter);
```

Menyimpan nilai counter yang sudah di-increment ke storage.

### Langkah 9: Perbarui State dengan setState()
```dart
setState(() {
  appCounter = newCounter;
});
```

Memicu rebuild widget dengan nilai counter terbaru.

### Langkah 10: Panggil di initState()
```dart
@override
void initState() {
  super.initState();
  readAndWritePreference();  // ← Panggil di initState
  loadJsonData();
}
```

initState() dipanggil sekali saat widget pertama kali dibuat, ideal untuk operasi inisialisasi.

### Langkah 11: Perbarui Tampilan UI
```dart
Container(
  padding: const EdgeInsets.all(20),
  color: Colors.blue.shade50,
  child: Column(
    children: [
      const Text(
        'App Open Counter',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      Text(
        'You have opened the app $appCounter times',
        style: const TextStyle(fontSize: 16),
      ),
      const SizedBox(height: 15),
      ElevatedButton.icon(
        onPressed: deletePreference,
        icon: const Icon(Icons.refresh),
        label: const Text('Reset Counter'),
      ),
    ],
  ),
)
```

Menampilkan:
- Judul "App Open Counter"
- Pesan berapa kali app dibuka
- Tombol "Reset Counter"

### Langkah 12: Run Aplikasi
Aplikasi sekarang akan:
- Membaca counter saat startup
- Menambah counter setiap kali app dibuka
- Menampilkan: "You have opened the app X times"

### Langkah 13: Buat Method deletePreference()
```dart
Future<void> deletePreference() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  
  setState(() {
    appCounter = 0;
  });
}
```

**Penjelasan:**
- `prefs.clear()`: Menghapus SEMUA data yang disimpan
- `setState()`: Reset UI dengan counter 0

### Langkah 14: Hubungkan ke Tombol Reset
```dart
ElevatedButton.icon(
  onPressed: deletePreference,  // ← Ketika tombol ditekan
  icon: const Icon(Icons.refresh),
  label: const Text('Reset Counter'),
)
```

### Langkah 15: Test Aplikasi
1. Jalankan aplikasi → Counter menunjukkan 1
2. Close dan buka lagi → Counter menunjukkan 2
3. Klik "Reset Counter" → Counter kembali ke 0
4. Close dan buka lagi → Counter menunjukkan 1 (reset berhasil)

## Best Practices SharedPreferences

### 1. Gunakan Konstanta untuk Keys
```dart
// ✅ Good
static const String keyAppCounter = 'appCounter';
await prefs.setInt(keyAppCounter, newCounter);

// ❌ Bad - mudah typo
await prefs.setInt('appCounter', newCounter);
await prefs.getInt('appcounter');  // Typo! Case sensitivity
```

### 2. Selalu Gunakan Null Coalescing
```dart
// ✅ Good - handle data yang belum ada
final counter = prefs.getInt(keyAppCounter) ?? 0;

// ❌ Bad - bisa return null
final counter = prefs.getInt(keyAppCounter);
```

### 3. Gunakan Async/Await dengan Proper Error Handling
```dart
// ✅ Good
Future<void> readAndWritePreference() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final counter = prefs.getInt(keyAppCounter) ?? 0;
    final newCounter = counter + 1;
    await prefs.setInt(keyAppCounter, newCounter);
    setState(() {
      appCounter = newCounter;
    });
  } catch (e) {
    print('Error: $e');
  }
}

// ❌ Bad - tanpa error handling
Future<void> readAndWritePreference() async {
  final prefs = await SharedPreferences.getInstance();
  // ...
}
```

### 4. Clear() vs Remove()
```dart
// Hapus semua data
await prefs.clear();

// Hapus data tertentu
await prefs.remove(keyAppCounter);
```

## Integrasi dengan Praktikum Sebelumnya

Praktikum 4 mengintegrasikan:
- **Praktikum 1**: Load JSON pizza data
- **Praktikum 2**: Handle data tidak konsisten dengan type casting
- **Praktikum 3**: Konstanta untuk JSON keys
- **Praktikum 4**: SharedPreferences untuk counter

**Hasil akhir:**
- UI menampilkan counter app opens
- Tombol reset menghapus semua data storage
- Daftar pizza dari JSON tetap ditampilkan
- Kombinasi sempurna antara API/JSON data dan local storage

## Perbandingan Storage Solutions

| Fitur | SharedPreferences | SQLite | Firebase |
|-------|------------------|--------|----------|
| **Tipe Data** | Key-value simple | Complex relational | Cloud-based |
| **Ukuran Data** | Kecil | Medium-Large | Unlimited |
| **Async** | Ya | Ya | Ya |
| **Query** | Tidak | Ya | Ya |
| **Offline** | Ya | Ya | Partial |
| **Kompleksitas** | Mudah | Medium | Complex |
| **Use Case** | Settings, Flags | Structured data | Sync across devices |

SharedPreferences ideal untuk data sederhana seperti user preferences, app settings, dan simple counters.

## Kesimpulan Praktikum 4

Dengan SharedPreferences, aplikasi dapat:
- ✅ Menyimpan data di local device
- ✅ Membaca data yang sudah disimpan
- ✅ Menghapus data yang tidak diperlukan
- ✅ Menangani data yang tidak ada dengan default values
- ✅ Membuat app lebih interactive dan persistent

Praktikum 1-4 mengajarkan full cycle development:
1. **Load & Parse**: Membaca data eksternal (JSON)
2. **Handle Error**: Menangani data tidak konsisten
3. **Code Quality**: Best practices dengan konstanta
4. **Persistence**: Menyimpan data lokal dengan SharedPreferences

---

# PRAKTIKUM 5: Akses Filesystem dengan path_provider

## Tujuan Praktikum 5

Mempelajari cara mengakses filesystem pada perangkat menggunakan path_provider untuk:
1. Menemukan direktori dokumen aplikasi
2. Menemukan direktori temporary files
3. Menampilkan jalur absolut ke direktori tersebut
4. Memahami direktori sistem file pada berbagai platform

## Langkah-Langkah Praktikum 5

### Langkah 1: Tambahkan Dependensi path_provider
**Terminal:**
```bash
flutter pub add path_provider
```

Package `path_provider` menyediakan cara yang konsisten untuk mengakses direktori sistem file di berbagai platform (Android, iOS, Windows, Linux, macOS).

### Langkah 2: Lakukan Import
**File: `lib/main.dart`**

```dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
```

**Penjelasan:**
- `dart:io`: Package untuk file/directory operations
- `path_provider`: Package untuk akses filesystem directories

### Langkah 3: Tambahkan Variabel Path State
**File: `lib/main.dart`**

```dart
class _PizzaListScreenState extends State<PizzaListScreen> {
  // ... variabel lainnya
  
  // Variabel untuk menyimpan path
  String documentsPath = '';
  String tempPath = '';
}
```

**Penjelasan:**
- `documentsPath`: Menyimpan jalur ke Application Documents Directory
- `tempPath`: Menyimpan jalur ke Temporary Directory
- Diinisialisasi dengan string kosong, nanti diisi async di `getPaths()`

### Langkah 4: Buat Method getPaths()
**File: `lib/main.dart`**

```dart
Future<void> getPaths() async {
  try {
    // Dapatkan documents directory
    final Directory documentsDir =
        await getApplicationDocumentsDirectory();
    
    // Dapatkan temporary directory
    final Directory tempDir = await getTemporaryDirectory();
    
    // Update state dengan paths
    setState(() {
      documentsPath = documentsDir.path;
      tempPath = tempDir.path;
    });
  } catch (e) {
    setState(() {
      errorMessage = 'Error getting paths: $e';
    });
  }
}
```

**Penjelasan:**
- `getApplicationDocumentsDirectory()`: Mengembalikan Directory untuk app documents
  - Android: `/data/user/0/com.example.app/files`
  - iOS: `/var/mobile/Containers/Data/Application/.../Documents`
  - Windows: `C:\Users\Username\AppData\Local\com.example.app`

- `getTemporaryDirectory()`: Mengembalikan Directory untuk temporary files
  - Android: `/data/user/0/com.example.app/cache`
  - iOS: `/var/mobile/Containers/Data/Application/.../tmp`
  - Windows: `C:\Users\Username\AppData\Local\Temp`

- `.path`: Property yang mengembalikan jalur absolut sebagai String
- `setState()`: Update UI dengan paths yang diterima

### Langkah 5: Panggil getPaths() di initState()

```dart
@override
void initState() {
  super.initState();
  getPaths();
  readAndWritePreference();
  loadJsonData();
}
```

`getPaths()` dipanggil pertama kali aplikasi terbuka untuk mengambil paths dari sistem.

### Langkah 6: Perbarui Tampilan

```dart
// Filesystem Paths Section
Container(
  padding: const EdgeInsets.all(16),
  color: Colors.orange.shade50,
  child: SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Filesystem Paths',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Documents Directory:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          documentsPath.isEmpty ? 'Loading...' : documentsPath,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontFamily: 'Courier',
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Temporary Directory:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          tempPath.isEmpty ? 'Loading...' : tempPath,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontFamily: 'Courier',
          ),
        ),
      ],
    ),
  ),
),
```

**Penjelasan UI:**
- Menampilkan dua section: Documents Directory dan Temporary Directory
- Menggunakan monospace font (`Courier`) untuk tampilan path yang lebih jelas
- Menampilkan "Loading..." saat path belum diambil
- Menggunakan `SingleChildScrollView` agar text yang panjang dapat di-scroll

### Langkah 7: Run Aplikasi

Aplikasi sekarang menampilkan:
- **Counter**: Berapa kali app dibuka (dari Praktikum 4)
- **Filesystem Paths**: Jalur absolut ke Documents dan Temp directories
- **Pizza List**: Daftar pizza dari JSON (dari Praktikum 1)

**Output contoh:**
```
App Open Counter: 5 times
Reset Counter: [Button]

Filesystem Paths
Documents Directory:
/data/user/0/com.example.store_data_faishal/files

Temporary Directory:
/data/user/0/com.example.store_data_faishal/cache

Daftar Pizza
[List of pizzas...]
```

## Soal 7: Jelaskan path_provider

### Apa itu path_provider?

`path_provider` adalah Flutter package yang menyediakan abstraksi untuk mengakses direktori sistem file yang umum digunakan aplikasi, tanpa perlu tahu detail implementasi platform.

### Mengapa path_provider Penting?

**1. Cross-Platform Compatibility**
```dart
// ❌ Hardcoded paths - hanya bekerja di Android
final dir = Directory('/data/data/com.example.app/');

// ✅ path_provider - bekerja di semua platform
final dir = await getApplicationDocumentsDirectory();
```

Path untuk menyimpan dokumen berbeda di setiap platform:
- **Android**: `/data/user/0/package.name/...`
- **iOS**: `/var/mobile/Containers/Data/Application/.../Documents`
- **Windows**: `C:\Users\Username\AppData\Local\...`
- **Linux**: `/home/username/.local/share/...`

path_provider handle semua ini secara otomatis.

**2. Platform-Specific Best Practices**
```dart
// Documents Directory: Untuk data yang disimpan permanen
final documentsDir = await getApplicationDocumentsDirectory();

// Temporary Directory: Untuk cache/temporary files
final tempDir = await getTemporaryDirectory();

// External Storage: Untuk akses file dari outside app (Android only)
final externalDir = await getExternalStorageDirectory();
```

Setiap platform memiliki guidelines untuk menyimpan file jenis apa di direktori mana.

**3. Permissions & Security**
path_provider menangani:
- Meminta permissions yang diperlukan secara otomatis
- Menyimpan file di lokasi yang aman dan sesuai platform
- Menghindari conflicts dengan app lain
- Mematuhi privacy regulations (data isolation)

### Direktori yang Tersedia

| Method | Tujuan | Platform | Permanent |
|--------|--------|----------|-----------|
| `getApplicationDocumentsDirectory()` | App data penting | All | Ya |
| `getTemporaryDirectory()` | Cache/temp files | All | Tidak |
| `getApplicationSupportDirectory()` | App support files | iOS, macOS | Ya |
| `getApplicationCacheDirectory()` | App cache | All | Tidak |
| `getExternalStorageDirectory()` | External storage | Android | Ya |
| `getDownloadsDirectory()` | Downloads folder | Android | Ya |

### Use Cases Praktis

**1. Menyimpan User Preferences**
```dart
final dir = await getApplicationDocumentsDirectory();
final file = File('${dir.path}/preferences.json');
await file.writeAsString(jsonData);
```

**2. Menyimpan Cache Images**
```dart
final dir = await getTemporaryDirectory();
final file = File('${dir.path}/cached_image.png');
await file.writeAsBytes(imageBytes);
```

**3. Menyimpan Database**
```dart
final dir = await getApplicationDocumentsDirectory();
final dbFile = File('${dir.path}/app.db');
// Gunakan dengan SQLite atau Hive
```

**4. Menyimpan Downloaded Files**
```dart
final dir = await getDownloadsDirectory();
final file = File('${dir.path}/document.pdf');
await file.writeAsBytes(pdfBytes);
```

## Integrasi dengan Praktikum Sebelumnya

Praktikum 5 mengintegrasikan:
- **Praktikum 1**: Load JSON pizza data ✅
- **Praktikum 2**: Handle data tidak konsisten ✅
- **Praktikum 3**: Konstanta untuk JSON keys ✅
- **Praktikum 4**: SharedPreferences untuk counter ✅
- **Praktikum 5**: path_provider untuk filesystem access ✅

**Aplikasi sekarang menampilkan:**
1. **Data Persistence**: Counter disimpan dengan SharedPreferences
2. **External Data**: Pizza list dari JSON
3. **Filesystem Info**: Paths dari path_provider
4. **Error Handling**: Try-catch untuk async operations

## Kesimpulan Praktikum 5

Dengan path_provider, aplikasi dapat:
- ✅ Akses filesystem dengan cara yang safe dan cross-platform
- ✅ Menyimpan file di lokasi yang tepat untuk setiap platform
- ✅ Menangani permissions dan security dengan benar
- ✅ Membangun aplikasi yang properly structured

## Kesimpulan Praktikum 5

Dengan path_provider, aplikasi dapat:
- ✅ Akses direktori sistem file secara cross-platform
- ✅ Menampilkan jalur absolut ke direktori aplikasi
- ✅ Menyimpan file di lokasi yang aman dan sesuai platform
- ✅ Memahami struktur filesystem berbeda di setiap platform

Praktikum 1-5 mengajarkan full cycle development:
1. **Load & Parse**: Membaca data eksternal (JSON)
2. **Handle Error**: Menangani data tidak konsisten
3. **Code Quality**: Best practices dengan konstanta
4. **Persistence**: Menyimpan data lokal dengan SharedPreferences
5. **Filesystem**: Mengakses direktori sistem dengan path_provider

---

# PRAKTIKUM 6: File Operations - Baca dan Tulis File

## Tujuan Praktikum 6

Mempelajari cara membaca dan menulis file ke filesystem menggunakan dart:io:
1. Membuat file di direktori dokumen aplikasi
2. Menulis data ke file
3. Membaca data dari file
4. Menampilkan data yang dibaca di UI
5. Mengintegrasikan dengan path_provider dari praktikum 5

## Langkah-Langkah Implementasi

### Langkah 1: Deklarasikan Variabel File
**File: `lib/main.dart`**

```dart
class _PizzaListScreenState extends State<PizzaListScreen> {
  // ... variabel lainnya
  
  // File operation variables
  late File myFile;
  String fileText = '';
}
```

**Penjelasan:**
- `late File myFile`: Late initialization untuk File object
  - `late` keyword memungkinkan deklarasi tanpa harus inisialisasi langsung
  - Akan diinisialisasi nanti di `_initializeFile()` method
  
- `String fileText = ''`: Menyimpan content yang dibaca dari file
  - Digunakan untuk menampilkan isi file di UI

### Langkah 2: Buat Method _initializeFile()
**File: `lib/main.dart`**

```dart
Future<void> _initializeFile() async {
  try {
    // Tunggu documentsPath tersedia
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Buat File object dengan path
    final String pathSeparator = Platform.pathSeparator;
    myFile = File('$documentsPath${pathSeparator}user_data.txt');
    
    // Tulis initial data
    await writeFile();
  } catch (e) {
    setState(() {
      errorMessage = 'Error initializing file: $e';
    });
  }
}
```

**Penjelasan:**
- `Future.delayed()`: Tunggu 500ms agar `documentsPath` sudah diisi oleh `getPaths()`
- `Platform.pathSeparator`: Menggunakan path separator yang sesuai platform
  - Windows: `\`
  - Unix/Linux/macOS: `/`
  
- Membuat File object dengan path lengkap: `$documentsPath\user_data.txt`
- Memanggil `writeFile()` untuk menulis initial data

### Langkah 3: Buat Method writeFile()
**File: `lib/main.dart`**

```dart
Future<bool> writeFile() async {
  try {
    const String content = 'Muhammad Faishal Akbar - 2301081';
    await myFile.writeAsString(content);
    return true;
  } catch (e) {
    setState(() {
      errorMessage = 'Error writing file: $e';
    });
    return false;
  }
}
```

**Penjelasan:**
- `myFile.writeAsString(content)`: Menulis string ke file
  - Method ini adalah async dan mengembalikan Future
  - Jika file tidak ada, akan dibuat otomatis
  - Jika file sudah ada, akan overwrite dengan content baru

- `try-catch`: Error handling untuk menangkap exception
- `return true/false`: Mengembalikan status operasi

### Langkah 4: Buat Method readFile()
**File: `lib/main.dart`**

```dart
Future<void> readFile() async {
  try {
    final content = await myFile.readAsString();
    setState(() {
      fileText = content;
    });
  } catch (e) {
    setState(() {
      errorMessage = 'Error reading file: $e';
      fileText = 'File not found or error reading file';
    });
  }
}
```

**Penjelasan:**
- `myFile.readAsString()`: Membaca seluruh isi file sebagai string
  - Method ini adalah async dan mengembalikan Future<String>
  
- `setState()`: Update `fileText` dengan content yang dibaca
  - Memicu rebuild widget untuk menampilkan content terbaru

- Error handling: Jika file tidak ada atau error, tampilkan pesan error
  - Set `fileText` dengan pesan error yang user-friendly

### Langkah 5: Update initState()
**File: `lib/main.dart`**

```dart
@override
void initState() {
  super.initState();
  getPaths();
  _initializeFile();  // ← Tambahkan ini
  readAndWritePreference();
  loadJsonData();
}
```

`_initializeFile()` dipanggil di initState untuk menginisialisasi file saat app startup.

### Langkah 6: Tambahkan UI Section untuk File Operations
**File: `lib/main.dart`**

```dart
// File Operations Section
Container(
  padding: const EdgeInsets.all(16),
  color: Colors.green.shade50,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'File Operations',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
      const SizedBox(height: 12),
      ElevatedButton.icon(
        onPressed: readFile,
        icon: const Icon(Icons.folder_open),
        label: const Text('Read File'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      ),
      if (fileText.isNotEmpty) ...[
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            fileText,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    ],
  ),
),
```

**Penjelasan UI:**
- "Read File" button dengan green color untuk membedakan dengan section lain
- `if (fileText.isNotEmpty)`: Hanya tampilkan file content jika sudah dibaca
- Container dengan border untuk menampilkan content dengan jelas
- Icon `folder_open` untuk visual yang lebih intuitif

### Langkah 7: Run Aplikasi
Aplikasi sekarang akan:
1. Membuat file `user_data.txt` di Documents Directory saat startup
2. Menulis "Faishal Harist Rahmawan - 2341720218" ke file
3. Menampilkan section "File Operations" dengan tombol "Read File"
4. Ketika "Read File" ditekan, menampilkan content dari file

## Soal 8: Jelaskan Langkah 3 dan 7

### Langkah 3: Implementasi writeFile()

**Tujuan:** Menyimpan data user ke file di filesystem.

**Code:**
```dart
Future<bool> writeFile() async {
  try {
    const String content = 'Faishal Harist Rahmawan - 2341720218';
    await myFile.writeAsString(content);
    return true;
  } catch (e) {
    setState(() {
      errorMessage = 'Error writing file: $e';
    });
    return false;
  }
}
```

**Penjelasan Detail:**

1. **Method Signature**
   - `Future<bool>`: Method ini async dan mengembalikan boolean
   - `async`: Memungkinkan penggunaan `await` di dalam method
   - Return value: `true` jika sukses, `false` jika error

2. **Define Content**
   - `const String content = 'Faishal Harist Rahmawan - 2341720218'`
   - Ini adalah user data yang akan disimpan
   - Format: `Name - NIM` (NIM = Nomor Induk Mahasiswa)

3. **Write to File**
   - `await myFile.writeAsString(content)`
   - `myFile` adalah File object yang sudah diinisialisasi di `_initializeFile()`
   - `writeAsString()` menulis string ke file
   - Jika file tidak ada, akan dibuat otomatis
   - Jika file sudah ada, akan di-overwrite
   - `await`: Tunggu operasi selesai sebelum lanjut

4. **Error Handling**
   - `try-catch`: Tangkap semua exception yang mungkin terjadi
   - Exception dapat terjadi karena:
     - Permission denied (tidak punya akses write)
     - Disk full
     - Path tidak valid
   - Jika error, tampilkan error message di UI via `setState()`
   - Return `false` untuk mengindikasikan operasi gagal

5. **Return Value**
   - `return true`: Jika write berhasil
   - `return false`: Jika ada error
   - Caller dapat menggunakan return value ini untuk mengetahui status

**Benefit:**
- Data user tersimpan permanen di filesystem
- Tidak hilang meski app di-close
- Can be read later dengan `readFile()`

### Langkah 7: Run Aplikasi dan Verifikasi

**Tujuan:** Memastikan file operations berjalan dengan benar.

**Proses:**
1. **App Startup**
   - `initState()` dipanggil
   - `getPaths()` dijalankan untuk mendapat documentsPath
   - `_initializeFile()` dijalankan:
     - Tunggu 500ms agar documentsPath tersedia
     - Buat File object dengan path `$documentsPath\user_data.txt`
     - Call `writeFile()` untuk menulis initial data
   
2. **File Created**
   - File `user_data.txt` dibuat di direktori dokumen aplikasi
   - File content: "Faishal Harist Rahmawan - 2341720218"
   - Tetap ada meski app di-close

3. **User Interaction**
   - User melihat UI section "File Operations"
   - User dapat menekan tombol "Read File"

4. **Read File Operation**
   - Ketika "Read File" ditekan, `readFile()` dipanggil
   - File dibaca dengan `myFile.readAsString()`
   - Content ditampilkan di UI dalam container dengan border
   - Expected output: "Faishal Harist Rahmawan - 2341720218"

5. **Verification**
   - ✅ Content yang ditampilkan sesuai dengan yang ditulis
   - ✅ File dapat dibaca berkali-kali tanpa perlu menulis ulang
   - ✅ Content tetap sama setelah app di-close dan dibuka kembali
   - ✅ Error handling menampilkan pesan yang jelas jika ada masalah

**Expected Output:**
```
App Open Counter
You have opened the app X times
Reset Counter: [Button]

Filesystem Paths
Documents Directory: C:\Users\...\AppData\Local\...
Temporary Directory: C:\Users\...\AppData\Local\Temp

File Operations
Read File: [Button]
[File content displayed after button pressed]

Daftar Pizza
[Pizza list...]
```

## File Operations Deep Dive

### Perbedaan writeAsString dan writeAsBytes

```dart
// writeAsString - untuk text content
await file.writeAsString('Hello World');

// writeAsBytes - untuk binary content (images, etc)
await file.writeAsBytes(imageBytes);
```

### Perbedaan readAsString dan readAsBytes

```dart
// readAsString - baca sebagai text
final text = await file.readAsString();  // Returns String

// readAsBytes - baca sebagai binary
final bytes = await file.readAsBytes();  // Returns List<int>
```

### Append vs Overwrite

```dart
// Overwrite - mengganti seluruh content
await file.writeAsString('New content');

// Append - menambah di akhir file
await file.writeAsString('More content', mode: FileMode.append);
```

### Check File Exists

```dart
if (await myFile.exists()) {
  final content = await myFile.readAsString();
  print('File exists: $content');
} else {
  print('File does not exist');
}
```

### Delete File

```dart
if (await myFile.exists()) {
  await myFile.delete();
  print('File deleted');
}
```

## Best Practices File Operations

### 1. Selalu Gunakan Async/Await
```dart
// ✅ Good - non-blocking
Future<void> readFile() async {
  final content = await myFile.readAsString();
  setState(() { fileText = content; });
}

// ❌ Bad - akan block UI
final content = myFile.readAsStringSync();
```

### 2. Always Handle Errors
```dart
// ✅ Good
try {
  await myFile.writeAsString(content);
} catch (e) {
  print('Error: $e');
  setState(() { errorMessage = 'Failed to write file'; });
}

// ❌ Bad
await myFile.writeAsString(content);  // Bisa crash jika error
```

### 3. Gunakan Proper Path
```dart
// ✅ Good - cross-platform
final pathSeparator = Platform.pathSeparator;
final path = '$documentsPath${pathSeparator}file.txt';

// ❌ Bad - hanya bekerja di Windows
final path = '$documentsPath\\file.txt';
```

### 4. Initialize File dengan Late
```dart
// ✅ Good - late initialization saat path tersedia
late File myFile;

void _initializeFile() async {
  await Future.delayed(Duration(milliseconds: 500));
  myFile = File('$documentsPath/file.txt');
}

// ❌ Bad - tidak bisa di-initialize di state declaration
File myFile = File('...');  // Error! documentsPath tidak ada yet
```

### 5. Use Constants untuk Path/Filename
```dart
// ✅ Good
const String _fileName = 'user_data.txt';
final file = File('$documentsPath/$_fileName');

// ❌ Bad
final file = File('$documentsPath/user_data.txt');
```

## Integrasi File Operations dengan Praktikum Sebelumnya

Praktikum 6 mengintegrasikan:
- **Praktikum 5**: Menggunakan `documentsPath` dari path_provider
- **Praktikum 4**: SharedPreferences untuk app counter
- **Praktikum 1-3**: JSON loading dan parsing pizza data

**Hasil akhir:**
- Aplikasi dapat load JSON data (Praktikum 1)
- Handle data tidak konsisten dengan robust error handling (Praktikum 2-3)
- Store app counter di SharedPreferences (Praktikum 4)
- Access filesystem dengan path_provider (Praktikum 5)
- Read/write files ke filesystem (Praktikum 6)

**Kombinasi features:**
1. Load pizza data dari JSON assets
2. Show app open counter
3. Display filesystem paths
4. Write user data ke file
5. Read user data dari file

## Kesimpulan Praktikum 6

Dengan file operations, aplikasi dapat:
- ✅ Menyimpan data ke file di filesystem
- ✅ Membaca data dari file
- ✅ Menampilkan content file di UI
- ✅ Handle errors dengan proper error handling
- ✅ Mengintegrasikan dengan filesystem paths dari path_provider

### Pembelajaran Dari Praktikum 1-6

| Praktikum | Focus | Teknologi |
|-----------|-------|-----------|
| 1 | JSON parsing | jsonDecode, factory constructors |
| 2 | Error handling | Type casting, null coalescing |
| 3 | Code quality | Constants, best practices |
| 4 | Data persistence | SharedPreferences |
| 5 | Filesystem access | path_provider, dart:io |
| 6 | File operations | File read/write, dart:io |

Kombinasi keenam praktikum ini mengajarkan:
- **Backend Communication**: Load data dari JSON
- **Data Validation**: Handle inconsistent data
- **Code Quality**: Write maintainable code
- **Local Storage**: Persist data locally
- **Filesystem**: Access system directories
- **File Operations**: Read and write files

Ini adalah foundation untuk membangun production-ready Flutter applications!

````