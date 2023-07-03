import 'package:final_exam_project/component/gradiant_text.dart';
import 'package:final_exam_project/main_page.dart';
import 'package:final_exam_project/view/halaman_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

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

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
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
