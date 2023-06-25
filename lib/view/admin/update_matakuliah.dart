import 'package:final_exam_project/controller/matakuliah_controller.dart';
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
                      'Update Matakuliah',
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
                      onSaved: (value) {
                        newMatkul = value;
                      },
                      initialValue: widget.beforeMatkul,
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
                            formkey.currentState!.save();
                            MatakuliahModel mk = MatakuliahModel(
                                id: widget.id,
                                namaMatkul: newMatkul!,
                                namaDosen: newDosen!,
                                semester: newsemester!);
                            mkctr.updateMatkul(mk);

                            //successful
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Berhasil Update data'),
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
                                  title: const Text('Gagal Update Data'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateMatakuliah()));
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
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
