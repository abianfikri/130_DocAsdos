import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exam_project/model/profile_model.dart';

class ProfileController {
  // Create Collection
  final profileCollection = FirebaseFirestore.instance.collection('profile');

  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

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

  Future getProfile() async {
    final profile = await profileCollection.get();
    streamController.sink.add(profile.docs);

    return profile.docs;
  }

  Future<List<DocumentSnapshot>> getProfileList() async {
    final QuerySnapshot snapshot = await profileCollection.get();
    return snapshot.docs;
  }
}
