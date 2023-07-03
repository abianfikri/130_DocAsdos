import 'package:final_exam_project/component/gradiant_text.dart';
import 'package:final_exam_project/controller/matakuliah_controller.dart';
import 'package:final_exam_project/main_page.dart';
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
      appBar: AppBar(
        title: Text('Add Matakuliah'),
        centerTitle: true,
        backgroundColor: Colors.pink.shade900,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                  height: 530,
                  width: 370,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      GradientText(
                        'Matakuliah',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue,
                            Colors.red,
                            Colors.black,
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Nama Matkul
                      Container(
                        width: 280,
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Nama Matkul',
                            hintText: 'Enter name matkul',
                          ),
                          onChanged: (value) {
                            namaMatkul = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter Name Matkul";
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Nama Dosen
                      Container(
                        width: 280,
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Nama Dosen',
                            hintText: 'Enter name Dosen',
                          ),
                          onChanged: (value) {
                            namaDosen = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Name Dosen';
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Semester
                      Container(
                        width: 280,
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Semester',
                            hintText: 'Enter semester',
                          ),
                          onChanged: (value) {
                            semester = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Semester';
                            }
                          },
                        ),
                      ),

                      SizedBox(
                        height: 50,
                      ),

                      // Button Add
                      Container(
                        child: InkWell(
                          onTap: () async {
                            // Save matakuliah
                            if (formkey.currentState!.validate()) {
                              MatakuliahModel mk = MatakuliahModel(
                                  namaMatkul: namaMatkul!,
                                  namaDosen: namaDosen!,
                                  semester: semester!);
                              var aa = mkctr.addMatkul(mk);

                              if (aa != null) {
                                Navigator.pop(context, true);
                              }

                              //successful
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title:
                                        const Text('Berhasil Menambahkan data'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
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
                                          Navigator.pop(context);
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
                            width: 250,
                            height: 50,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.purple,
                                      Colors.red,
                                      Colors.orange
                                    ]),
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(
                              child: GradientText(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white,
                                      Colors.white,
                                      Colors.white
                                    ]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
