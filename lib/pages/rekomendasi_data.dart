import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ===== Data Tanaman Lengkap dengan Tips =====
final List<Map<String, dynamic>> dataTanaman = [
  {
    "nama": "Tomat",
    "deskripsi": "Tomat cocok di tanah gembur dengan drainase baik.",
    "tanah": "gembur",
    "suhu_min": 20,
    "suhu_max": 30,
    "kelembaban_min": 60,
    "kelembaban_max": 90,
    "tips":
        "Siram tiap pagi, beri pupuk organik seminggu sekali, dan pastikan terkena sinar matahari minimal 6 jam/hari.",
  },
  {
    "nama": "Cabai",
    "deskripsi": "Cabai tumbuh baik di tanah gembur dan iklim panas.",
    "tanah": "gembur",
    "suhu_min": 24,
    "suhu_max": 32,
    "kelembaban_min": 50,
    "kelembaban_max": 85,
    "tips":
        "Siram secukupnya, gunakan pupuk kandang tiap 2 minggu, dan pangkas daun yang tua.",
  },
  {
    "nama": "Bayam",
    "deskripsi": "Bayam menyukai tanah agak liat yang lembab.",
    "tanah": "liat",
    "suhu_min": 18,
    "suhu_max": 28,
    "kelembaban_min": 60,
    "kelembaban_max": 95,
    "tips":
        "Siram rutin agar tanah tetap lembab, panen daun muda untuk hasil optimal.",
  },
  {
    "nama": "Kangkung",
    "deskripsi": "Kangkung cocok di tanah liat lembab atau berair.",
    "tanah": "liat",
    "suhu_min": 22,
    "suhu_max": 30,
    "kelembaban_min": 70,
    "kelembaban_max": 100,
    "tips":
        "Pastikan tanah selalu basah, panen daun setiap 2 minggu untuk pertumbuhan cepat.",
  },
  {
    "nama": "Wortel",
    "deskripsi": "Wortel sangat cocok di tanah berpasir dan gembur.",
    "tanah": "berpasir",
    "suhu_min": 16,
    "suhu_max": 24,
    "kelembaban_min": 55,
    "kelembaban_max": 85,
    "tips":
        "Sirami secara merata, cabut gulma, dan gemburkan tanah secara berkala.",
  },
  {
    "nama": "Bawang Merah",
    "deskripsi":
        "Bawang merah tumbuh baik di tanah gembur dengan sinar matahari penuh.",
    "tanah": "gembur",
    "suhu_min": 25,
    "suhu_max": 32,
    "kelembaban_min": 50,
    "kelembaban_max": 80,
    "tips":
        "Siram secukupnya, berikan pupuk NPK setiap 2 minggu, dan pastikan paparan sinar matahari penuh.",
  },
  {
    "nama": "Mentimun",
    "deskripsi": "Mentimun cocok di tanah gembur berdrainase baik.",
    "tanah": "gembur",
    "suhu_min": 23,
    "suhu_max": 30,
    "kelembaban_min": 60,
    "kelembaban_max": 90,
    "tips":
        "Siram tiap pagi, beri pupuk organik cair tiap minggu, dan gunakan ajir untuk merambat.",
  },
  {
    "nama": "Lettuce",
    "deskripsi": "Lettuce menyukai tanah liat lembab dengan suhu dingin.",
    "tanah": "liat",
    "suhu_min": 15,
    "suhu_max": 25,
    "kelembaban_min": 60,
    "kelembaban_max": 95,
    "tips": "Jaga kelembaban tanah, panen daun muda untuk kualitas terbaik.",
  },
  {
    "nama": "Terong",
    "deskripsi": "Terong cocok di tanah gembur dengan suhu hangat.",
    "tanah": "gembur",
    "suhu_min": 24,
    "suhu_max": 30,
    "kelembaban_min": 55,
    "kelembaban_max": 85,
    "tips":
        "Siram secukupnya, berikan pupuk NPK tiap 2 minggu, dan lakukan penyiangan rutin.",
  },
  {
    "nama": "Pakcoy",
    "deskripsi": "Pakcoy dapat tumbuh baik di tanah liat lembab.",
    "tanah": "liat",
    "suhu_min": 18,
    "suhu_max": 27,
    "kelembaban_min": 70,
    "kelembaban_max": 95,
    "tips": "Siram secara rutin, panen daun muda untuk pertumbuhan optimal.",
  },
  {
    "nama": "Sawi",
    "deskripsi": "Sawi cocok di tanah liat lembab dan subur.",
    "tanah": "liat",
    "suhu_min": 20,
    "suhu_max": 28,
    "kelembaban_min": 65,
    "kelembaban_max": 95,
    "tips":
        "Siram tiap pagi, berikan pupuk kompos tiap minggu, dan panen daun secara berkala.",
  },
  {
    "nama": "Kentang",
    "deskripsi": "Kentang tumbuh baik di tanah gembur berpasir.",
    "tanah": "berpasir",
    "suhu_min": 15,
    "suhu_max": 22,
    "kelembaban_min": 60,
    "kelembaban_max": 90,
    "tips":
        "Gemburkan tanah, siram secukupnya, dan lakukan penyiangan gulma secara rutin.",
  },
  {
    "nama": "Kol",
    "deskripsi": "Kol menyukai tanah liat lembab dan suhu rendah-sedang.",
    "tanah": "liat",
    "suhu_min": 15,
    "suhu_max": 25,
    "kelembaban_min": 70,
    "kelembaban_max": 95,
    "tips":
        "Siram secara teratur, beri pupuk organik tiap 2 minggu, dan panen daun secara berkala.",
  },
  {
    "nama": "Jagung",
    "deskripsi": "Jagung cocok di tanah gembur dengan sinar matahari penuh.",
    "tanah": "gembur",
    "suhu_min": 21,
    "suhu_max": 30,
    "kelembaban_min": 50,
    "kelembaban_max": 85,
    "tips":
        "Pastikan paparan sinar matahari penuh, siram secukupnya, dan gunakan pupuk NPK tiap 2 minggu.",
  },
  {
    "nama": "Padi",
    "deskripsi": "Padi sangat cocok di tanah liat lembab dan berair.",
    "tanah": "liat",
    "suhu_min": 20,
    "suhu_max": 30,
    "kelembaban_min": 70,
    "kelembaban_max": 100,
    "tips":
        "Pastikan tanah selalu basah, panen daun tua secara berkala, dan berikan pupuk sesuai jadwal tanam.",
  },
  {
    "nama": "Semangka",
    "deskripsi": "Semangka cocok di tanah gembur berpasir.",
    "tanah": "berpasir",
    "suhu_min": 23,
    "suhu_max": 32,
    "kelembaban_min": 50,
    "kelembaban_max": 80,
    "tips":
        "Siram pagi dan sore, beri pupuk organik tiap 2 minggu, dan gunakan ajir untuk merambat.",
  },
  {
    "nama": "Pepaya",
    "deskripsi": "Pepaya cocok di tanah gembur dengan sinar matahari penuh.",
    "tanah": "gembur",
    "suhu_min": 22,
    "suhu_max": 32,
    "kelembaban_min": 55,
    "kelembaban_max": 85,
    "tips":
        "Siram secukupnya, beri pupuk NPK tiap 2 minggu, dan pastikan paparan matahari cukup.",
  },
  {
    "nama": "Pisang",
    "deskripsi": "Pisang tumbuh baik di tanah liat lembab dan iklim tropis.",
    "tanah": "liat",
    "suhu_min": 24,
    "suhu_max": 32,
    "kelembaban_min": 60,
    "kelembaban_max": 95,
    "tips":
        "Siram rutin, berikan pupuk organik tiap 2 minggu, dan jaga tanah tetap lembab.",
  },
  {
    "nama": "Mangga",
    "deskripsi":
        "Mangga cocok di tanah gembur berpasir dengan sinar matahari penuh.",
    "tanah": "berpasir",
    "suhu_min": 25,
    "suhu_max": 35,
    "kelembaban_min": 40,
    "kelembaban_max": 80,
    "tips":
        "Siram secukupnya, beri pupuk kandang tiap bulan, dan pastikan paparan matahari penuh.",
  },
  {
    "nama": "Alpukat",
    "deskripsi": "Alpukat menyukai tanah gembur dengan drainase baik.",
    "tanah": "gembur",
    "suhu_min": 18,
    "suhu_max": 28,
    "kelembaban_min": 60,
    "kelembaban_max": 90,
    "tips":
        "Siram rutin, berikan pupuk kompos tiap 2 minggu, dan pastikan tanah tidak tergenang.",
  },
];

