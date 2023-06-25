import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exam_project/controller/auth_controller.dart';
import 'package:final_exam_project/controller/matakuliah_controller.dart';
import 'package:final_exam_project/model/user_model.dart';
import 'package:final_exam_project/view/admin/add_matakuliah.dart';
import 'package:final_exam_project/view/admin/home_admin.dart';
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
    super.initState();
    mkctr.getMatkul();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    height: 85,
                    child: FloatingActionButton(
                      child: Icon(Icons.arrow_back),
                      backgroundColor: Colors.deepOrange,
                      onPressed: () async {
                        autctr.getCurrentUser();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeAdmin(),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                'Matakuliah List',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                            );
                          },
                          child: Card(
                            elevation: 10,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.black,
                              ),
                              title: Text(data[index]['namaMatkul']),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddMatakuliah()));
        },
        heroTag: null,
        child: const Icon(Icons.add),
      ),
    );
  }
}
