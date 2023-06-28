import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exam_project/controller/auth_controller.dart';
import 'package:final_exam_project/controller/dokumentasi_controller.dart';
import 'package:final_exam_project/controller/matakuliah_controller.dart';
import 'package:final_exam_project/view/asisten/add_dokumentasi.dart';
import 'package:final_exam_project/view/halaman_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomeAsisten extends StatefulWidget {
  const HomeAsisten({super.key});

  @override
  State<HomeAsisten> createState() => _HomeAsistenState();
}

class _HomeAsistenState extends State<HomeAsisten> {
  var mkctr = DokumentasiController();
  final autctr = AuthController();

  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mkctr.getDokumentasi();
    autctr.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade800,
      body: SafeArea(
        child: Column(
          children: [
            // Tulisan Welcome Asisten
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.email!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Asisten",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Column Button Logout
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: IconButton(
                          icon: Icon(Icons.logout),
                          onPressed: () {
                            // Logout
                            autctr.signOut();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HalamanLogin(),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            // List Data Dokumentasi Asissten
            SizedBox(
              child: Container(
                margin: EdgeInsets.all(20),
                child: Text(
                  "Dokumentasi List",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: StreamBuilder<List<DocumentSnapshot>>(
                  stream: mkctr.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final List<DocumentSnapshot> data = snapshot.data!;

                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        if (data[index]['uid'] == user.uid) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onLongPress: () {
                                // Update Data
                              },
                              child: Card(
                                elevation: 15,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.black,
                                  ),
                                  title: Text(data[index]['namaMatkul']),
                                  subtitle:
                                      Text('Tanggal ' + data[index]['tanggal']),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      // Delete
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: [
                            SizedBox(
                              height: 200,
                            ),
                            Text("Data Masih Kosong"),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Button Add
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDokumentasi(),
            ),
          );
        },
        heroTag: null,
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
