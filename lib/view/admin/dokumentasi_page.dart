import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exam_project/controller/matakuliah_controller.dart';
import 'package:final_exam_project/view/admin/list_dokumentasi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DokumentasiPage extends StatefulWidget {
  const DokumentasiPage({super.key});

  @override
  State<DokumentasiPage> createState() => _DokumentasiPageState();
}

class _DokumentasiPageState extends State<DokumentasiPage> {
  // Deklarasi Controller
  final mkctr = MatakuliahController();

  @override
  void initState() {
    // TODO: implement initState
    mkctr.getMatkul();
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
              // List Matakuliah
              Expanded(
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
                        // List data
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              // Pindah Halaman List Dokumentasi
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ListDokumentasi(
                                    listNamaMatkul:
                                        data[index]['namaMatkul'].toString(),
                                  ),
                                ),
                              );
                            },
                            // Pembungkus Card
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Nama Matakuliah
                                      Text(
                                        data[index]['namaMatkul'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // Semester
                                      Text(
                                        "Semester " + data[index]['semester'],
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(9.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        // Pindah Halaman
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ListDokumentasi(
                                              listNamaMatkul: data[index]
                                                      ['namaMatkul']
                                                  .toString(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Icon(Icons.arrow_forward_ios),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