// ===== Fungsi Rekomendasi =====
List<Map<String, dynamic>> hitungRekomendasi(
  int suhu,
  int kelembaban,
  String tanah,
) {
  return dataTanaman.where((tanaman) {
    return suhu >= tanaman["suhu_min"] &&
        suhu <= tanaman["suhu_max"] &&
        kelembaban >= tanaman["kelembaban_min"] &&
        kelembaban <= tanaman["kelembaban_max"] &&
        tanah.toLowerCase() == tanaman["tanah"].toLowerCase();
  }).toList();
}

// ===== Halaman Tanaman =====
class TanamanPage extends StatelessWidget {
  const TanamanPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil semua data tanaman
    return Scaffold(
      appBar: AppBar(
        title: const Text("Referensi Tanaman"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tanaman').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<Map<String, dynamic>> firebaseTanaman = snapshot.hasData
              ? snapshot.data!.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList()
              : [];

          final semuaTanaman = [...dataTanaman, ...firebaseTanaman];

          if (semuaTanaman.isEmpty) {
            return const Center(child: Text("Belum ada tanaman."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: semuaTanaman.length,
            itemBuilder: (context, index) {
              final tanaman = semuaTanaman[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tanaman['nama'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tanaman['deskripsi'],
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      if (tanaman.containsKey('tips'))
                        Text(
                          "💡 Tips: ${tanaman['tips']}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue.shade800,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _infoChip("Tanah", tanaman['tanah']),
                          _infoChip(
                            "Suhu",
                            "${tanaman['suhu_min']}-${tanaman['suhu_max']} °C",
                          ),
                          _infoChip(
                            "Kelembaban",
                            "${tanaman['kelembaban_min']}-${tanaman['kelembaban_max']}%",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "$label: $value",
        style: const TextStyle(
          fontSize: 14,
          color: Colors.green,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
