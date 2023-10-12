import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exam_project/component/gradiant_text.dart';
import 'package:final_exam_project/controller/auth_controller.dart';
import 'package:final_exam_project/view/halaman_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

///  Class HomeAdmin adalah sebuah class untuk membuat tampilan profile dari admin
/// pada class ini menggunakan statelesswidget.
/// di class ini akan memuat beberapa informasi berupa nama username admin, role admin,
/// email admin, dan juga button logout
class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final autctr = AuthController();

    final user = FirebaseAuth.instance.currentUser!;

    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');

    return Scaffold(
      backgroundColor: Colors.purple.shade400,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF8A2387),
                Color(0xFFE94057),
                Color(0xFFF27121),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 400,
                width: 380,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    GradientText(
                      "Selamat Datang",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      gradient: LinearGradient(
                        colors: [
                          Colors.teal,
                          Colors.purple,
                          Colors.red,
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Container Tampilan Username dan Admin Serta Logout
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FutureBuilder<DocumentSnapshot>(
                                        future:
                                            userCollection.doc(user.uid).get(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return CircularProgressIndicator();
                                          }

                                          final username =
                                              snapshot.data?['username'];

                                          return Text(
                                            'Hello, ' +
                                                username
                                                    .toString()
                                                    .toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          );
                                        },
                                      ),
                                      Text(
                                        user.email!,
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      Text(
                                        "Admin",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
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
                                  backgroundImage:
                                      AssetImage('assets/image/logo.jpeg'),
                                  radius: 30,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    // Button Logout
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xFF8A2387),
                              Color(0xFFE94057),
                              Color(0xFFF27121),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      onTap: () async {
                        autctr.signOut();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HalamanLogin()),
                            (route) => false);
                      },
                    ),
                  ],
                ),
              )
            ],
            // Last Column
          ),
        ),
      ),
    );
  }
}
