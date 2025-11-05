# **Laporan Praktikum Codelabs #10**

**Identitas Mahasiswa:**

| Nama | Kelas | Absen |
|------|-------|-----|
| Faishal Harist Rahmawan | TI-3H | 10 |

## Praktikum 1
Output:

![praktikum1](img/p1.png)

## Tugas Praktikum 1
2. Jelaskan maksud dari langkah 4 pada praktikum tersebut! Mengapa dilakukan demikian?

**Jawab:**

Langkah 4 membuat file data_layer.dart yang berfungsi sebagai barrel file (file penampung export). File ini mengumpulkan semua export dari model-model data (plan.dart dan task.dart) dalam satu tempat.

*Alasan dilakukan:*
- Menyederhanakan import: Daripada import setiap file model satu per satu di banyak tempat, kita cukup import data_layer.dart saja.

- Maintainability: Jika nanti ada model baru, kita tinggal tambahkan export di file ini tanpa mengubah semua file yang - menggunakan model tersebut.

Contoh perbandingan:

```dart
// Tanpa data_layer.dart
import 'package:master_plan/models/plan.dart';
import 'package:master_plan/models/task.dart';

// Dengan data_layer.dart
import 'package:master_plan/models/data_layer.dart';

```

Jadi, barrel file ini seperti penghubung yang memudahkan akses ke semua model data dalam satu import.

3. Mengapa perlu variabel plan di langkah 6 pada praktikum tersebut? Mengapa dibuat konstanta ?

**Jawab:**

Variabel `plan` diperlukan sebagai **state** untuk menyimpan data rencana (plan) yang akan ditampilkan dan dikelola di `PlanScreen`. 

**Alasan perlu variabel plan:**
- **Menyimpan data**: Variabel ini menampung object Plan yang berisi list of tasks yang akan ditampilkan di UI
- **State management**: Karena `PlanScreen` adalah StatefulWidget, variabel plan ini adalah bagian dari state yang bisa berubah (misalnya saat user menambah/menghapus task)
- **Single source of truth**: Semua widget di dalam PlanScreen mengacu ke variabel plan yang sama, jadi datanya konsisten

**Mengapa dibuat konstanta (`const Plan()`):**
- **Nilai awal**: `const` di sini hanya untuk **inisialisasi awal** dengan Plan kosong (default constructor)
- **Bukan konstanta permanen**: Meskipun diinisialisasi dengan `const`, variabel `plan` sendiri **TIDAK** `final`, jadi nilainya masih bisa diubah nanti dengan `setState()`
- **Performance**: Menggunakan `const` untuk object yang immutable di awal bisa sedikit menghemat memori

**Contoh penggunaan nanti:**
```dart
// Variabel plan bisa diubah nilainya
setState(() {
  plan = Plan(name: 'New Plan', tasks: [...]);
});
```

Jadi, `const Plan()` hanya nilai awal sementara, bukan membuat variabel plan jadi konstanta permanen.

5. Apa kegunaan method pada Langkah 11 dan 13 dalam lifecyle state ?

**Jawab:**

**Langkah 11 - Method `initState()`:**

Method `initState()` adalah lifecycle method yang **dipanggil sekali** saat widget pertama kali dibuat (initialized).

**Kegunaan di praktikum:**
- **Inisialisasi ScrollController**: Membuat instance ScrollController yang akan mengontrol scrolling behavior
- **Menambahkan Listener**: `addListener()` untuk mendengarkan event scroll
- **Auto-dismiss keyboard**: Setiap kali user scroll, keyboard otomatis tertutup dengan `FocusScope.of(context).requestFocus(FocusNode())`
- **Timing yang tepat**: `initState()` dipanggil sebelum `build()`, jadi controller sudah siap saat UI di-render

**Urutan eksekusi:**
```
initState() → build() → Widget ditampilkan
```

---

**Langkah 13 - Method `dispose()`:**

Method `dispose()` adalah lifecycle method yang **dipanggil sekali** saat widget akan dihapus/dibuang dari widget tree.

**Kegunaan di praktikum:**
- **Cleanup resource**: Membebaskan memori yang digunakan oleh ScrollController
- **Mencegah memory leak**: Jika tidak di-dispose, ScrollController akan tetap ada di memori meskipun widget sudah tidak dipakai
- **Best practice**: Semua controller (ScrollController, TextEditingController, dll) harus di-dispose untuk menghindari memory leak
- **Memanggil super.dispose()**: Memastikan parent class juga melakukan cleanup

**Urutan eksekusi:**
```
Widget dihapus → dispose() dipanggil → Resource dibersihkan
```