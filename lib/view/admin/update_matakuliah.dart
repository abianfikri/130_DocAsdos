import 'package:final_exam_project/component/gradiant_text.dart';
import 'package:final_exam_project/controller/matakuliah_controller.dart';
import 'package:final_exam_project/main_page.dart';
import 'package:final_exam_project/model/matakuliah_model.dart';
import 'package:final_exam_project/view/admin/matakuliah_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class UpdateMatakuliah extends StatefulWidget {
  const UpdateMatakuliah(
      {super.key,
      this.id,
      this.beforeMatkul,
      this.beforeDosen,
      this.beforesemester});
  final String? id;
  final String? beforeMatkul;
  final String? beforeDosen;
  final String? beforesemester;

  @override
  State<UpdateMatakuliah> createState() => _UpdateMatakuliahState();
}

class _UpdateMatakuliahState extends State<UpdateMatakuliah> {
  final formkey = GlobalKey<FormState>();
  final mkctr = MatakuliahController();

  String? newMatkul;
  String? newDosen;
  String? newsemester;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.beforeMatkul;
    widget.beforeDosen;
    widget.beforesemester;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Matakuliah'),
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
              children: [
                SizedBox(
                  height: 30,
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
                      Container(
                        padding: EdgeInsets.all(20),
                        child: GradientText(
                          'Update Matakuliah',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue,
                              Colors.red,
                              Colors.black,
                            ],
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
                          onSaved: (value) {
                            newMatkul = value;
                          },
                          initialValue: widget.beforeMatkul,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Name Matkul';
                            }
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
                          onSaved: (value) {
                            newDosen = value;
                          },
                          initialValue: widget.beforeDosen,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Name Dosen';
                            }
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
                          onSaved: (value) {
                            newsemester = value;
                          },
                          initialValue: widget.beforesemester,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Semester';
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: InkWell(
                          onTap: () async {
                            // Save matakuliah
                            if (formkey.currentState!.validate()) {
                              formkey.currentState!.save();
                              MatakuliahModel mk = MatakuliahModel(
                                  id: widget.id,
                                  namaMatkul: newMatkul!,
                                  namaDosen: newDosen!,
                                  semester: newsemester!);
                              mkctr.updateMatkul(mk);

                              Navigator.pop(context, true);

                              //successful
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Berhasil Update data'),
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
                                    title: const Text('Gagal Update Data'),
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
                      )
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
