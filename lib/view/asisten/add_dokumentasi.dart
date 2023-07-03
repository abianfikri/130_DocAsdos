import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exam_project/controller/dokumentasi_controller.dart';
import 'package:final_exam_project/controller/matakuliah_controller.dart';
import 'package:final_exam_project/model/dokumentasi_model.dart';
import 'package:final_exam_project/view/asisten/home_asisten.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddDokumentasi extends StatefulWidget {
  const AddDokumentasi({super.key});

  @override
  State<AddDokumentasi> createState() => _AddDokumentasiState();
}

class _AddDokumentasiState extends State<AddDokumentasi> {
  final formkey = GlobalKey<FormState>();
  final dkctr = DokumentasiController();
  final mkctr = MatakuliahController();

  String? namaMatkul;
  String? imageUrl;
  TextEditingController _tanggal = new TextEditingController();
  TextEditingController _jam = new TextEditingController();

  String? slectedClient = "0";

  final User? user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
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
                      width: 70,
                    ),
                    Text(
                      "Add Dokumentasi",
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
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  height: 675,
                  padding: EdgeInsets.all(26),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),

                      // Tanggal
                      Container(
                        width: 350,
                        child: TextField(
                          controller: _tanggal,
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

                            if (pickeddate != null) {
                              setState(() {
                                _tanggal.text = DateFormat('EEEE, dd MMMM yyy')
                                    .format(pickeddate)
                                    .toString();
                              });
                            }
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
                          keyboardType: TextInputType.name,
                          controller: _jam,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Jam',
                            prefixIcon: Icon(
                              Icons.timer,
                            ),
                          ),
                          onTap: () async {
                            var time = await showTimePicker(
                                context: context, initialTime: TimeOfDay.now());

                            if (time != null) {
                              _jam.text = time.format(context);
                            }
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

                      // Button Upload Gambar
                      SizedBox(
                        height: 20,
                      ),

                      Container(
                        height: 80,
                        width: 60,
                        decoration: BoxDecoration(color: Colors.amber),
                        child: imageUrl != null
                            ? Image.network('${imageUrl}')
                            : Container(),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      InkWell(
                        onTap: () async {
                          //
                          ImagePicker imagePicker = ImagePicker();
                          XFile? file = await imagePicker.pickImage(
                              source: ImageSource.camera);

                          print('${file?.path}');

                          if (file == null) return;

                          String uniqueFileName =
                              DateTime.now().millisecondsSinceEpoch.toString();

                          // Get a reference to storage root
                          Reference referenceRoot =
                              FirebaseStorage.instance.ref();

                          Reference referenceDirImage =
                              referenceRoot.child('images');

                          // create a reference
                          Reference referenceImageToUpload =
                              referenceDirImage.child(uniqueFileName);

                          // Handle error/success
                          try {
                            // Store the file
                            await referenceImageToUpload.putFile(
                              File(file.path),
                            );

                            // success message
                            imageUrl =
                                await referenceImageToUpload.getDownloadURL();

                            setState(() {
                              imageUrl!;
                            });
                          } catch (e) {}
                        },
                        child: Container(
                          width: 300,
                          height: 35,
                          decoration: BoxDecoration(color: Colors.blue),
                          child: Center(
                            child: Text(
                              "Upload Foto",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
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
                              DokumentasiModel dk = DokumentasiModel(
                                  namaMatkul: slectedClient!,
                                  tanggal: _tanggal.text,
                                  jam: _jam.text,
                                  uid: user!.uid,
                                  image: imageUrl);
                              dkctr.addDokumentasi(dk);

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
                                    title: const Text('Gagal menambahkan Data'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddDokumentasi()));
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
