import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exam_project/component/gradiant_text.dart';
import 'package:final_exam_project/controller/dokumentasi_controller.dart';
import 'package:final_exam_project/controller/matakuliah_controller.dart';
import 'package:final_exam_project/model/dokumentasi_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

/// Class AddDokumentasi merupakan class yang bertugas untuk create data yanng dibutuhkan dalam membuat dokumenatsi.
/// data yang dibutuhkan berupa namaMatkul, gambarm, tanggal, jam, username, dan uid user yang login.
class AddDokumentasi extends StatefulWidget {
  const AddDokumentasi({super.key});

  @override
  State<AddDokumentasi> createState() => _AddDokumentasiState();
}

/// Pada class ini akan menerapkan Firebase AuthController yang mana data uid user akan otomatis tersimpan kedalama
/// collecion DOkumentasi. fungsi lain yang digunakan adalah Dokumentasi controller, matakuliah Controller, dan form
/// Pada class ini ada tampilan untuk textformField, image, dan button upload and submit
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
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 580,
                  width: 360,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        child: GradientText(
                          'Dokumentasi',
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
                      // Display Image
                      Container(
                        width: 90,
                        child: imageUrl != null
                            ? Image.network('${imageUrl}')
                            : Container(),
                      ),
                      // Tanggal
                      Container(
                        padding: EdgeInsets.all(5.0),
                        width: 300,
                        child: TextFormField(
                          controller: _tanggal,
                          decoration: InputDecoration(
                            labelText: 'Tanggal',
                            hintText: 'Enter your date',
                            suffixIcon: Icon(Icons.calendar_today_rounded),
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Tanggal';
                            }
                          },
                        ),
                      ),

                      // Jam
                      Container(
                        padding: EdgeInsets.all(5.0),
                        width: 300,
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          controller: _jam,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Jam',
                            suffixIcon: Icon(
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Jam';
                            }
                          },
                        ),
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

                          return Container(
                            padding: EdgeInsets.all(5.0),
                            width: 300,
                            child: DropdownButtonFormField(
                              items: matkulItems,
                              onChanged: (value) {
                                setState(() {
                                  namaMatkul = value;
                                  slectedClient = value;
                                });
                                print(value);
                              },
                              validator: (value) {
                                if (value!.isEmpty || value == '0') {
                                  return 'Please Select Matkul';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Nama Matakuliah',
                              ),
                              isExpanded: true,
                              value: slectedClient,
                            ),
                          );
                        },
                      ),

                      SizedBox(
                        height: 30,
                      ),

                      // Button Upload Gambar
                      InkWell(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Upload Gambar'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Text('Camera'),
                                        onTap: () {
                                          _uploadImage(ImageSource.camera);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      GestureDetector(
                                        child: Text('Gallery'),
                                        onTap: () {
                                          _uploadImage(ImageSource.gallery);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
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

                      SizedBox(
                        height: 5,
                      ),

                      // Button submit save
                      Container(
                        padding: EdgeInsets.all(17.0),
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

                              Navigator.pop(context, true);

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
                            padding: EdgeInsets.all(15.0),
                            width: 250,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFF8A2387),
                                    Color(0xFFE94057),
                                    Color(0xFFF27121),
                                  ],
                                ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method Upload
  Future<void> _uploadImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Get a reference to storage root
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImage = referenceRoot.child('images');

      // create a reference
      Reference referenceImageToUpload =
          referenceDirImage.child(uniqueFileName);

      // Handle error/success
      try {
        // Store the file
        await referenceImageToUpload.putFile(
          File(pickedImage.path),
        );

        // success message
        imageUrl = await referenceImageToUpload.getDownloadURL();

        setState(() {
          imageUrl!;
        });
      } catch (e) {
        print(e);
      }
    }
  }
}
