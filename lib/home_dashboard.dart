import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

import 'ayat_ayat.dart';
import 'kiblat_page.dart';
import 'tasbih_page.dart';
import 'kalender_page.dart';
import 'doa_page.dart';
import 'prayer_service.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  late String _timeString;
  late Timer _timer;
  late Future<Map<String, dynamic>> _prayerFuture;

  // iOS 2026 Clean Palette
  final Color warnaUtama = const Color(0xFF004D40);
  final Color warnaGradasi = const Color(0xFF00695C);
  final Color warnaBg = const Color(0xFFF8FAF9);
  final Color aksenKuning = const Color(0xFFFFD54F);

  @override
  void initState() {
    super.initState();
    _timeString = DateFormat('HH:mm').format(DateTime.now());
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => _updateTime(),
    );
    _prayerFuture = PrayerService().getPrayerTimes();
    _checkLocationPermission();
  }

  Future<void> _openMasjidMap() async {
    final Uri url = Uri.parse(
      "https://www.google.com/maps/search/masjid+terdekat",
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal membuka Maps brok!")),
        );
      }
    }
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    setState(() {
      _timeString = DateFormat('HH:mm').format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: warnaBg,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildModernHeader(context),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPrayerCard(),
                          const SizedBox(height: 12),
                          _buildBentoGrid(context),
                          const SizedBox(height: 32),
                          _buildSectionHeader("Inspirasi Islami"),
                          const SizedBox(height: 16),
                          _buildModernArticleList(),
                          const SizedBox(height: 140),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildFloatingGlassNav(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 380,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [warnaUtama, warnaGradasi],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildLocationPill(),
            const Spacer(),
            Text(
              _timeString,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.22,
                fontWeight: FontWeight.w900,
                letterSpacing: -6,
              ),
            ),
            Text(
              "10 Rajab 1447 H",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Column(
                children: [
                  Text(
                    "INDONESIA NEGARA HUKUM",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 11,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text(
                    "Assalamualaikum, Tama",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.near_me_rounded, color: aksenKuning, size: 16),
          const SizedBox(width: 8),
          const Text(
            "Bondowoso, Jatim", //
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerCard() {
    return Transform.translate(
      offset: const Offset(0, -50),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: warnaUtama.withValues(alpha: 0.08),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _prayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LinearProgressIndicator());
            }
            final times = snapshot.data ?? {};
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _miniTime("Subuh", times['Fajr'] ?? "--:--"),
                _miniTime("Dzuhur", times['Dhuhr'] ?? "--:--"),
                _miniTime("Ashar", times['Asr'] ?? "--:--"),
                _miniTime("Maghrib", times['Maghrib'] ?? "--:--"),
                _miniTime("Isya", times['Isha'] ?? "--:--"),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _miniTime(String label, String time) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          time,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: warnaUtama,
          ),
        ),
      ],
    );
  }

  // BENTO GRID FINAL: Fixed Height & Asymmetric Layout
  Widget _buildBentoGrid(BuildContext context) {
    const double gap = 14.0;

    return Column(
      children: [
        // --- BARIS ATAS (QURAN, KIBLAT, TASBIH) ---
        SizedBox(
          height: 240, // Tinggi dikunci biar gak overflow/menciut
          child: Row(
            children: [
              // KOTAK KIRI (QURAN) - Flex 2 biar mendominasi
              Expanded(
                flex: 2,
                child: _buildBentoBox(
                  context,
                  'Quran',
                  Icons.auto_stories,
                  Colors.teal,
                  isLarge: true,
                ),
              ),
              const SizedBox(width: gap),
              // KOTAK KANAN (KIBLAT & TASBIH) - Flex 1
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Expanded(
                      child: _buildBentoBox(
                        context,
                        'Kiblat',
                        Icons.explore_rounded,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(height: gap),
                    Expanded(
                      child: _buildBentoBox(
                        context,
                        'Tasbih',
                        Icons.radio_button_checked,
                        Colors.cyan,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: gap),

        // --- BARIS BAWAH (DOA, KALENDER, MASJID) ---
        SizedBox(
          height: 110, // Tinggi dikunci
          child: Row(
            children: [
              Expanded(
                child: _buildBentoBox(
                  context,
                  'Doa',
                  Icons.front_hand_rounded,
                  Colors.indigo,
                ),
              ),
              const SizedBox(width: gap),
              Expanded(
                child: _buildBentoBox(
                  context,
                  'Kalender',
                  Icons.event_note_rounded,
                  Colors.brown,
                ),
              ),
              const SizedBox(width: gap),
              Expanded(
                child: _buildBentoBox(
                  context,
                  'Masjid',
                  Icons.mosque_rounded,
                  Colors.green,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // FUNGSI KOTAK FINAL
  Widget _buildBentoBox(
    BuildContext context,
    String title,
    IconData icon,
    Color color, {
    bool isLarge = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (title == 'Quran') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Hal1()),
          );
        }
        if (title == 'Doa') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DoaPage()),
          );
        }
        if (title == 'Tasbih') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TasbihPage()),
          );
        }
        if (title == 'Kalender') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const KalenderPage()),
          );
        }
        if (title == 'Masjid') _openMasjidMap();
      },
      child: Container(
        // double.infinity memaksa kotak merentang penuh sesuai alokasi dari Expanded
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(35),
          border: Border.all(color: color.withValues(alpha: 0.05)),
        ),
        child: isLarge
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: color, size: 45), // Icon Quran agak besar
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      color: color.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: color, size: 30),
                  const SizedBox(height: 10),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: color.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildModernArticleList() {
    final List<Map<String, String>> inspirasiData = [
      {
        "judul": "Keutamaan Tahajud",
        "tag": "TIPS",
        "img":
            "https://images.unsplash.com/photo-1542810634-71277d95dcbb?q=80&w=500",
      },
      {
        "judul": "Sedekah Subuh",
        "tag": "AMALAN",
        "img":
            "https://images.unsplash.com/photo-1594498653385-d5172c532c00?q=80&w=500",
      },
      {
        "judul": "Adab Menuntut Ilmu",
        "tag": "ADAB",
        "img":
            "https://images.unsplash.com/photo-1509062522246-3755977927d7?q=80&w=500",
      },
    ];

    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: inspirasiData.length,
        itemBuilder: (context, index) {
          final item = inspirasiData[index];
          return Container(
            width: 300,
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              image: DecorationImage(
                image: NetworkImage(item['img']!),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.85),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: aksenKuning,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      item['tag']!,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: warnaUtama,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item['judul']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingGlassNav(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(45),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              height: 85,
              width: double.infinity,
              decoration: BoxDecoration(
                color: warnaUtama.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(45),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navIcon(Icons.grid_view_rounded, true),
                  _navIcon(
                    Icons.auto_stories,
                    false,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Hal1()),
                    ),
                  ),
                  _navIcon(
                    Icons.explore_rounded,
                    false,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KiblatPage(),
                      ),
                    ),
                  ),
                  _navIcon(Icons.person_3_rounded, false),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navIcon(IconData icon, bool isActive, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isActive ? aksenKuning : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isActive ? warnaUtama : Colors.white.withValues(alpha: 0.4),
          size: 28,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: warnaUtama,
          ),
        ),
        Text(
          "Lihat Semua",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: warnaGradasi,
          ),
        ),
      ],
    );
  }
}
