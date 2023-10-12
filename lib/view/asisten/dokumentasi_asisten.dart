import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exam_project/controller/dokumentasi_controller.dart';
import 'package:final_exam_project/view/asisten/add_dokumentasi.dart';
import 'package:final_exam_project/view/asisten/update_dokumentasi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Class DokumentasiAsisten merupakan class yang menampilkan list card dari hasil create dokumentasi.
/// disini user dapat melihat data dokumentasi yang telah dibuat nya dan disimpan di dalam database.
/// tetapi disini hanya data user itu saja yang akan ditampilkan karene get data nya by uid dari user
/// yang create data dokumentasinya.
class DokumentasiAsisten extends StatefulWidget {
  const DokumentasiAsisten({super.key});

  @override
  State<DokumentasiAsisten> createState() => _DokumentasiAsistenState();
}

/// Pada class ini menampilkan tampilan listcard DokumentasiAsisten
class _DokumentasiAsistenState extends State<DokumentasiAsisten> {
  final dkctr = DokumentasiController();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    // TODO: implement initState
    dkctr.getDokumentasi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
            children: [
              SizedBox(
                height: 20,
              ),

              // List Data Dokumentasi
              Expanded(
                child: Container(
                  child: StreamBuilder<List<DocumentSnapshot>>(
                    stream: dkctr.stream,
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

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateDokumentasi(
                                        id: data[index]['id'].toString(),
                                        beforeJam:
                                            data[index]['jam'].toString(),
                                        beforeTanggal:
                                            data[index]['tanggal'].toString(),
                                        beforeMatkul: data[index]['namaMatkul']
                                            .toString(),
                                        uid: data[index]['uid'].toString(),
                                        beforeImage:
                                            data[index]['image'].toString(),
                                      ),
                                    ),
                                  ).then(
                                    (value) {
                                      if (value == true) {
                                        setState(() {
                                          dkctr.getDokumentasi();
                                        });
                                      }
                                    },
                                  );
                                },
                                child: Card(
                                  elevation: 15,
                                  child: ListTile(
                                    leading: Container(
                                      child: data[index]['image'] != null
                                          ? Image.network(
                                              '${data[index]['image'].toString()}')
                                          : Container(
                                              child: CircleAvatar(
                                              backgroundColor: Colors.black,
                                            )),
                                    ),
                                    title: Text(data[index]['namaMatkul']),
                                    subtitle: Text(data[index]['tanggal']),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        // Delete data
                                        var aa = dkctr.deleteDokumentasi(
                                            data[index]['id'].toString());
                                        if (dkctr.deleteDokumentasi(
                                                data[index]['id'].toString()) !=
                                            null) {
                                          dkctr
                                              .deleteDokumentasi(
                                                  data[index]['id'].toString())
                                              .then(
                                            (value) {
                                              setState(() {
                                                dkctr.getDokumentasi();
                                              });
                                            },
                                          );
                                          Future.delayed(Duration(seconds: 2))
                                              .then(
                                            (value) =>
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                              const SnackBar(
                                                content:
                                                    Text('Dokumentasi Deleted'),
                                              ),
                                            ),
                                          );
                                        } else {
                                          //  Failed
                                          Future.delayed(Duration(seconds: 2))
                                              .then(
                                            (value) =>
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Dokumentasi Failed to Delete'),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          return Container();
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
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
          ).then(
            (value) {
              if (value == true) {
                setState(() {
                  dkctr.getDokumentasi();
                });
              }
            },
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
