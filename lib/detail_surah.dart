import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailSurah extends StatefulWidget {
  final int nomorSurah; // Sekarang kita pake nomor surah buat nyari ke API
  final String namaSurah;

  const DetailSurah({
    super.key,
    required this.nomorSurah,
    required this.namaSurah,
  });

  @override
  State<DetailSurah> createState() => _DetailSurahState();
}

class _DetailSurahState extends State<DetailSurah> {
  final Color warnaUtama = const Color(0xFF004D40);
  final Color warnaBg = const Color(0xFFF2F7F6);

  // Fungsi untuk ambil data detail ayat berdasarkan nomor surah
  Future<Map<String, dynamic>> getDetailSurah() async {
    final response = await http.get(
      Uri.parse('https://equran.id/api/v2/surat/${widget.nomorSurah}')
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Gagal ambil data ayat brok!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: warnaBg,
      appBar: AppBar(
        title: Text(
          widget.namaSurah,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        backgroundColor: warnaUtama,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getDetailSurah(),
        builder: (context, snapshot) {
          // 1. Kalo lagi nunggu data (Loading)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: warnaUtama),
            );
          }
          
          // 2. Kalo ada error (Gak ada internet, dll)
          if (snapshot.hasError) {
            return const Center(
              child: Text("Koneksi bermasalah atau API down brok!"),
            );
          }

          // 3. Kalo data berhasil dapet
          final dataSurah = snapshot.data!;
          final List ayatList = dataSurah['ayat'];

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: ayatList.length,
            itemBuilder: (context, index) {
              final ayat = ayatList[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Nomor Ayat ala iOS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: warnaUtama.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Ayat ${ayat['nomorAyat']}",
                            style: TextStyle(
                              color: warnaUtama,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Icon(Icons.share_outlined, size: 18, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 25),
                    // Teks Arab dari API
                    Text(
                      ayat['teksArab'],
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 2.2,
                        color: Color(0xFF2D3436),
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 20),
                    // Terjemahan dari API
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        ayat['teksIndonesia'],
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade700,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}