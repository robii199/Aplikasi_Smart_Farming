import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHistoryPage extends StatelessWidget {
  const AdminHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Pencarian User"),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('riwayat')
            .orderBy('tanggal', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.docs;

          if (data.isEmpty) {
            return const Center(child: Text("Tidak ada riwayat"));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final docData = data[index].data() as Map<String, dynamic>;

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
                color: Colors.green.shade50, // Warna card ringan
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.history, color: Colors.green),
                  title: Text(
                    "User ID: ${docData['user_id'] ?? '-'}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Suhu: ${docData['suhu']} • Kelembaban: ${docData['kelembaban']}\n"
                    "Tanah: ${docData['tanah']}",
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.green,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.green.shade50, // Warna dialog
                        title: const Text(
                          "Detail Riwayat",
                          style: TextStyle(color: Colors.green),
                        ),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("User ID: ${docData['user_id']}"),
                              Text("Lokasi: ${docData['lokasi']}"),
                              Text("Suhu: ${docData['suhu']}"),
                              Text("Kelembaban: ${docData['kelembaban']}"),
                              Text("Curah Hujan: ${docData['curah_hujan']}"),
                              Text("Tanah: ${docData['tanah']}"),
                              const SizedBox(height: 10),
                              const Text(
                                "Rekomendasi Tanaman:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (rekomendasiList.isEmpty)
                                const Text("Tidak ada rekomendasi"),
                              ...rekomendasiList.map((tanaman) {
                                return Text(
                                  "- ${tanaman['nama'] ?? '-'}",
                                  style: const TextStyle(color: Colors.green),
                                );
                              }),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Tutup"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
