import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  // Langkah 2: Tambah variabel Future
  late Future<Position> _positionFuture;

  // Langkah 1: Modifikasi method getPosition()
  Future<Position> getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, cannot request.');
    }

    // Tambahkan delay biar animasi loading kelihatan
    await Future.delayed(const Duration(seconds: 3));

    // Dapatkan posisi sekarang
    return await Geolocator.getCurrentPosition();
  }

  // Langkah 3: Tambah initState()
  @override
  void initState() {
    super.initState();
    _positionFuture = getPosition();
  }

  // Langkah 4 & 5: Gunakan FutureBuilder
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FutureBuilder Location - Harist"),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<Position>(
          future: _positionFuture,
          builder: (context, snapshot) {
            // loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Mendapatkan lokasi..."),
                ],
              );
            }

            // Langkah 5: handling error
            else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text(
                  "Something terrible happened!\n${snapshot.error}",
                  textAlign: TextAlign.center,
                );
              }

              // kalau berhasil
              if (snapshot.hasData) {
                final pos = snapshot.data!;
                return Text(
                  "Lokasi Anda:\nLat: ${pos.latitude}, Lon: ${pos.longitude}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                );
              }
            }

            // fallback
            return const Text("Tidak ada data lokasi.");
          },
        ),
      ),
    );
  }
}
