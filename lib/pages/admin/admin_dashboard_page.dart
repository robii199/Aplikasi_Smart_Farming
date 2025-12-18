import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  Future<int> countCollection(String collection) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(collection)
        .get();
    return snapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Admin"),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder(
        future: Future.wait([
          countCollection('users'),
          countCollection('riwayat'),
          countCollection('tanaman'),
        ]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          final totalUsers = data[0];
          final totalRiwayat = data[1];
          final totalTanaman = data[2];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                dashboardCard(
                  "Total User",
                  totalUsers,
                  Colors.blue,
                  Icons.person,
                ),
                dashboardCard(
                  "Total Riwayat",
                  totalRiwayat,
                  Colors.orange,
                  Icons.history,
                ),
                dashboardCard(
                  "Total Tanaman",
                  totalTanaman,
                  Colors.green,
                  Icons.local_florist,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget dashboardCard(String title, int number, Color color, IconData icon) {
    return Card(
      color: color,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 32),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        trailing: Text(
          "$number",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
