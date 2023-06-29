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

  String? slectedClient = "0";

  @override
  void initState() {
    _newJam.text = widget.beforeJam ?? '';
    _newtanggal.text = widget.beforeTanggal ?? '';
    namaMatkul = widget.beforeMatkul ?? '';
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
              Row(
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
                ],
              ),
              // Heading Dokumentasi
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Update Dokumentasi",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),

              Text(widget.beforeMatkul!),

              // Form Add Data
              Form(
                key: formkey,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(26),
                  child: Column(
                    children: [
                      // Nama Asisten
                      Container(
                        width: 350,
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Nama',
                            hintText: 'Enter your Name',
                            prefixIcon: Icon(Icons.person_add),
                          ),
                          onSaved: (value) {
                            namaAsisten = value;
                          },
                          initialValue: widget.beforeAsisten,
                        ),
                      ),

                      SizedBox(
                        height: 20,
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
                        height: 20,
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

                      SizedBox(
                        height: 30,
                      ),

                      // Nama Matakuliah
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('matkuls')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }

                          List<DropdownMenuItem> matkulItems = [];

                          final datas = snapshot.data!.docs.reversed.toList();
                          matkulItems.add(
                            DropdownMenuItem(
                              value: "0",
                              child: Text("Select Matkul"),
                            ),
                          );

                          for (var client in datas) {
                            matkulItems.add(
                              DropdownMenuItem(
                                value: client['namaMatkul'],
                                child: Text(
                                  client['namaMatkul'],
                                ),
                              ),
                            );
                          }

                          return DropdownButton(
                            items: matkulItems,
                            onChanged: (value) {
                              namaMatkul = value;
                              setState(() {
                                slectedClient = value;
                              });
                              print(value);
                            },
                            isExpanded: true,
                            value: slectedClient,
                          );
                        },
                      ),

                      // Button Submit
                      SizedBox(
                        height: 50,
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
                                  namaAsisten: namaAsisten!,
                                  namaMatkul: slectedClient!,
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
