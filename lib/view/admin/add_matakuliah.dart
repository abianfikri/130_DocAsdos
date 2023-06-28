import 'package:final_exam_project/controller/matakuliah_controller.dart';
import 'package:final_exam_project/model/matakuliah_model.dart';
import 'package:final_exam_project/view/admin/matakuliah_page.dart';
import 'package:final_exam_project/view/halaman_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddMatakuliah extends StatefulWidget {
  const AddMatakuliah({super.key});

  @override
  State<AddMatakuliah> createState() => _AddMatakuliahState();
}

class _AddMatakuliahState extends State<AddMatakuliah> {
  final formkey = GlobalKey<FormState>();
  final mkctr = MatakuliahController();

  String? namaMatkul;
  String? namaDosen;
  String? semester;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade800,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Container(
              height: 735,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  Row(
                    children: [
                      FloatingActionButton(
                        child: Icon(Icons.arrow_back),
                        backgroundColor: Colors.deepOrange,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MatakuliahPage()));
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Tambah Matakuliah',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    width: 350,
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'Nama Matkul',
                        hintText: 'Enter name matkul',
                      ),
                      onChanged: (value) {
                        namaMatkul = value;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    width: 350,
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'Nama Dosen',
                        hintText: 'Enter name Dosen',
                      ),
                      onChanged: (value) {
                        namaDosen = value;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    width: 350,
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'Semester',
                        hintText: 'Enter semester',
                      ),
                      onChanged: (value) {
                        semester = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: InkWell(
                      onTap: () async {
                        // Save matakuliah
                        if (formkey.currentState!.validate()) {
                          MatakuliahModel mk = MatakuliahModel(
                              namaMatkul: namaMatkul!,
                              namaDosen: namaDosen!,
                              semester: semester!);
                          mkctr.addContact(mk);

                          //successful
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Berhasil Menambahkan data'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MatakuliahPage()));
                                      // Navigate to the next screen or perform any desired action
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          //  Failed
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Gagal menambahkan Data'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddMatakuliah()));
                                      // Navigate to the next screen or perform any desired action
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
