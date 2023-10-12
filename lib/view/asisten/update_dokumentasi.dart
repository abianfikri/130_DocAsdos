import 'dart:io';

import 'package:final_exam_project/component/gradiant_text.dart';
import 'package:final_exam_project/controller/dokumentasi_controller.dart';
import 'package:final_exam_project/controller/matakuliah_controller.dart';
import 'package:final_exam_project/model/dokumentasi_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

/// Class ini digunakan untuk update data Dokumentasi yang telahh di buat oleh Asisten.
/// data yang di udpdate menggunakan form update lalu disimpan kembali kedalam collection yang sudah ada.
class UpdateDokumentasi extends StatefulWidget {
  const UpdateDokumentasi(
      {super.key,
      this.id,
      this.beforeMatkul,
      this.beforeTanggal,
      this.beforeJam,
      this.uid,
      this.beforeImage});

  // Deklarasi untuk mengambil data sebelumnya
  final String? id;
  final String? uid;
  final String? beforeMatkul;
  final String? beforeTanggal;
  final String? beforeJam;
  final String? beforeImage;

  @override
  State<UpdateDokumentasi> createState() => _UpdateDokumentasiState();
}

/// Fungsi yang digunakan dalam class ini adalah  dokumenatsiController, MatakuliahController dan FirebaseAuth
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
  String? newImageUrl;

  // Deklarasi variable Controller
  TextEditingController _newtanggal = new TextEditingController();
  TextEditingController _newJam = new TextEditingController();

  @override
  void initState() {
    _newJam.text = widget.beforeJam ?? '';
    _newtanggal.text = widget.beforeTanggal ?? '';
    newImageUrl = widget.beforeImage ?? '';
    super.initState();
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
                      SizedBox(
                        height: 20,
                      ),
                      // Nama Matkul yang mau di update
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GradientText(
                          widget.beforeMatkul!,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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
                        padding: EdgeInsets.all(5.0),
                        width: 100,
                        child: newImageUrl != null
                            ? Image.network('${newImageUrl}')
                            : Container(),
                      ),

                      // Tanggal
                      Container(
                        padding: EdgeInsets.all(8.0),
                        width: 300,
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

                            if (pickeddate != null) {
                              _newformattanggal =
                                  DateFormat('EEEE, dd MMMM yyyy')
                                      .format(pickeddate)
                                      .toString();
                              setState(() {
                                _newtanggal.text = _newformattanggal!;
                              });
                            } else {
                              _newformattanggal = widget.beforeTanggal!;
                            }
                          },
                          onSaved: (newValue) {
                            _newformattanggal = newValue!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Tanggal';
                            }
                          },
                        ),
                      ),

                      // Jam
                      Container(
                        padding: EdgeInsets.all(8.0),
                        width: 300,
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Jam';
                            }
                          },
                        ),
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
                        height: 20,
                      ),
                      // Button Submit
                      Container(
                        padding: EdgeInsets.all(20),
                        child: InkWell(
                          onTap: () async {
                            // Save matakuliah Controller
                            if (formkey.currentState!.validate()) {
                              formkey.currentState!.save();
                              DokumentasiModel dk = DokumentasiModel(
                                id: widget.id,
                                uid: widget.uid,
                                namaMatkul: widget.beforeMatkul!,
                                tanggal: _newformattanggal!,
                                jam: _newformatjam!,
                                image: newImageUrl,
                              );
                              dkctr.updateDokumentasi(dk);

                              Navigator.pop(context, true);

                              //successful
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                        'Berhasil Update Dokumentasi'),
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
                                    title:
                                        const Text('Gagal Update Dokumentasi'),
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
        final imageUrl = await referenceImageToUpload.getDownloadURL();

        setState(() {
          newImageUrl = imageUrl;
        });
      } catch (e) {
        print(e);
      }
    }
  }
}
