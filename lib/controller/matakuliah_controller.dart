import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exam_project/model/matakuliah_model.dart';

class MatakuliahController {
  final matakuliahCollection = FirebaseFirestore.instance.collection('matkuls');

  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

  Future addMatkul(MatakuliahModel mkModel) async {
    final matkul = mkModel.toMap();

    final DocumentReference docref = await matakuliahCollection.add(matkul);

    final String docId = docref.id;

    final MatakuliahModel matkulModel = MatakuliahModel(
        id: docId,
        namaMatkul: mkModel.namaMatkul,
        namaDosen: mkModel.namaDosen,
        semester: mkModel.semester);

    await docref.update(matkulModel.toMap());
    await getMatkul();
  }

  Future getMatkul() async {
    final matkul = await matakuliahCollection.get();
    streamController.sink.add(matkul.docs);

    return matkul.docs;
  }

  Future updateMatkul(MatakuliahModel matakuliahModel) async {
    final MatakuliahModel updateMatkul = MatakuliahModel(
        id: matakuliahModel.id,
        namaMatkul: matakuliahModel.namaMatkul,
        namaDosen: matakuliahModel.namaDosen,
        semester: matakuliahModel.semester);

    await matakuliahCollection
        .doc(matakuliahModel.id)
        .update(updateMatkul.toMap());
    await getMatkul();
  }

  Future deleteMatkul(String id) async {
    await matakuliahCollection.doc(id).delete();
    await getMatkul();
  }
}
