import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exam_project/controller/dokumentasi_controller.dart';
import 'package:final_exam_project/controller/matakuliah_controller.dart';
import 'package:final_exam_project/model/dokumentasi_model.dart';
import 'package:final_exam_project/view/asisten/add_dokumentasi.dart';
import 'package:final_exam_project/view/asisten/home_asisten.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class UpdateDokumentasi extends StatefulWidget {
  const UpdateDokumentasi(
      {super.key,
      this.id,
      this.beforeAsisten,
      this.beforeMatkul,
      this.beforeTanggal,
      this.beforeJam,
      this.uid});

  // Deklarasi untuk mengambil data sebelumnya
  final String? id;
  final String? uid;
  final String? beforeAsisten;
  final String? beforeMatkul;
  final String? beforeTanggal;
  final String? beforeJam;

  @override
  State<UpdateDokumentasi> createState() => _UpdateDokumentasiState();
}

class _UpdateDokumentasiState extends State<UpdateDokumentasi> {
  // Deklarsi Form dan Controller
  final formkey = GlobalKey<FormState>();
  final dkctr = DokumentasiController();
  final mkctr = MatakuliahController();

  // Firebase auth
  final User? user = FirebaseAuth.instance.currentUser!;

  // Deklarasi variable baru untuk update data
  String? namaAsisten;
  String? namaMatkul;
  String? _newformattanggal;
  String? _newformatjam;

  // Deklarasi variable Controller
  TextEditingController _newtanggal = new TextEditingController();
  TextEditingController _newJam = new TextEditingController();

  @override
  void initState() {
    _newJam.text = widget.beforeJam ?? '';
    _newtanggal.text = widget.beforeTanggal ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      backgroundColor: Colors.blue.shade800,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                height: 60,
                decoration: BoxDecoration(color: Colors.blue.shade800),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        // Back to Home
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeAsisten(),
                          ),
                        );
                      },
                      icon: Icon(Icons.arrow_back),
                      iconSize: 40,
                    ),
                    SizedBox(
                      width: 58,
                    ),
                    Text(
                      "Update Dokumentasi",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Form Add Data
              Form(
                key: formkey,
                child: Container(
                  height: 676,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(26),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      // Nama Matkul yang mau di update
                      Text(
                        widget.beforeMatkul!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(
                        height: 60,
                      ),

                      // Tanggal
                      Container(
                        width: 350,
                        child: TextFormField(
                          controller: _newtanggal,
                          decoration: InputDecoration(
                            labelText: 'Tanggal',
                            hintText: 'Enter your date',
                            prefixIcon: Icon(Icons.calendar_today_rounded),
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickeddate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );

                            _newformattanggal = DateFormat('EEEE, dd MMMM yyyy')
                                .format(pickeddate!)
                                .toString();

                            if (pickeddate != null) {
                              setState(() {
                                _newtanggal.text = _newformattanggal!;
                              });
                            }
                          },
                          onSaved: (newValue) {
                            _newformattanggal = newValue!;
                          },
                        ),
                      ),

                      SizedBox(
                        height: 40,
                      ),

                      // Jam
                      Container(
                        width: 350,
                        child: TextFormField(
                          controller: _newJam,
                          keyboardType: TextInputType.name,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Jam',
                            prefixIcon: IconButton(
                              icon: Icon(Icons.timer),
                              onPressed: () async {
                                var time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now());

                                _newformatjam =
                                    time!.format(context).toString();

                                if (time != null) {
                                  _newJam.text = _newformatjam!;
                                }
                              },
                            ),
                          ),
                          onSaved: (newValue) {
                            _newformatjam = newValue!;
                          },
                        ),
                      ),

                      // Button Submit
                      SizedBox(
                        height: 70,
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: InkWell(
                          onTap: () async {
                            // Save matakuliah Controller
                            if (formkey.currentState!.validate()) {
                              formkey.currentState!.save();
                              DokumentasiModel dk = DokumentasiModel(
                                  id: widget.id,
                                  namaMatkul: widget.beforeMatkul!,
                                  tanggal: _newformattanggal!,
                                  jam: _newformatjam!,
                                  uid: widget.uid);
                              dkctr.updateDokumentasi(dk);

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
                                                      HomeAsisten()));
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
                                                      HomeAsisten()));
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
            ],
          ),
        ),
      ),
    );
  }
}
