import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exam_project/controller/auth_controller.dart';
import 'package:final_exam_project/view/admin/dokumentasi_page.dart';
import 'package:final_exam_project/view/admin/matakuliah_page.dart';
import 'package:final_exam_project/view/halaman_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final autctr = AuthController();

    final user = FirebaseAuth.instance.currentUser!;

    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 4, 64, 155),
      body: SafeArea(
        child: Column(
          children: [
            // Container Tampilan Username dan Admin Serta Logout
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              height: 170,
              // Row Username, admin button Logout
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Column Username
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<DocumentSnapshot>(
                                future: userCollection.doc(user.uid).get(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return CircularProgressIndicator();
                                  }

                                  final username = snapshot.data?['username'];

                                  return Text(
                                    'Hello, ' +
                                        username.toString().toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                              Text(
                                "Admin",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  // Row Untuk buttton Logout
                  Row(
                    children: [
                      // Container Logout
                      Container(
                        margin: EdgeInsets.all(5),
                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/image/logo.jpeg'),
                          radius: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          // Last Column
        ),
      ),
    );
  }
}
