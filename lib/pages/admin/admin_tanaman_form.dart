import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminTanamanForm extends StatefulWidget {
  final String? tanamanID;
  final Map<String, dynamic>? initialData;

  const AdminTanamanForm({super.key, this.tanamanID, this.initialData});

  @override
  State<AdminTanamanForm> createState() => _AdminTanamanFormState();
}

class _AdminTanamanFormState extends State<AdminTanamanForm> {
  final TextEditingController nama = TextEditingController();
  final TextEditingController deskripsi = TextEditingController();
  final TextEditingController tanah = TextEditingController();
  final TextEditingController suhuMin = TextEditingController();
  final TextEditingController suhuMax = TextEditingController();
  final TextEditingController kelembabanMin = TextEditingController();
  final TextEditingController kelembabanMax = TextEditingController();
  final TextEditingController tips = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      nama.text = widget.initialData!["nama"];
      deskripsi.text = widget.initialData!["deskripsi"];
      tanah.text = widget.initialData!["tanah"];
      suhuMin.text = widget.initialData!["suhu_min"].toString();
      suhuMax.text = widget.initialData!["suhu_max"].toString();
      kelembabanMin.text = widget.initialData!["kelembaban_min"].toString();
      kelembabanMax.text = widget.initialData!["kelembaban_max"].toString();
      tips.text = widget.initialData!["tips"];
    }
  }

  void simpan() {
    final data = {
      "nama": nama.text,
      "deskripsi": deskripsi.text,
      "tanah": tanah.text,
      "suhu_min": int.parse(suhuMin.text),
      "suhu_max": int.parse(suhuMax.text),
      "kelembaban_min": int.parse(kelembabanMin.text),
      "kelembaban_max": int.parse(kelembabanMax.text),
      "tips": tips.text,
    };

    if (widget.tanamanID == null) {
      // Tambah
      FirebaseFirestore.instance.collection("tanaman").add(data);
    } else {
      // Update
      FirebaseFirestore.instance
          .collection("tanaman")
          .doc(widget.tanamanID)
          .update(data);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.tanamanID == null ? "Tambah Tanaman" : "Edit Tanaman",
        ),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          input("Nama Tanaman", nama),
          input("Deskripsi", deskripsi),
          input("Jenis Tanah", tanah),
          input("Suhu Minimum", suhuMin, number: true),
          input("Suhu Maksimum", suhuMax, number: true),
          input("Kelembaban Minimum", kelembabanMin, number: true),
          input("Kelembaban Maksimum", kelembabanMax, number: true),
          input("Tips", tips),
          const SizedBox(height: 20),

          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: simpan,
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  Widget input(String label, TextEditingController c, {bool number = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
