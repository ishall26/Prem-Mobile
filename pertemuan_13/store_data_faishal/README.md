# Store Data Faishal - Pizza Store App

Aplikasi Flutter untuk menampilkan daftar pizza dengan penanganan data JSON yang robust.

## 📚 Praktikum

### Praktikum 1: Load dan Parse JSON
- ✅ Membaca file JSON dari assets
- ✅ Membuat model data Pizza
- ✅ Parse JSON menjadi object Dart
- ✅ Menampilkan data di ListView

### Praktikum 2: Handle Kompatibilitas Data JSON
- ✅ Type casting untuk konversi tipe data (String/Int, String/Double)
- ✅ Null coalescing operator (??) untuk default values
- ✅ Error handling dengan try-catch
- ✅ Ternary operator untuk user-friendly UI

### Praktikum 3: Menangani Error JSON
- ✅ Menggunakan konstanta untuk JSON keys
- ✅ Menghindari typo pada nama kunci
- ✅ Meningkatkan code safety dan maintainability

### Praktikum 4: SharedPreferences
- ✅ Menyimpan data sederhana ke local device
- ✅ Membaca data yang sudah disimpan
- ✅ Menampilkan counter app opens
- ✅ Tombol reset untuk menghapus data

### Praktikum 5: path_provider & Filesystem Access
- ✅ Mengakses documents directory
- ✅ Mengakses temporary directory
- ✅ Menampilkan jalur absolut filesystem
- ✅ Cross-platform file access yang aman

### Praktikum 4: SharedPreferences
- ✅ Menyimpan data sederhana (counter) ke local storage
- ✅ Membaca data dari storage dengan null coalescing
- ✅ Menghapus semua data dengan clear()
- ✅ Integrasi dengan JSON loading dari praktikum sebelumnya

---

## 📋 Soal 6: SharedPreferences Implementation

### Fitur yang Ditambahkan

**1. App Open Counter**
```dart
int appCounter = 0;  // Variable untuk menyimpan counter

Future<void> readAndWritePreference() async {
  final prefs = await SharedPreferences.getInstance();
  final counter = prefs.getInt(keyAppCounter) ?? 0;
  final newCounter = counter + 1;
  await prefs.setInt(keyAppCounter, newCounter);
  setState(() {
    appCounter = newCounter;
  });
}
```

Counter ini:
- Increment setiap kali app dibuka
- Disimpan di local storage
- Ditampilkan dengan format: "You have opened the app X times"

**2. Reset Counter Button**
```dart
Future<void> deletePreference() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  setState(() {
    appCounter = 0;
  });
}
```

Tombol "Reset Counter" yang:
- Menghapus semua data dari storage
- Reset counter ke 0
- Mengupdate UI secara real-time

### UI Components

**Counter Display Section**
- Light blue background container
- Menampilkan judul "App Open Counter"
- Menampilkan pesan counter
- Red "Reset Counter" button dengan refresh icon

**Pizza List Section**
- Title "Daftar Pizza"
- Scrollable list dengan pizza cards
- Setiap card menampilkan:
  - Pizza icon (orange)
  - Pizza name (bold)
  - Description (2 lines max, truncated)
  - Price (green, bold)
  - ID (blue, small)

### How It Works

1. **On App Start**
   - `initState()` dipanggil
   - `readAndWritePreference()` dibaca dari storage
   - Counter di-increment dan disimpan
   - UI diupdate dengan counter baru

2. **On App Close & Reopen**
   - Counter yang disimpan dibaca kembali
   - Counter di-increment lagi
   - Nilai counter bertambah setiap kali app dibuka

3. **On Reset Button Click**
   - `deletePreference()` menghapus semua data
   - Counter di-set ke 0
   - UI diupdate



### Safe (Aman)

**1. Compile-Time Error Detection**
```dart
// ❌ String literal - error terdeteksi saat runtime
json['pizzaNam']  // Typo, tidak terdeteksi sampai runtime

// ✅ Konstanta - error terdeteksi saat compile-time
json[keyPizzaNam]  // ERROR! Konstanta tidak ada
```

Dengan menggunakan konstanta, compiler dapat mendeteksi kesalahan pada tahap compile-time, bukan saat aplikasi berjalan. Jika ada typo pada nama konstanta, IDE akan langsung menunjukkan error.

**2. Refactoring Aman**
```dart
// ❌ String literal - perlu update manual di banyak tempat
// Risk: lupa update di salah satu tempat
json['pizzaName']  // File 1
json['pizzaName']  // File 2
json['pizzaName']  // File 3

// ✅ Konstanta - update hanya di satu tempat
const String keyPizzaName = 'pizzaName';  // Update sini saja!
```

