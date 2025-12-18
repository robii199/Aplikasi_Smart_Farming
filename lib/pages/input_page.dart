import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'rekomendasi_data.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final TextEditingController suhuController = TextEditingController();
  final TextEditingController kelembabanController = TextEditingController();
  final TextEditingController curahHujanController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();

  String selectedTanah = "liat";

  // ============================
  // LOGIKA TIDAK DIUBAH
  // ============================
  List<Map<String, dynamic>> cariTanamanCocok({
    required double suhu,
    required double kelembaban,
    required String jenisTanah,
  }) {
    return dataTanaman.where((tanaman) {
      return suhu >= tanaman["suhu_min"] &&
          suhu <= tanaman["suhu_max"] &&
          kelembaban >= tanaman["kelembaban_min"] &&
          kelembaban <= tanaman["kelembaban_max"] &&
          jenisTanah.toLowerCase() == tanaman["tanah"].toLowerCase();
    }).toList();
  }

  Future<void> _simpanRiwayatFirebase({
    required double suhu,
    required double kelembaban,
    required double curahHujan,
    required String lokasi,
    required String jenisTanah,
    required List<Map<String, dynamic>> tanaman,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Anda harus login terlebih dahulu!")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection("riwayat").add({
      "user_id": user.uid,
      "tanggal": DateTime.now(),
      "lokasi": lokasi,
      "suhu": suhu,
      "kelembaban": kelembaban,
      "curah_hujan": curahHujan,
      "tanah": jenisTanah,
      "rekomendasi": tanaman,
    });
  }

  Future<void> _handleSimpan() async {
    if (suhuController.text.isEmpty ||
        kelembabanController.text.isEmpty ||
        curahHujanController.text.isEmpty ||
        lokasiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua data terlebih dahulu!")),
      );
      return;
    }

    final suhu = double.tryParse(suhuController.text);
    final kelembaban = double.tryParse(kelembabanController.text);
    final curah = double.tryParse(curahHujanController.text);

    if (suhu == null || kelembaban == null || curah == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Masukkan nilai angka yang valid!")),
      );
      return;
    }

    final lokasi = lokasiController.text;

    final tanaman = cariTanamanCocok(
      suhu: suhu,
      kelembaban: kelembaban,
      jenisTanah: selectedTanah,
    );

    await _simpanRiwayatFirebase(
      suhu: suhu,
      kelembaban: kelembaban,
      curahHujan: curah,
      lokasi: lokasi,
      jenisTanah: selectedTanah,
      tanaman: tanaman,
    );

    suhuController.clear();
    kelembabanController.clear();
    curahHujanController.clear();
    lokasiController.clear();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Data berhasil disimpan!")));

    Future.delayed(const Duration(milliseconds: 600), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    });
  }

  // ============================
  // UI
  // ============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Input Data"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // JUDUL
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.nature, color: Colors.green, size: 28),
                SizedBox(width: 8),
                Text(
                  "Input Data Lahan & Cuaca",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ==========================
            // DROPDOWN TANAH + IKON
            // ==========================
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Jenis Tanah",
                prefixIcon: Icon(Icons.landscape, color: Colors.green),
                border: OutlineInputBorder(),
              ),
              value: selectedTanah,
              items: const [
                DropdownMenuItem(value: "liat", child: Text("Liat")),
                DropdownMenuItem(value: "gembur", child: Text("Gembur")),
                DropdownMenuItem(value: "berpasir", child: Text("Berpasir")),
              ],
              onChanged: (value) => setState(() => selectedTanah = value!),
            ),

            const SizedBox(height: 12),

            // Suhu
            TextField(
              controller: suhuController,
              decoration: const InputDecoration(
                labelText: "Suhu (°C)",
                prefixIcon: Icon(Icons.thermostat, color: Colors.green),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),

            // Kelembaban
            TextField(
              controller: kelembabanController,
              decoration: const InputDecoration(
                labelText: "Kelembaban (%)",
                prefixIcon: Icon(Icons.water_drop, color: Colors.green),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),

            // Curah hujan
            TextField(
              controller: curahHujanController,
              decoration: const InputDecoration(
                labelText: "Curah Hujan (mm/bulan)",
                prefixIcon: Icon(Icons.cloud, color: Colors.green),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),

            // Lokasi
            TextField(
              controller: lokasiController,
              decoration: const InputDecoration(
                labelText: "Lokasi",
                prefixIcon: Icon(Icons.location_on, color: Colors.green),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            // ==========================
            // BUTTON ANALISIS
            // ==========================
            SizedBox(
              width: 180,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.analytics, color: Colors.white),
                label: const Text(
                  "Analisis",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _handleSimpan,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
