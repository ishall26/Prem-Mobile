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

