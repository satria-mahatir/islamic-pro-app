import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TasbihPage extends StatefulWidget {
  const TasbihPage({super.key});

  @override
  State<TasbihPage> createState() => _TasbihPageState();
}

class _TasbihPageState extends State<TasbihPage> {
  int _counter = 0;
  final int _target = 33;
  
  // Palet warna biar seragam sama project utama
  final Color warnaUtama = const Color(0xFF004D40);
  final Color warnaBg = const Color(0xFFF2F7F6);

  // Daftar lafadz otomatis
  String get _currentDzikir {
    if (_counter < 33) return "Subhanallah";
    if (_counter < 66) return "Alhamdulillah";
    if (_counter < 99) return "Allahu Akbar";
    return "La ilaha illallah";
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    // Efek getar medium biar kerasa klik-nya
    HapticFeedback.mediumImpact(); 
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
    HapticFeedback.heavyImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: warnaBg,
      appBar: AppBar(
        title: const Text("Tasbih Digital", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
        backgroundColor: warnaUtama,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Indikator Dzikir Saat Ini
            Text(
              _currentDzikir,
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.w800, 
                color: warnaUtama.withOpacity(0.7)
              ),
            ),
            const SizedBox(height: 40),

            // Progress Ring Tasbih
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 280,
                  height: 280,
                  child: CircularProgressIndicator(
                    value: (_counter % _target) / _target,
                    strokeWidth: 12,
                    strokeCap: StrokeCap.round, // Biar ujungnya bulet estetik
                    backgroundColor: warnaUtama.withOpacity(0.05),
                    color: warnaUtama,
                  ),
                ),
                GestureDetector(
                  onTap: _incrementCounter,
                  child: Container(
                    width: 230,
                    height: 230,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: warnaUtama.withOpacity(0.1),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        )
                      ],
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 100),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return ScaleTransition(scale: animation, child: child);
                        },
                        child: Text(
                          "$_counter",
                          key: ValueKey<int>(_counter),
                          style: TextStyle(
                            fontSize: 70, 
                            fontWeight: FontWeight.w900, 
                            color: warnaUtama,
                            letterSpacing: -2
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 60),
            
            // Tombol Reset Minimalis
            InkWell(
              onTap: _resetCounter,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh_rounded, color: Colors.redAccent, size: 20),
                    SizedBox(width: 10),
                    Text("Reset Tasbih", 
                      style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
            Text(
              "Total Putaran: ${(_counter / _target).floor()}", 
              style: TextStyle(
                color: Colors.grey.shade500, 
                fontWeight: FontWeight.w600,
                fontSize: 14
              )
            ),
          ],
        ),
      ),
    );
  }
}