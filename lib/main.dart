import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/input_page.dart';
import 'pages/history_page.dart';
import 'pages/rekomendasi_data.dart';
import 'pages/profile_page.dart';
import 'pages/login_page.dart';
import 'pages/admin/admin_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // pastikan Firebase diinisialisasi
  runApp(const TaniMatchApp());
}

class TaniMatchApp extends StatelessWidget {
  const TaniMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "TaniMatch",
      theme: ThemeData(primarySwatch: Colors.green),

      // ========= ROUTES TAMBAHAN =========
      routes: {
        "/login": (_) => const LoginPage(),
        "/home": (_) => const BottomNavHome(),
        "/admin": (_) => const AdminMenu(),
        "/input": (_) => InputPage(),
        "/history": (_) => const HistoryPage(),
        "/tanaman": (_) => TanamanPage(),
        "/profile": (_) => const ProfilePage(),
      },

      // ===================================
      home: const AuthWrapper(),
    );
  }
}

// Wrapper untuk cek login
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          // Sudah login
          return const BottomNavHome();
        }

        // Belum login
        return const LoginPage();
      },
    );
  }
}

// ===== BottomNavHome =====
class BottomNavHome extends StatefulWidget {
  const BottomNavHome({super.key});

  @override
  State<BottomNavHome> createState() => _BottomNavHomeState();
}

class _BottomNavHomeState extends State<BottomNavHome> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      InputPage(),
      const HistoryPage(),
      TanamanPage(),
      const ProfilePage(),
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
