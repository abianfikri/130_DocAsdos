import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exam_project/model/dokumentasi_model.dart';

/// Class Dokumentasi Controller menyimpan controller tentang program
/// CRUD yang nantinya disimpan kedalam collection dokumens.
/// data yang disimpan dapat berupa upluad foto, uidUser,docID,NamaMatkul,Tanggal,dan Jam.
class DokumentasiController {
  final dokumentasiCollection =
      FirebaseFirestore.instance.collection('dokumens');

  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

  /// Create Dokumentasi
  Future addDokumentasi(DokumentasiModel dkModel) async {
    final dokumen = dkModel.toMap();

    final DocumentReference docref = await dokumentasiCollection.add(dokumen);

    final String docId = docref.id;

    final DokumentasiModel dokumentasiModel = DokumentasiModel(
        id: docId,
        namaMatkul: dkModel.namaMatkul,
        tanggal: dkModel.tanggal,
        jam: dkModel.jam,
        uid: dkModel.uid,
        image: dkModel.image);

    await docref.update(dokumentasiModel.toMap());
    await getDokumentasi();
  }

  /// Get All Dokumentasi
  Future getDokumentasi() async {
    final dokumen = await dokumentasiCollection.get();
    streamController.sink.add(dokumen.docs);

    return dokumen.docs;
  }

  /// UpdateDokumentasi
  Future updateDokumentasi(DokumentasiModel dokumentasiModel) async {
    final DokumentasiModel updateDok = DokumentasiModel(
        id: dokumentasiModel.id,
        namaMatkul: dokumentasiModel.namaMatkul,
        jam: dokumentasiModel.jam,
        tanggal: dokumentasiModel.tanggal,
        image: dokumentasiModel.image,
        uid: dokumentasiModel.uid);

    await dokumentasiCollection
        .doc(dokumentasiModel.id)
        .update(updateDok.toMap());
    await getDokumentasi();
  }

  /// Delete Dokumentasi
  Future deleteDokumentasi(String id) async {
    await dokumentasiCollection.doc(id).delete();
    await getDokumentasi();
  }
}
