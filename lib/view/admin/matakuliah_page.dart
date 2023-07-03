import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exam_project/controller/auth_controller.dart';
import 'package:final_exam_project/controller/matakuliah_controller.dart';
import 'package:final_exam_project/model/user_model.dart';
import 'package:final_exam_project/view/admin/add_matakuliah.dart';
import 'package:final_exam_project/view/admin/update_matakuliah.dart';
import 'package:final_exam_project/view/halaman_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MatakuliahPage extends StatefulWidget {
  const MatakuliahPage({super.key});

  @override
  State<MatakuliahPage> createState() => _MatakuliahPageState();
}

class _MatakuliahPageState extends State<MatakuliahPage> {
  var mkctr = MatakuliahController();
  final autctr = AuthController();

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
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
                        Color avatarColor;

                        // Menentukan warna lingkaran avatar berdasarkan semester
                        switch (data[index]['semester']) {
                          case '1':
                            avatarColor = Colors.blue;
                            break;
                          case '2':
                            avatarColor = Colors.deepOrange;
                            break;
                          case '3':
                            avatarColor = Colors.green;
                            break;
                          case '4':
                            avatarColor = Colors.pink;
                            break;
                          case '5':
                            avatarColor = Colors.indigo;
                            break;
                          case '6':
                            avatarColor = Colors.orangeAccent;
                            break;
                          case '7':
                            avatarColor = Colors.teal;
                            break;
                          case '8':
                            avatarColor = Colors.red;
                            break;
                          case '9':
                            avatarColor = Colors.amber;
                            break;
                          default:
                            avatarColor = Colors.grey;
                        }

                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: InkWell(
                            onLongPress: () {
                              // Update
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateMatakuliah(
                                    beforeDosen:
                                        data[index]['namaDosen'].toString(),
                                    beforeMatkul:
                                        data[index]['namaMatkul'].toString(),
                                    beforesemester:
                                        data[index]['semester'].toString(),
                                    id: data[index]['id'].toString(),
                                  ),
                                ),
                              ).then(
                                (value) {
                                  if (value == true) {
                                    setState(() {
                                      mkctr.getMatkul();
                                    });
                                  }
                                },
                              );
                            },
                            child: Card(
                              elevation: 10,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: avatarColor,
                                ),
                                title: Text(
                                  data[index]['namaMatkul'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle:
                                    Text('Semester ' + data[index]['semester']),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    // Delete
                                    var aa = mkctr.deleteMatkul(
                                        data[index]['id'].toString());
                                    if (mkctr.deleteMatkul(
                                            data[index]['id'].toString()) !=
                                        null) {
                                      mkctr
                                          .deleteMatkul(
                                              data[index]['id'].toString())
                                          .then(
                                        (value) {
                                          setState(() {
                                            mkctr.getMatkul();
                                          });
                                        },
                                      );
                                      Future.delayed(Duration(seconds: 2)).then(
                                        (value) => ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Matakuliah Deleted'),
                                          ),
                                        ),
                                      );
                                    } else {
                                      //  Failed
                                      Future.delayed(Duration(seconds: 2)).then(
                                        (value) => ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Matakulaih Failed to Delete'),
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
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMatakuliah()),
          ).then(
            (value) {
              if (value == true) {
                setState(() {
                  mkctr.getMatkul();
                });
              }
            },
          );
        },
        heroTag: null,
        child: const Icon(Icons.add),
      ),
    );
  }
}
