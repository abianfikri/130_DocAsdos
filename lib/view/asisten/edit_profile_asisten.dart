import 'package:final_exam_project/component/gradiant_text.dart';
import 'package:final_exam_project/controller/profile_controller.dart';
import 'package:final_exam_project/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class EditProfileAsisten extends StatefulWidget {
  const EditProfileAsisten(
      {super.key,
      this.uid,
      this.username,
      this.beforeNama,
      this.beforeNIM,
      this.beforeSemester,
      this.beforeMatkul});
  final String? uid;
  final String? username;
  final String? beforeNama;
  final String? beforeNIM;
  final String? beforeSemester;
  final List<dynamic>? beforeMatkul;

  @override
  State<EditProfileAsisten> createState() => _EditProfileAsistenState();
}

class _EditProfileAsistenState extends State<EditProfileAsisten> {
  // Deklarasi Controller dan form
  final formkey = GlobalKey<FormState>();
  final pfctr = ProfileController();

  String? nama;
  String? nim;
  String? semester;
  List<String>? matkulAsdos;

  @override
  void initState() {
    // TODO: implement initState
    pfctr.getProfile();
    super.initState();
    nama = widget.beforeNama ?? '';
    nim = widget.beforeNIM ?? '';
    semester = widget.beforeSemester ?? '';
    matkulAsdos = widget.beforeMatkul?.map((item) => item.toString()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profle'),
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
            // Isi Container
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 580,
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
                        'Edit Profile',
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
                      // Nama Lengkap
                      Container(
                        padding: EdgeInsets.all(5.0),
                        width: 280,
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Nama Lengkap',
                            hintText: 'Enter Nama Lengkap',
                          ),
                          onSaved: (value) {
                            nama = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter Nama Lengkap";
                            }
                          },
                          initialValue: widget.beforeNama,
                        ),
                      ),

                      // NIM
                      Container(
                        padding: EdgeInsets.all(5.0),
                        width: 280,
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'NIM',
                            hintText: 'Enter NIM',
                          ),
                          onSaved: (value) {
                            nim = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter NIM';
                            }
                          },
                          initialValue: widget.beforeNIM,
                        ),
                      ),

                      // Semester
                      Container(
                        padding: EdgeInsets.all(5.0),
                        width: 280,
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Semester',
                            hintText: 'Enter semester',
                          ),
                          onSaved: (value) {
                            semester = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Semester';
                            }
                          },
                          initialValue: widget.beforeSemester,
                        ),
                      ),

                      // Asisten Matkul
                      Container(
                        padding: EdgeInsets.all(5.0),
                        width: 280,
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Asisten Matkul',
                            hintText: 'Enter Asisten Matkul',
                          ),
                          onSaved: (value) {
                            matkulAsdos = value!.split(', ');
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Asisten Matkul';
                            }
                          },
                          initialValue: matkulAsdos?.join(', '),
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
                              formkey.currentState!.save();
                              ProfileModel pf = ProfileModel(
                                uid: widget.uid.toString(),
                                username: widget.username.toString(),
                                nama: nama,
                                nim: nim,
                                semester: semester,
                                matkul: matkulAsdos,
                              );

                              var aa = pfctr.addProfile(pf);

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
