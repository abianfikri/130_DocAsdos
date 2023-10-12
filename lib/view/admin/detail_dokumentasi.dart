import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exam_project/component/gradiant_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

/// Class DetailDokumentasi merupakan sebuah tampilan yang menampilkan detail data dari halaman Dokumentasi, disini
/// Widget yang digunakan adalah statefulwidget karena data ini memuat informasi berupa tanggal, jam, gambar,
/// nama matakuliah dan uid yang nantinya akan di convert menjadi data nama asisten dan username yang di render dari
/// collection users
class DetailDokumentasi extends StatefulWidget {
  const DetailDokumentasi(
      {super.key,
      this.tanggal,
      this.jam,
      this.imageUrl,
      this.namaMatkul,
      this.uid});
  final String? uid;
  final String? tanggal;
  final String? jam;
  final String? imageUrl;
  final String? namaMatkul;

  @override
  State<DetailDokumentasi> createState() => _DetailDokumentasiState();
}

/// ini adalah class untuk membuat tampilan dari detaildokumentasi dan memnangil fungsi-fungsi yanng telah dibuat
/// seperti getAllDokumnetasi, get collection profile, firebaseAuth dan lain sebagainya
class _DetailDokumentasiState extends State<DetailDokumentasi> {
  final CollectionReference profileCollection =
      FirebaseFirestore.instance.collection('profile');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Dokumentasi'),
        centerTitle: true,
        backgroundColor: Colors.pink.shade700,
      ),
      body: Container(
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
              height: 600,
              width: 370,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 25,
                  ),

                  // Display Image
                  Container(
                    width: 120,
                    child: widget.imageUrl != null
                        ? Image.network('${widget.imageUrl}')
                        : Container(),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // Nama Matkul yang mau di update
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GradientText(
                      widget.namaMatkul!,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue,
                          Colors.red,
                          Colors.black,
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // Nama Lengkap
                  FutureBuilder<DocumentSnapshot>(
                    future: profileCollection.doc(widget.uid).get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }

                      final name = snapshot.data?['nama'];

                      return Text(
                        name.toString().toUpperCase(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      );
                    },
                  ),

                  SizedBox(
                    height: 50,
                  ),

                  // Username
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        "Username ",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        ":",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      // Nama Lengkap
                      FutureBuilder<DocumentSnapshot>(
                        future: profileCollection.doc(widget.uid).get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }

                          final name = snapshot.data?['username'];

                          return Text(
                            name.toString().toUpperCase(),
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        "Tanggal ",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Text(
                        ":",
                        style: TextStyle(fontSize: 18),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        width: 200,
                        child: TextFormField(
                          readOnly: true,
                          initialValue: widget.tanggal,
                        ),
                      )
                    ],
                  ),
                  //  JAM
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        "Jam ",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        width: 55,
                      ),
                      Text(
                        ":",
                        style: TextStyle(fontSize: 18),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        width: 200,
                        child: TextFormField(
                          readOnly: true,
                          initialValue: widget.jam,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
