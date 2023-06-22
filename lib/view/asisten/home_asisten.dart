import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomeAsisten extends StatefulWidget {
  const HomeAsisten({super.key});

  @override
  State<HomeAsisten> createState() => _HomeAsistenState();
}

class _HomeAsistenState extends State<HomeAsisten> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text("Halaman Asisten"),
      ),
    );
  }
}
