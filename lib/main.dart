import 'package:final_exam_project/component/gradiant_text.dart';
import 'package:final_exam_project/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// Method Main using async yang bertugas untuk menjalan aplikasi
/// memanggil fungsi Firebase dan menjalankan class MyApp
/// dan juga menggunakan Method Future dan WidgetsFlutterBinding
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

/// Class MyApp with statelessWidget
/// digunakan untuk membuat tampilan static atau tampilan tetap
/// dan menjalankan fungsi Class SplashPage menggunakan widget StateFull
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
    );
  }
}

/// Class SplashPage digunakan untuk menampilkan halaman splashscreen ketika program pertama kali dijalankan.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

/// class SplashPageState bertugas untuk membuat tampilan halamn splashs screen
class _SplashPageState extends State<SplashPage> {
  @override

  /// method initState bertugas untuk menjalankan program secara realtime
  /// didalam method ini terdapat Future.delayed bertugas untuk membuat jeda waktu
  /// antara splashscreen dengan halaman MainPage selama 3 seconds.
  /// dan menggunakan pushReplacement untuk pindah halaman
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3)).then(
      (value) {
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (context) => MainPage(),
          ),
        );
      },
    );
  }

  @override

  /// Membuat Widget untuk tampilan daripada halaman SplashScreen
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple,
              Colors.red,
              Colors.yellow.shade600,
            ],
          ),
        ),
        child: Column(
          children: const [
            SizedBox(
              height: 150,
            ),
            GradientText(
              'Welcome to DocAsdos',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              gradient: LinearGradient(
                colors: [
                  Colors.tealAccent,
                  Colors.white,
                  Colors.tealAccent,
                ],
              ),
            ),
            SizedBox(
              height: 80,
            ),
            CircleAvatar(
              backgroundImage: AssetImage('assets/image/logo.jpeg'),
              radius: 60,
            ),
            SizedBox(
              height: 80,
            ),
            SpinKitSpinningLines(
              color: Colors.white,
              size: 50.0,
            ),
            SizedBox(
              height: 80,
            ),
            GradientText(
              'Created by Abian',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              gradient: LinearGradient(
                colors: [
                  Colors.tealAccent,
                  Colors.white,
                  Colors.tealAccent,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
