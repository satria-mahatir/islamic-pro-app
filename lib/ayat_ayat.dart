import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail_surah.dart';

class Hal1 extends StatefulWidget {
  const Hal1({super.key});

  @override
  State<Hal1> createState() => _Hal1State();
}

class _Hal1State extends State<Hal1> {
  final Color warnaUtama = const Color(0xFF004D40);
  final Color warnaGradasi = const Color(0xFF00796B);
  final Color warnaBg = const Color(0xFFF2F7F6);

  List<dynamic> daftarSurahFull = []; // Penampung data asli dari API
  List<dynamic> daftarSurahDisplay = []; // Data yang tampil (buat pencarian)
  bool isLoading = true;
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSurah(); // Ambil data pas pertama buka
  }

  // Fungsi ambil data dari API equran.id
  Future<void> fetchSurah() async {
    try {
      final response = await http.get(Uri.parse('https://equran.id/api/v2/surat'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          daftarSurahFull = data['data'];
          daftarSurahDisplay = daftarSurahFull;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error brok: $e");
      setState(() => isLoading = false);
    }
  }

  void filterSurah(String query) {
    setState(() {
      daftarSurahDisplay = daftarSurahFull
          .where((surah) =>
              surah['namaLatin'].toLowerCase().contains(query.toLowerCase()) ||
              surah['arti'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: warnaBg,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: warnaUtama,
        centerTitle: true,
        title: !isSearching
            ? const Text("Al-Qur'an 30 Juz",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1))
            : TextField(
                controller: searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Cari Surah (misal: Al-Fatihah)...",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: filterSurah,
              ),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                  daftarSurahDisplay = daftarSurahFull;
                }
              });
            },
            icon: Icon(isSearching ? Icons.close : Icons.search_rounded),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: warnaUtama))
          : daftarSurahDisplay.isEmpty
              ? const Center(child: Text("Gak ketemu brok.", style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  itemCount: daftarSurahDisplay.length,
                  itemBuilder: (context, index) {
                    final surah = daftarSurahDisplay[index];
                    
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ListTile(
                        onTap: () {
                          // Karena API detail butuh nomor surah, kita lempar nomornya
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailSurah(
                                nomorSurah: surah['nomor'],
                                namaSurah: surah['namaLatin'],
                              ),
                            ),
                          );
                        },
                        contentPadding: const EdgeInsets.all(15),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [warnaUtama, warnaGradasi],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              "${surah['nomor']}",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              surah['namaLatin'],
                              style: TextStyle(fontWeight: FontWeight.w800, color: warnaUtama, fontSize: 17),
                            ),
                            Text(
                              surah['nama'], // Teks Arab surah
                              style: TextStyle(fontWeight: FontWeight.bold, color: warnaUtama, fontSize: 18),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "${surah['arti']} • ${surah['jumlahAyat']} Ayat",
                            style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500, fontSize: 13),
                          ),
                        ),
                        trailing: Icon(Icons.chevron_right_rounded, color: warnaUtama.withOpacity(0.3)),
                      ),
                    );
                  },
                ),
    );
  }
}