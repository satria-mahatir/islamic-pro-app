import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';

class KiblatPage extends StatefulWidget {
  const KiblatPage({super.key});

  @override
  State<KiblatPage> createState() => _KiblatPageState();
}

class _KiblatPageState extends State<KiblatPage> {
  Future<bool> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F8),
      appBar: AppBar(
        title: const Text("Arah Kiblat", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF004D40),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: FutureBuilder(
        future: _checkLocationPermission(),
        builder: (context, permissionSnapshot) {
          if (permissionSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF004D40)));
          }

          if (permissionSnapshot.data == false) {
            return _buildPermissionError();
          }

          return StreamBuilder(
            stream: FlutterQiblah.qiblahStream,
            builder: (context, AsyncSnapshot<QiblahDirection> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF004D40)));
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text("Mencari Sinyal GPS/Kompas..."));
              }

              final data = snapshot.data!;
              
              // 1. Normalisasi Derajat (0-359)
              double cleanQiblah = data.qiblah % 360;
              double cleanDirection = data.direction % 360;

              // 2. Hitung Rotasi Relatif untuk Masjid
              // Menggunakan selisih agar masjid selalu menunjuk ke Ka'bah
              double qiblaRotation = (cleanQiblah - cleanDirection) * (pi / 180);

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${cleanQiblah.toStringAsFixed(0)}°", 
                      style: const TextStyle(fontSize: 75, fontWeight: FontWeight.w900, color: Color(0xFF004D40))
                    ),
                    const Text("Kiblat dari Utara Magnetik", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 50),
                    
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 1. Piringan Kompas (N, S, E, W) berputar sesuai HP
                          Transform.rotate(
                            angle: (cleanDirection * (pi / 180) * -1),
                            child: CustomPaint(
                              size: const Size(300, 300),
                              painter: CompassPainter(),
                            ),
                          ),
                          
                          // 2. Icon Masjid berputar menunjuk arah Kiblat
                          // Jarum kuning sudah dihapus sesuai request
                          Transform.rotate(
                            angle: qiblaRotation,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Icon Masjid sebagai penunjuk
                                const Icon(Icons.mosque, color: Color(0xFF004D40), size: 60),
                                // Jarak agar masjid terlihat menunjuk ke arah atas lingkaran
                                const SizedBox(height: 120), 
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                    _buildGuidanceCard(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPermissionError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_off, size: 80, color: Colors.red),
          const SizedBox(height: 10),
          const Text("Izin Lokasi Dibutuhkan!", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF004D40)),
            onPressed: () => Geolocator.openAppSettings(),
            child: const Text("Buka Pengaturan", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _buildGuidanceCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: const Text(
        "Arahkan Masjid ke posisi North (N)", 
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)
      ),
    );
  }
}

class CompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF004D40).withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    canvas.drawCircle(center, radius, paint);

    const textStyle = TextStyle(color: Color(0xFF004D40), fontWeight: FontWeight.bold, fontSize: 22);
    _drawText(canvas, "N", Offset(center.dx, center.dy - radius + 30), textStyle);
    _drawText(canvas, "S", Offset(center.dx, center.dy + radius - 30), textStyle);
    _drawText(canvas, "E", Offset(center.dx + radius - 30, center.dy), textStyle);
    _drawText(canvas, "W", Offset(center.dx - radius + 30, center.dy), textStyle);
  }

  void _drawText(Canvas canvas, String text, Offset offset, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(offset.dx - textPainter.width / 2, offset.dy - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}