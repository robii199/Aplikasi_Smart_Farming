import 'package:flutter/material.dart';
import 'input_page.dart';
import 'history_page.dart';
import 'rekomendasi_data.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Nilai default untuk rekomendasi awal
  int suhu = 25;
  int kelembaban = 70;
  String tanah = 'gembur';

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      InputPage(),
      HistoryPage(),
      TanamanPage(),
      ProfilePage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Input"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Riwayat"),
          BottomNavigationBarItem(icon: Icon(Icons.grass), label: "Tanaman"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
