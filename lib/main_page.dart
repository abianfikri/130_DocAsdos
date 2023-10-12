import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exam_project/controller/auth_controller.dart';
import 'package:final_exam_project/view/admin/dokumentasi_page.dart';
import 'package:final_exam_project/view/admin/matakuliah_page.dart';
import 'package:final_exam_project/view/admin/home_admin.dart';
import 'package:final_exam_project/view/asisten/dokumentasi_asisten.dart';
import 'package:final_exam_project/view/asisten/home_asisten.dart';
import 'package:final_exam_project/view/halaman_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Class MainPage bertugas untuk mengontrol jalannya halaman program
/// ketika user membuka aplikasi lalu ditampilkan halaman splashscreen maka
/// akan menuju halaman Mainpage sebagai pendeteksi user sudah melakukan login atau belum
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

/// Class _MainPageState bertugas untuk membuat method initState, CheckLoginStatus
/// dan OnTap serta yang bertugas mengatur apakah login telah melakukan login atau belum.
/// di dalam class ini juga bertugas untuk bottom Navigasi untuk setiap masing-masing user
class _MainPageState extends State<MainPage> {
  /// Memanggil Fungsi AutController
  final autctr = AuthController();

  /// Deklarasi variable bool dengan nilai false
  bool isLoogedIn = false;

  /// Deklarasi variable String untuk menedeteksi UserRole
  String? userRole;
  @override

  /// Method untuk mengecek program yang dijalankan secara realtime
  void initState() {
    // TODO: implement initState
    super.initState();
    autctr.getCurrentUser;
    checkLoginStatus();
  }

  /// Method untuk mengecek status Login User ketika user keluar dari program
  /// user tidak perlu login ulang karena ada fungsi ini untuk mengeceknya
  Future checkLoginStatus() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userSnaphot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (userSnaphot.exists) {
        setState(() {
          isLoogedIn = true;
          userRole = userSnaphot.get('role');
        });
      }
    }
  }

  int currentIndex = 0;

  /// Method untuk pindah halaman menggunkan navigasi bottom
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override

  /// Bagian Halaman Navigasi Bottom untuk user Admin dan Asisten
  Widget build(BuildContext context) {
    if (isLoogedIn) {
      if (userRole == 'Admin') {
        return Scaffold(
          appBar: currentIndex != 2 ? buildAppBar() : null,
          body: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _buildCurrentPage(),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            backgroundColor: Colors.deepOrange.shade800,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Matakuliah',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.description),
                label: 'Dokumentasi',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      } else if (userRole == 'Asisten') {
        return Scaffold(
          appBar: currentIndex != 1 ? buildAppBar() : null,
          body: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _buildCurrentPage(),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            backgroundColor: Colors.deepOrange.shade800,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.description),
                label: 'Dokumentasi',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      } else {
        /// Jika peran pengguna tidak dikenali, arahkan ke halaman login
        return HalamanLogin();
      }
    } else {
      return HalamanLogin();
    }
  }

  /// App bar Admin
  AppBar buildAppBar() {
    String appBarTitle = '';
    if (currentIndex == 0 && userRole == 'Admin') {
      appBarTitle = 'Matakuliah Page List';
    } else if (currentIndex == 0 && userRole == 'Asisten') {
      appBarTitle = 'Dokumentasi Page Asisten';
    } else if (currentIndex == 1) {
      appBarTitle = 'Dokumentasi Page List';
    }

    /// Membalikkan nilai AppBar
    return AppBar(
      backgroundColor: Colors.pink.shade700,
      centerTitle: true,
      automaticallyImplyLeading: false, // Menghilangkan ikon "leading"
      title: Text(appBarTitle),
    );
  }

  /// Pindah Halaman Khusus Admin dan Asisten menggunakan bantuan Switch and Case
  Widget _buildCurrentPage() {
    switch (currentIndex) {
      case 0:
        if (userRole == 'Admin') {
          return MatakuliahPage();
        } else if (userRole == 'Asisten') {
          return DokumentasiAsisten();
        }
        return Container();
      case 1:
        if (userRole == 'Admin') {
          return DokumentasiPage();
        } else if (userRole == 'Asisten') {
          return HomeAsisten();
        }
        return Container();
      case 2:
        return HomeAdmin();
      default:
        return Container();
    }
  }
}
