import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DoaPage extends StatefulWidget {
  const DoaPage({super.key});

  @override
  State<DoaPage> createState() => _DoaPageState();
}

class _DoaPageState extends State<DoaPage> {
  final Color warnaUtama = const Color(0xFF004D40);
  final Color warnaBg = const Color(0xFFF2F7F6);

  Future<List<dynamic>> getDoa() async {
    try {
      final response = await http
          .get(Uri.parse('https://open-api.my.id/api/doa'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Server error brok');
      }
    } catch (e) {
      throw Exception('Gagal konek: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: warnaBg,
      appBar: AppBar(
        title: const Text(
          "Doa-Doa Harian",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        backgroundColor: warnaUtama,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getDoa(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: warnaUtama));
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Koneksi bermasalah brok!"));
          }

          final listDoa = snapshot.data!;

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: listDoa.length,
            itemBuilder: (context, index) {
              final doa = listDoa[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ExpansionTile(
                  shape: const Border(),
                  leading: CircleAvatar(
                    backgroundColor: warnaUtama.withOpacity(0.1),
                    child: Text(
                      "${index + 1}",
                      style: TextStyle(color: warnaUtama, fontSize: 12),
                    ),
                  ),
                  // SINKRONISASI API: Pake 'judul' bukan 'doa'
                  title: Text(
                    doa['judul'] ?? "Tanpa Judul",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // SINKRONISASI API: Pake 'arab' bukan 'ayat'
                          Text(
                            doa['arab'] ?? "",
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              height: 2,
                            ),
                          ),
                          const SizedBox(height: 15),
                          // SINKRONISASI API: Pake 'latin' (bila ada) atau kosongin
                          Text(
                            "Latin: ${doa['latin'] ?? '-'}",
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              // SINKRONISASI API: Pake 'terjemah' bukan 'artinya'
                              "Artinya: ${doa['terjemah'] ?? 'Tidak ada terjemahan'}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
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