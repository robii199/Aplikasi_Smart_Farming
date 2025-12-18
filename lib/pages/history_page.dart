import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Pencarian"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("riwayat")
            .where("user_id", isEqualTo: user!.uid)
            .orderBy("tanggal", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.docs;

          if (data.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada riwayat.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              final docData = item.data() as Map<String, dynamic>;

              // Amanin tipe data
              final suhu = (docData['suhu'] as num?)?.toDouble() ?? 0;
              final kelembaban =
                  (docData['kelembaban'] as num?)?.toDouble() ?? 0;
              final curahHujan =
                  (docData['curah_hujan'] as num?)?.toDouble() ?? 0;
              final lokasi = docData['lokasi'] ?? "-";
              final tanah = docData['tanah'] ?? "-";

              // Ambil rekomendasi sebagai list
              final rekom = docData['rekomendasi'];

              List<Map<String, dynamic>> rekomendasiList = [];

              if (rekom is List) {
                rekomendasiList = rekom
                    .map((e) => Map<String, dynamic>.from(e))
                    .toList();
              } else if (rekom is Map) {
                rekomendasiList = [Map<String, dynamic>.from(rekom)];
              }

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: ExpansionTile(
                    collapsedBackgroundColor: Colors.green.shade50,
                    backgroundColor: Colors.green.shade50,
                    leading: const Icon(
                      Icons.eco,
                      color: Colors.green,
                      size: 30,
                    ),
                    title: Text(
                      rekomendasiList != null && rekomendasiList.isNotEmpty
                          ? rekomendasiList[0]['nama'] ?? "-"
                          : docData['tanaman_rekomendasi'] ?? "-",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.green,
                      ),
                    ),
                    subtitle: Text(
                      "$lokasi • $tanah",
                      style: TextStyle(color: Colors.green.shade900),
                    ),
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Input pengguna
                            Row(
                              children: [
                                Icon(Icons.info, color: Colors.blue.shade600),
                                const SizedBox(width: 6),
                                Text(
                                  "Input Pengguna",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text("🌡 Suhu: $suhu °C"),
                            Text("💧 Kelembaban: $kelembaban%"),
                            Text("🌧 Curah Hujan: $curahHujan mm"),
                            Text("🌱 Jenis Tanah: $tanah"),
                            const SizedBox(height: 14),

                            // Rekomendasi tanaman
                            Row(
                              children: [
                                Icon(Icons.grass, color: Colors.green.shade700),
                                const SizedBox(width: 6),
                                Text(
                                  "Tanaman yang Cocok",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.green.shade800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            rekomendasiList == null || rekomendasiList.isEmpty
                                ? const Text(
                                    "Tidak ada tanaman yang cocok",
                                    style: TextStyle(color: Colors.red),
                                  )
                                : Column(
                                    children: rekomendasiList.map((tanaman) {
                                      return Card(
                                        elevation: 3,
                                        margin: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(14),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                tanaman['nama'] ?? "-",
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                tanaman['deskripsi'] ?? "-",
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              if (tanaman['tips'] != null &&
                                                  tanaman['tips']
                                                      .toString()
                                                      .isNotEmpty)
                                                Text(
                                                  "💡 Tips: ${tanaman['tips']}",
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.blue.shade800,
                                                  ),
                                                ),
                                              const SizedBox(height: 8),
                                              Wrap(
                                                spacing: 8,
                                                runSpacing: 8,
                                                children: [
                                                  _historyChip(
                                                    "Tanah",
                                                    tanaman['tanah'],
                                                  ),
                                                  _historyChip(
                                                    "Suhu",
                                                    "${tanaman['suhu_min']}-${tanaman['suhu_max']} °C",
                                                  ),
                                                  _historyChip(
                                                    "Kelembaban",
                                                    "${tanaman['kelembaban_min']}-${tanaman['kelembaban_max']}%",
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                          ],
                        ),
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

  // Helper Widget Chip
  Widget _historyChip(String label, dynamic value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Text(
        "$label: ${value ?? "-"}",
        style: const TextStyle(
          fontSize: 14,
          color: Colors.green,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
