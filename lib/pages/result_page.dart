import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'rekomendasi_data.dart';

class ResultPage extends StatefulWidget {
  final String lokasi;
  final int suhu;
  final int kelembaban;
  final int curahHujan;
  final String jenisTanah;

  const ResultPage({
    super.key,
    required this.lokasi,
    required this.suhu,
    required this.kelembaban,
    required this.curahHujan,
    required this.jenisTanah,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late List<Map<String, dynamic>> hasilRekomendasi;

  @override
  void initState() {
    super.initState();
    hasilRekomendasi = hitungRekomendasi(
      widget.suhu,
      widget.kelembaban,
      widget.jenisTanah,
    );
    simpanKeFirebase(hasilRekomendasi); // panggil sekali saja
  }

  Future<void> simpanKeFirebase(List<Map<String, dynamic>> hasil) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection("riwayat").add({
      "user_id": user.uid,
      "tanggal": Timestamp.now(),
      "lokasi": widget.lokasi,
      "suhu": widget.suhu,
      "kelembaban": widget.kelembaban,
      "curah_hujan": widget.curahHujan,
      "tanah": widget.jenisTanah,
      "rekomendasi": hasil
          .map(
            (e) => {
              "nama": e["nama"],
              "deskripsi": e["deskripsi"],
              "tanah": e["tanah"],
              "suhu_min": e["suhu_min"],
              "suhu_max": e["suhu_max"],
              "kelembaban_min": e["kelembaban_min"],
              "kelembaban_max": e["kelembaban_max"],
              "tips": e["tips"] ?? "",
            },
          )
          .toList(),
      "tanaman_rekomendasi": hasil.isEmpty
          ? "Tidak ada"
          : hasil.map((e) => e["nama"]).join(', '),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil Pencarian"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: hasilRekomendasi.isEmpty
            ? const Center(child: Text("Tidak ada tanaman yang cocok."))
            : ListView.builder(
                itemCount: hasilRekomendasi.length,
                itemBuilder: (context, index) {
                  final item = hasilRekomendasi[index];
                  return Card(
                    elevation: 3,
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
                            item["nama"],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(item["deskripsi"]),
                          const SizedBox(height: 6),
                          if (item["tips"] != null && item["tips"]!.isNotEmpty)
                            Text(
                              "💡 Tips: ${item["tips"]}",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: [
                              _infoChip("Tanah", item["tanah"]),
                              _infoChip(
                                "Suhu",
                                "${item["suhu_min"]}-${item["suhu_max"]} °C",
                              ),
                              _infoChip(
                                "Kelembaban",
                                "${item["kelembaban_min"]}-${item["kelembaban_max"]}%",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
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
