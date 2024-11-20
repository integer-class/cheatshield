import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Mengambil daftar kamera yang tersedia
    _cameras = await availableCameras();

    // Menemukan kamera depan (biasanya ada di index 1, bisa bervariasi tergantung perangkat)
    CameraDescription frontCamera = _cameras!.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () =>
          _cameras!.first, // Jika tidak ditemukan, pilih kamera pertama
    );

    // Memulai kamera depan
    await _startCamera(frontCamera);
  }

  Future<void> _startCamera(CameraDescription camera) async {
    _cameraController?.dispose(); // Menonaktifkan kamera sebelumnya jika ada
    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
    );

    await _cameraController!.initialize();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Menerapkan transformasi untuk efek mirror pada kamera depan
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Verification'),
      ),
      body: Stack(
        children: [
          // Kamera dengan efek mirror (rotation Y)
          Transform(
            alignment: Alignment.center,
            transform:
                Matrix4.rotationY(pi), // Membalikkan kamera secara horizontal
            child: CameraPreview(_cameraController!),
          ),

          // Tombol Capture berbentuk lingkaran putih
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  // Simulasikan validasi wajah berhasil
                  Navigator.of(context).pop(true);
                },
                child: Container(
                  width: 70, // Lebar tombol
                  height: 70, // Tinggi tombol
                  decoration: BoxDecoration(
                    color: Colors.white, // Warna latar belakang tombol
                    shape: BoxShape.circle, // Bentuk tombol bulat
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons
                        .camera_alt, // Ikon kamera (bisa diubah sesuai kebutuhan)
                    color: Colors.black, // Warna ikon
                    size: 40, // Ukuran ikon
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
