import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PrayerService {
  Future<Map<String, dynamic>> getPrayerTimes() async {
    try {
      // Cek izin dulu biar gak error di awal
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return await fetchTimes(-7.9135, 113.8217); // Default Bondowoso
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 3), // Percepat biar gak kelamaan nunggu GPS
      );
      return await fetchTimes(position.latitude, position.longitude);
    } catch (e) {
      // Kalau GPS mati/error, langsung kasih jadwal Bondowoso
      return await fetchTimes(-7.9135, 113.8217); 
    }
  }

  Future<Map<String, dynamic>> fetchTimes(double lat, double lng) async {
    try {
      final res = await http.get(
        Uri.parse('https://api.aladhan.com/v1/timings?latitude=$lat&longitude=$lng&method=11')
      ).timeout(const Duration(seconds: 5)); // Maksimal nunggu internet 5 detik

      if (res.statusCode == 200) {
        return json.decode(res.body)['data']['timings'];
      }
      throw Exception("Gagal ambil data");
    } catch (e) {
      // Return data kosong biar FutureBuilder gak error
      return {};
    }
  }
}