Jika struktur JSON berubah, cukup update konstanta di satu tempat. IDE dapat membantu melakukan refactoring otomatis di semua file yang menggunakan konstanta tersebut.

**3. Typo Protection**
```dart
// ❌ String literal - mudah typo
json['pizzzaName']  // Lupa satu huruf 'a'
json['PIZZANAME']   // Salah case
json['pizz_name']   // Salah format

// ✅ Konstanta - IDE auto-complete
json[keyPizzaName]  // IDE melengkapi otomatis, tidak bisa typo
```

IDE memberikan auto-complete untuk konstanta, sehingga developer tidak perlu mengetik manual dan mengurangi risiko typo.

### Maintainable (Mudah Dirawat)

**1. Centralized Definition**
```dart
// Semua kunci JSON terdefinisi di satu tempat - mudah di-audit
const String keyId = 'id';
const String keyPizzaName = 'pizzaName';
const String keyDescription = 'description';
const String keyPrice = 'price';
const String keyImageUrl = 'imageUrl';
```

Developer dapat dengan cepat melihat semua field yang digunakan dalam model, tanpa perlu mencari-cari di seluruh file.

**2. Self-Documenting Code**
```dart
// ✅ Dengan konstanta - jelas bahwa ini mengakses JSON
pizzaName: json[keyPizzaName]?.toString() ?? 'No Name',

// ❌ Tanpa konstanta - kurang jelas
pizzaName: json['pizzaName']?.toString() ?? 'No Name',
```

Konstanta membuat code lebih ekspresif dan self-explanatory. Developer baru dapat langsung memahami struktur model.

**3. Easy Search & Replace**
```dart
// Dengan konstanta, developer dapat:
// 1. Search: Cari semua penggunaan keyPizzaName
// 2. Jump to definition: Lihat konstanta didefinisikan di mana
// 3. Refactor: Ubah semua referensi sekaligus
// 4. Understand: Clear dependencies antara class
```

IDE memberikan support yang lebih baik untuk navigasi dan refactoring dengan konstanta dibanding string literal.

**4. Consistency Across Multiple Files**
Jika ada banyak file yang menggunakan model Pizza (API service, database helper, UI components), semua file akan menggunakan kunci yang sama dan konsisten.

---

## 🏗️ Arsitektur

```
lib/
├── main.dart                 # Main app & UI
└── model/
    └── pizza.dart           # Pizza model dengan konstanta JSON keys

assets/
├── pizzalist.json           # Data normal
└── pizzalist_broken.json    # Data untuk testing error handling
```

---

## 📋 Soal 7: Jelaskan path_provider

### Apa itu path_provider?

`path_provider` adalah Flutter package yang menyediakan akses ke direktori sistem file yang umum digunakan aplikasi, dengan cara yang konsisten di semua platform (Android, iOS, Windows, Linux, macOS).

### Mengapa path_provider Penting?

**1. Cross-Platform Compatibility**

Path untuk menyimpan dokumen berbeda di setiap platform:
- **Android**: `/data/user/0/package.name/...`
- **iOS**: `/var/mobile/Containers/Data/Application/.../Documents`
- **Windows**: `C:\Users\Username\AppData\Local\...`
- **Linux**: `/home/username/.local/share/...`

Tanpa path_provider, Anda harus menulis hardcoded paths untuk setiap platform. path_provider handle semua ini secara otomatis!

**2. Platform-Specific Best Practices**

```dart
// Documents Directory: Untuk data yang disimpan permanen
final documentsDir = await getApplicationDocumentsDirectory();

// Temporary Directory: Untuk cache/temporary files
final tempDir = await getTemporaryDirectory();

// External Storage: Untuk akses file dari outside app
final externalDir = await getExternalStorageDirectory();
```

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

### Kesimpulan

path_provider adalah essential untuk:
- ✅ Cross-platform file access
- ✅ Security dan isolation
- ✅ Best practices pada setiap platform
- ✅ Professional app structure

### 1. `lib/model/pizza.dart`
Menggunakan konstanta untuk JSON keys untuk meningkatkan safety dan maintainability.

### 2. `lib/main.dart`
Implementasi error handling dengan try-catch dan ternary operator untuk user-friendly UI.

---

## 🚀 Cara Menjalankan

```bash
flutter pub get
flutter run
```

---

## 📚 Learning Points

1. **Praktikum 1**: Dasar JSON handling di Flutter
2. **Praktikum 2**: Robust error handling dan null safety
3. **Praktikum 3**: Best practices dengan konstanta dan code quality

Ketiga praktikum ini mengajarkan dari fundamental hingga production-ready code practices.

---

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
