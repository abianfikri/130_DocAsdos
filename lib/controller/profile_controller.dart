import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exam_project/model/profile_model.dart';

/// Class ProfileController merupakan sebuah kelas yang mengatur tentang
/// Proses CRUD dari program aplikasi ini. Penyimpannya disimpan kedalam
/// Collection profile, data yang disimpan berupa uid, Nama user, username,
/// nim user, semester, dan nama matakuliah yang di asistenkan oleh user.
/// khusus untuk nama matakulaih yang di asistenkan di simpan menggunakan data Array.
class ProfileController {
  /// Create Collection
  final profileCollection = FirebaseFirestore.instance.collection('profile');

  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

  /// Create Profile
  Future addProfile(ProfileModel prModel) async {
    final ProfileModel profileModel = ProfileModel(
      uid: prModel.uid,
      nama: prModel.nama,
      username: prModel.username,
      nim: prModel.nim,
      semester: prModel.semester,
      matkul: prModel.matkul,
    );

    await profileCollection.doc(prModel.uid).update(profileModel.toMap());
    await getProfile();
  }

  /// Get All Data getProfile or Read Data GetProfile
  Future getProfile() async {
    final profile = await profileCollection.get();
    streamController.sink.add(profile.docs);

    return profile.docs;
  }

  /// GetProfile List using List and DocumentSnapshot
  Future<List<DocumentSnapshot>> getProfileList() async {
    final QuerySnapshot snapshot = await profileCollection.get();
    return snapshot.docs;
  }
}
