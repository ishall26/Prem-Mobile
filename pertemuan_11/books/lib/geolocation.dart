import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Position? _currentPosition;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    setState(() {
      _isLoading = true;
    });

    // 🔹 Soal 12: Tambahkan delay agar loading terlihat
    await Future.delayed(const Duration(seconds: 3));

    bool serviceEnabled;
    LocationPermission permission;

    // Cek apakah GPS aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLoading = false;
      });
      return Future.error('Layanan lokasi tidak aktif.');
    }

    // Cek izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _isLoading = false;
        });
        return Future.error('Izin lokasi ditolak.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _isLoading = false;
      });
      return Future.error(
          'Izin lokasi ditolak permanen, ubah di pengaturan.');
    }

    // Dapatkan posisi saat ini
    final position = await Geolocator.getCurrentPosition();

    setState(() {
      _currentPosition = position;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasi GPS - Harist'), // 🧑 Soal 11
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator() // animasi loading
            : _currentPosition != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Latitude: ${_currentPosition!.latitude}'),
                      Text('Longitude: ${_currentPosition!.longitude}'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _determinePosition,
                        child: const Text('Refresh Lokasi'),
                      ),
                    ],
                  )
                : const Text('Tekan tombol untuk mendapatkan lokasi'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _determinePosition,
        child: const Icon(Icons.location_on),
      ),
    );
  }
}