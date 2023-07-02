import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exam_project/controller/auth_controller.dart';
import 'package:final_exam_project/main.dart';
import 'package:final_exam_project/view/admin/dokumentasi_page.dart';
import 'package:final_exam_project/view/admin/home_admin.dart';
import 'package:final_exam_project/view/admin/matakuliah_page.dart';
import 'package:final_exam_project/view/asisten/home_asisten.dart';
import 'package:final_exam_project/view/halaman_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final autctr = AuthController();
  bool isLoogedIn = false;
  String? userRole;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    autctr.getCurrentUser;
    checkLoginStatus();
  }

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
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });

    if (index == 3) {
      // Jika item "Logout" di tap
      logout();
    }
  }

  void logout() async {
    await autctr.signOut();
    setState(() {
      isLoogedIn = false;
      userRole = null;
      SplashPage();
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HalamanLogin()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoogedIn) {
      if (userRole == 'Admin') {
        return Scaffold(
          appBar: currentIndex != 0 ? buildAppBar() : null,
          body: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _buildCurrentPage(),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            backgroundColor: Colors.blue.shade900,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Matakuliah',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.description),
                label: 'Dokumentasi',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.logout),
                label: 'Logout',
              ),
            ],
          ),
        );
      } else if (userRole == 'Asisten') {
        return HomeAsisten();
      } else {
        // Jika peran pengguna tidak dikenali, arahkan ke halaman login
        return HalamanLogin();
      }
    } else {
      return HalamanLogin();
    }
  }

  // App bar Admin
  AppBar buildAppBar() {
    String appBarTitle = '';
    if (currentIndex == 0) {
      appBarTitle = 'Home';
    } else if (currentIndex == 1) {
      appBarTitle = 'Matakuliah Page List';
    } else if (currentIndex == 2) {
      appBarTitle = 'Dokumentasi Page List';
    }

    return AppBar(
      backgroundColor: Colors.blue.shade900,
      centerTitle: true,
      automaticallyImplyLeading: false, // Menghilangkan ikon "leading"
      title: Text(appBarTitle),
    );
  }

  // Pindah Halaman Khusus Admin
  Widget _buildCurrentPage() {
    switch (currentIndex) {
      case 0:
        return HomeAdmin();
      case 1:
        return MatakuliahPage();
      case 2:
        return DokumentasiPage();
      default:
        return Container();
    }
  }
}
