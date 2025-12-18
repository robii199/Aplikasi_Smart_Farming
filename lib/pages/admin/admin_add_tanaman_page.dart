import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAddTanamanPage extends StatefulWidget {
  const AdminAddTanamanPage({super.key});

  @override
  State<AdminAddTanamanPage> createState() => _AdminAddTanamanPageState();
}

class _AdminAddTanamanPageState extends State<AdminAddTanamanPage> {
  final namaC = TextEditingController();
  final phC = TextEditingController();
  final suhuC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Tanaman")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: namaC,
              decoration: const InputDecoration(labelText: "Nama Tanaman"),
            ),
            TextField(
              controller: phC,
              decoration: const InputDecoration(labelText: "pH Ideal"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: suhuC,
              decoration: const InputDecoration(labelText: "Suhu Ideal (°C)"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection("tanaman").add({
                  "nama": namaC.text,
                  "ph": double.parse(phC.text),
                  "suhu": double.parse(suhuC.text),
                });

                Navigator.pop(context);
              },
              child: const Text("Tambah"),
            ),
          ],
        ),
      ),
    );
  }
}
