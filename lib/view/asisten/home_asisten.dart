import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exam_project/component/gradiant_text.dart';
import 'package:final_exam_project/controller/auth_controller.dart';
import 'package:final_exam_project/controller/profile_controller.dart';
import 'package:final_exam_project/view/asisten/edit_profile_asisten.dart';
import 'package:final_exam_project/view/halaman_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeAsisten extends StatefulWidget {
  const HomeAsisten({super.key});

  @override
  State<HomeAsisten> createState() => _HomeAsistenState();
}

class _HomeAsistenState extends State<HomeAsisten> {
  final autctr = AuthController();
  final pfctr = ProfileController();

  final user = FirebaseAuth.instance.currentUser!;

  String? username;
  String? matkul;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    // TODO: implement initState
    pfctr.getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade700,
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
              // Tulisan Welcome Asisten
              Container(
                height: 530,
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
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 150,

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

                                          username = snapshot.data?['username'];

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
                                        "Asisten",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                          // Row Logo
                          Row(
                            children: [
                              // Container Logo
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
                    // Garis
                    Container(
                      width: 350,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: Colors.grey, width: 1.0))),
                    ),

                    SizedBox(
                      height: 40,
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: FutureBuilder<List<DocumentSnapshot>>(
                        future: pfctr
                            .getProfileList(), // Ganti dengan method yang mengembalikan future dari list profile
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }

                          final List<DocumentSnapshot> data = snapshot.data!;

                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final namaLengkap = data[index]['nama'];
                              final nim = data[index]['nim'];
                              final semester = data[index]['semester'];

                              final List<dynamic> matkulList =
                                  data[index]['matkul'];

                              if (data[index]['uid'] == user.uid.toString() &&
                                  matkulList != '') {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Nama Lengkap
                                        namaLengkap == null || namaLengkap == ""
                                            ? Text(
                                                'Nama Lengkap',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : Text(
                                                namaLengkap,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                        // NIM
                                        nim == null || nim == ""
                                            ? Text(
                                                'NIM',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              )
                                            : Text(
                                                nim,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                        // Semester
                                        semester == null || semester == ""
                                            ? Text(
                                                'Semester',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              )
                                            : Text(
                                                'Semester ' + semester,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                        Text("Asisten Dosen"),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        // MatkulList
                                        for (int i = 0;
                                            i < matkulList.length;
                                            i++)
                                          Text(
                                            '${i + 1}. ' +
                                                matkulList[i].toString(),
                                          ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditProfileAsisten(
                                              uid: user.uid,
                                              username: username.toString(),
                                              beforeNama: namaLengkap,
                                              beforeNIM: nim,
                                              beforeSemester: semester,
                                              beforeMatkul: matkulList,
                                            ),
                                          ),
                                        ).then((value) {
                                          if (value == true) {
                                            setState(() {
                                              pfctr.getProfile();
                                            });
                                          }
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.blue,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Edit Profile',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return Container();
                            },
                          );
                        },
                      ),
                    ),

                    SizedBox(
                      height: 80,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
