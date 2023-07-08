import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exam_project/controller/dokumentasi_controller.dart';
import 'package:final_exam_project/view/admin/detail_dokumentasi.dart';
import 'package:flutter/material.dart';

class ListDokumentasi extends StatefulWidget {
  const ListDokumentasi({super.key, this.listNamaMatkul});
  final String? listNamaMatkul;

  @override
  State<ListDokumentasi> createState() => _ListDokumentasiState();
}

class _ListDokumentasiState extends State<ListDokumentasi> {
  // Deklarasi Variable
  final dkCtr = DokumentasiController(); // Dokumentasi Controller

  String? username;

  Future<String?> getUsername(String uid) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userSnapshot.exists) {
      return userSnapshot['username'];
    }

    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    dkCtr.getDokumentasi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.pink.shade700,
        title: Text("Dokumentasi List"),
      ),
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
                height: 15,
              ),
              Text(
                "${widget.listNamaMatkul}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              // If else disini nanti

              // List Data
              Expanded(
                child: StreamBuilder<List<DocumentSnapshot>>(
                  stream: dkCtr.stream,
                  builder: (context, snapshot) {
                    //
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final List<DocumentSnapshot> data = snapshot.data!;

                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        String uid = data[index]['uid'];
                        String namaMatkul = data[index]['namaMatkul'];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              // Pindah Halaman Detail Dokumentasi
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailDokumentasi(
                                            uid: uid.toString(),
                                            imageUrl:
                                                data[index]['image'].toString(),
                                            jam: data[index]['jam'].toString(),
                                            tanggal: data[index]['tanggal'],
                                            namaMatkul: namaMatkul,
                                          ))).then(
                                (value) {
                                  if (value == true) {
                                    setState(() {
                                      dkCtr.getDokumentasi();
                                    });
                                  }
                                },
                              );
                            },
                            // Pembungkus Card
                            child: FutureBuilder<String?>(
                              future: getUsername(uid),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else {
                                  // Get Username
                                  username = snapshot.data;

                                  if (username != null &&
                                      namaMatkul == widget.listNamaMatkul) {
                                    //
                                    return Container(
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Data Gambar
                                          Row(
                                            children: [
                                              Container(
                                                height: 60,
                                                child: data[index]['image'] !=
                                                        null
                                                    ? Image.network(
                                                        '${data[index]['image'].toString()}')
                                                    : Container(
                                                        child: CircleAvatar(
                                                        backgroundColor:
                                                            Colors.black,
                                                      )),
                                              ),
                                            ],
                                          ),
                                          // Data Nama Asisten dan Tanggal
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Nama Asisten Dosen
                                              Text(
                                                username!, // Updated line: Display the username
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              // Tanggal
                                              Text(
                                                data[index]['tanggal'],
                                                style: TextStyle(
                                                  color: Colors.grey.shade500,
                                                ),
                                              ),
                                              // Jam
                                              Text(
                                                data[index]['jam'],
                                                style: TextStyle(
                                                  color: Colors.grey.shade500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Delete Button
                                          Padding(
                                            padding: const EdgeInsets.all(9.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                // Delete Data Dokumentasi
                                                // Delete
                                                var aa =
                                                    dkCtr.deleteDokumentasi(
                                                        data[index]['id']
                                                            .toString());
                                                if (aa != null) {
                                                  dkCtr
                                                      .deleteDokumentasi(
                                                          data[index]['id']
                                                              .toString())
                                                      .then(
                                                    (value) {
                                                      setState(() {
                                                        dkCtr.getDokumentasi();
                                                      });
                                                    },
                                                  );
                                                  Future.delayed(
                                                          Duration(seconds: 2))
                                                      .then(
                                                    (value) =>
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Dokumentasi Deleted'),
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  //  Failed
                                                  Future.delayed(
                                                          Duration(seconds: 2))
                                                      .then(
                                                    (value) =>
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Dokumentasi Failed to Delete'),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }

                                  return Container();
                                }
                              },
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
