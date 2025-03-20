import 'package:flutter/material.dart';
import 'DetaySayfa.dart';
import 'Filmler.dart';

class FilmlerSayfa extends StatefulWidget {
  final String kategoriAdi;

  const FilmlerSayfa({Key? key, required this.kategoriAdi}) : super(key: key);

  @override
  State<FilmlerSayfa> createState() => _FilmlerSayfaState();
}

class _FilmlerSayfaState extends State<FilmlerSayfa> {
  List<Filmler> tumFilmler = [];
  List<Filmler> filtrelenmisFilmler = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController filmAdiController = TextEditingController();
  TextEditingController filmResimController = TextEditingController();
  TextEditingController filmFiyatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filmleriGetir().then((value) {
      setState(() {
        tumFilmler = value;
        // Kategori adına göre filmleri filtrele
        filtrelenmisFilmler = tumFilmler.where((film) =>
        film.kategori == widget.kategoriAdi
        ).toList();
      });
    });
  }

  void filmAra(String aramaMetni) {
    setState(() {
      if (aramaMetni.isEmpty) {
        filtrelenmisFilmler = tumFilmler.where((film) =>
        film.kategori == widget.kategoriAdi
        ).toList();
      } else {
        filtrelenmisFilmler = tumFilmler
            .where((film) =>
        film.kategori == widget.kategoriAdi &&
            film.film_adi.toLowerCase().contains(aramaMetni.toLowerCase())
        )
            .toList();
      }
    });
  }

  Future<List<Filmler>> filmleriGetir() async {
    var filmlerListesi = <Filmler>[];

    // Bilim Kurgu
    var f1 = Filmler(1, "Inception", "inception.png", 17.99, "Bilim Kurgu");
    var f2 = Filmler(2, "Interstellar", "interstellar.png", 21.99, "Bilim Kurgu");
    var f3 = Filmler(3, "The Prestige", "theprestige.jpg", 22.99, "Bilim Kurgu");

    // Gerilim
    var f4 = Filmler(4, "The Invisible Guest", "theinvisibleguest.jpg", 20.99, "Gerilim");
    var f5 = Filmler(5, "Shutter Island", "shutterisland.jpg", 24.99, "Gerilim");
    var f6 = Filmler(6, "Identity", "identity.jpg", 18.99, "Gerilim");
    var f7 = Filmler(7, "The Hateful Eight", "thehatefuleight.png", 15.99, "Gerilim");

    // Dram
    var f8 = Filmler(8, "The Pianist", "thepianist.png", 17.99, "Dram");
    var f9 = Filmler(9, "Schindler's List", "schindlerslist.jpg", 26.99, "Dram");
    var f10 = Filmler(10, "Forrest Gump", "forrestgump.jpg", 21.99, "Dram");

    // Polisiye
    var f11 = Filmler(11, "Django", "django.png", 19.99, "Polisiye");

    // Savaş
    var f12 = Filmler(12, "Anadoluda", "anadoluda.png", 25.99, "Savaş");

    filmlerListesi.addAll([f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12]);

    return filmlerListesi;
  }

  // Film ekleme işlemi (Create)
  void yeniFilmEkle() {
    // Controller'ları temizle
    filmAdiController.clear();
    filmResimController.clear();
    filmFiyatController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Yeni Film Ekle (${widget.kategoriAdi})"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: filmAdiController,
                  decoration: InputDecoration(
                    labelText: "Film Adı",
                    hintText: "Örn: Avatar",
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: filmResimController,
                  decoration: InputDecoration(
                    labelText: "Resim Adı",
                    hintText: "Örn: avatar.png",
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: filmFiyatController,
                  decoration: InputDecoration(
                    labelText: "Fiyat",
                    hintText: "Örn: 12.99",
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("İptal"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text("Ekle"),
              onPressed: () {
                // Tüm alanların doldurulduğunu kontrol et
                if (filmAdiController.text.isNotEmpty &&
                    filmResimController.text.isNotEmpty &&
                    filmFiyatController.text.isNotEmpty) {

                  try {
                    double fiyat = double.parse(filmFiyatController.text);

                    setState(() {
                      // Son ID'yi bul ve bir artır
                      int yeniId = tumFilmler.isNotEmpty
                          ? tumFilmler.map((f) => f.film_id).reduce((a, b) => a > b ? a : b) + 1
                          : 1;

                      var yeniFilm = Filmler(
                        yeniId,
                        filmAdiController.text,
                        filmResimController.text,
                        fiyat,
                        widget.kategoriAdi, // Kategori adını ekle
                      );

                      tumFilmler.add(yeniFilm);
                      filtrelenmisFilmler = tumFilmler.where((film) =>
                      film.kategori == widget.kategoriAdi
                      ).toList();
                    });

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${filmAdiController.text} başarıyla eklendi"),
                          backgroundColor: Colors.green,
                        )
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Geçerli bir fiyat giriniz"),
                          backgroundColor: Colors.red,
                        )
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Tüm alanları doldurunuz"),
                        backgroundColor: Colors.red,
                      )
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Film düzenleme işlemi (Update)
  void filmDuzenle(Filmler film) {
    // Controller'lara mevcut değerleri ata
    filmAdiController.text = film.film_adi;
    filmResimController.text = film.film_resim_adi;
    filmFiyatController.text = film.film_fiyat.toString();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Film Düzenle"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: filmAdiController,
                  decoration: InputDecoration(labelText: "Film Adı"),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: filmResimController,
                  decoration: InputDecoration(labelText: "Resim Adı"),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: filmFiyatController,
                  decoration: InputDecoration(labelText: "Fiyat"),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("İptal"),
              onPressed: () {
                Navigator.pop(context);
                // Controller'ları temizle
                filmAdiController.clear();
                filmResimController.clear();
                filmFiyatController.clear();
              },
            ),
            ElevatedButton(
              child: Text("Güncelle"),
              onPressed: () {
                // Tüm alanların doldurulduğunu kontrol et
                if (filmAdiController.text.isNotEmpty &&
                    filmResimController.text.isNotEmpty &&
                    filmFiyatController.text.isNotEmpty) {

                  try {
                    double fiyat = double.parse(filmFiyatController.text);

                    setState(() {
                      // Filmin bilgilerini güncelle
                      film.film_adi = filmAdiController.text;
                      film.film_resim_adi = filmResimController.text;
                      film.film_fiyat = fiyat;

                      // Filtre listesini güncelle
                      filtrelenmisFilmler = tumFilmler.where((film) =>
                      film.kategori == widget.kategoriAdi
                      ).toList();
                    });

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${film.film_adi} başarıyla güncellendi"),
                          backgroundColor: Colors.green,
                        )
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Geçerli bir fiyat giriniz"),
                          backgroundColor: Colors.red,
                        )
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Tüm alanları doldurunuz"),
                        backgroundColor: Colors.red,
                      )
                  );
                }

                // Controller'ları temizle
                filmAdiController.clear();
                filmResimController.clear();
                filmFiyatController.clear();
              },
            ),
          ],
        );
      },
    );
  }

  // Film silme işlemi (Delete)
  void filmSil(Filmler film) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Film Sil"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Aşağıdaki filmi silmek istediğinize emin misiniz?"),
              SizedBox(height: 15),
              Row(
                children: [
                  Image.asset(
                    "resimler/${film.film_resim_adi}",
                    height: 50,
                    width: 50,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          film.film_adi,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("${film.film_fiyat} ₺"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("İptal"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Sil", style: TextStyle(color: Colors.white)),
              onPressed: () {
                setState(() {
                  // Filmi listeden kaldır
                  tumFilmler.remove(film);
                  filtrelenmisFilmler = tumFilmler.where((film) =>
                  film.kategori == widget.kategoriAdi
                  ).toList();
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${film.film_adi} başarıyla silindi"),
                      backgroundColor: Colors.green,
                    )
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.kategoriAdi} Filmleri"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Sıralama Seçenekleri"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.sort_by_alpha),
                          title: Text("İsme Göre (A-Z)"),
                          onTap: () {
                            setState(() {
                              filtrelenmisFilmler.sort((a, b) => a.film_adi.compareTo(b.film_adi));
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.sort_by_alpha),
                          title: Text("İsme Göre (Z-A)"),
                          onTap: () {
                            setState(() {
                              filtrelenmisFilmler.sort((a, b) => b.film_adi.compareTo(a.film_adi));
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.attach_money),
                          title: Text("Fiyat (Artan)"),
                          onTap: () {
                            setState(() {
                              filtrelenmisFilmler.sort((a, b) => a.film_fiyat.compareTo(b.film_fiyat));
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.attach_money),
                          title: Text("Fiyat (Azalan)"),
                          onTap: () {
                            setState(() {
                              filtrelenmisFilmler.sort((a, b) => b.film_fiyat.compareTo(a.film_fiyat));
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: yeniFilmEkle,
          ),
        ],
      ),
      body: Column(
        children: [
          // Arama kutusu
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Film Ara",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: filmAra,
            ),
          ),

          // Film listesi
          Expanded(
            child: filtrelenmisFilmler.isEmpty
                ? Center(child: Text("Bu kategoride film bulunamadı"))
                : GridView.builder(
              itemCount: filtrelenmisFilmler.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3.5,
              ),
              itemBuilder: (context, indeks) {
                var film = filtrelenmisFilmler[indeks];
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetaySayfa(film: film),
                          ),
                        );
                      },
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset("resimler/${film.film_resim_adi}"),
                            ),
                            Text(
                              film.film_adi,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "${film.film_fiyat} \u{20BA}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Düzenle ve sil butonları
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Row(
                        children: [
                          // Düzenle butonu
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.edit, color: Colors.white, size: 20),
                              onPressed: () => filmDuzenle(film),
                              constraints: BoxConstraints(),
                              padding: EdgeInsets.all(8),
                            ),
                          ),

                          // Sil butonu
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.white, size: 20),
                              onPressed: () => filmSil(film),
                              constraints: BoxConstraints(),
                              padding: EdgeInsets.all(8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add),
        onPressed: yeniFilmEkle,
        tooltip: 'Yeni Film Ekle',
      ),
    );
  }
}