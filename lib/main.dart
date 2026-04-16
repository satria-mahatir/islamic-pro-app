import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_dashboard.dart'; // Manggil file UI lo dari sini

void main() {
  // Wajib dipanggil sebelum akses fitur sistem
  WidgetsFlutterBinding.ensureInitialized();

  // KUNCI LAYAR: Biar gak ngerusak layout Bento Grid pas HP dimiringin
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // STATUS BAR: Transparan ala iOS agar menyatu dengan Header Dashboard
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi Warna Tema agar Konsisten di semua halaman
    const Color warnaUtama = Color(0xFF004D40);
    const Color warnaBg = Color(0xFFFBFDFB);

    return MaterialApp(
      title: 'Islamic Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'sans-serif',
        colorScheme: ColorScheme.fromSeed(
          seedColor: warnaUtama,
          primary: warnaUtama,
          surface: warnaBg,
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          color: Colors.white,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: warnaUtama,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
      // Halaman pertama yang dibuka: Dashboard
      home: const HomeDashboard(),
    );
  }
}