import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exam_project/model/dokumentasi_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DokumentasiController {
  final dokumentasiCollection =
      FirebaseFirestore.instance.collection('dokumens');

  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

  // Create Dokumentasi
  Future addDokumentasi(DokumentasiModel dkModel) async {
    final dokumen = dkModel.toMap();

    final DocumentReference docref = await dokumentasiCollection.add(dokumen);

    final String docId = docref.id;

    final DokumentasiModel dokumentasiModel = DokumentasiModel(
        id: docId,
        namaAsisten: dkModel.namaAsisten,
        namaMatkul: dkModel.namaMatkul,
        tanggal: dkModel.tanggal,
        jam: dkModel.jam,
        uid: dkModel.uid);

    await docref.update(dokumentasiModel.toMap());
  }

  // Get All Dokumentasi
  Future getDokumentasi() async {
    final dokumen = await dokumentasiCollection.get();
    streamController.sink.add(dokumen.docs);

    return dokumen.docs;
  }
}
