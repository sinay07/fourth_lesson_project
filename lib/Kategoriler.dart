import 'package:flutter/material.dart';
import 'Filmler.dart';
import 'FilmlerSayfa.dart';

class Kategoriler extends StatefulWidget {
  const Kategoriler({super.key});

  @override
  State<Kategoriler> createState() => _KategorilerState();
}

class _KategorilerState extends State<Kategoriler> {
  // Kategoriler listesi (Map olarak)
  List<Map<String, dynamic>> tumKategoriler = [
    {"ad": "Bilim Kurgu", "resimAdi": "kategori_bilimkurgu.jpg", "filmSayisi": 3},
    {"ad": "Gerilim", "resimAdi": "kategori_gerilim.jpg", "filmSayisi": 4},
    {"ad": "Dram", "resimAdi": "kategori_dram.jpg", "filmSayisi": 3},
    {"ad": "Komedi", "resimAdi": "kategori_komedi.jpg", "filmSayisi": 0},
    {"ad": "Savaş", "resimAdi": "kategori_savas.jpg", "filmSayisi": 1},
    {"ad": "Polisiye", "resimAdi": "kategori_polisiye.jpg", "filmSayisi": 1}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Film Kategorileri"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: tumKategoriler.length,
        itemBuilder: (context, index) {
          var kategori = tumKategoriler[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(
                kategori["ad"],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "${kategori["filmSayisi"]} Film",
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FilmlerSayfa(kategoriAdi: kategori["ad"]),
                    )
                );
              },
            ),
          );
        },
      ),
    );
  }
}