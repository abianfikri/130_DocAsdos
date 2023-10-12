import 'dart:convert';

/// Class Profile Model untuk menyimpan data-data yang nantinya akan disimpan kedalam collection Profile.
/// Data yang disimpan dapat berupa String dan List. Data yang disimpan meliputi,
/// uid, nama user, username, nim, semester, array list nama Matkul
class ProfileModel {
  String? uid;
  String? nama;
  String? username;
  String? nim;
  String? semester;
  List<String>? matkul;
  ProfileModel({
    this.uid,
    this.nama,
    this.username,
    this.nim,
    this.semester,
    this.matkul,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nama': nama,
      'username': username,
      'nim': nim,
      'semester': semester,
      'matkul': matkul,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      uid: map['uid'],
      nama: map['nama'],
      username: map['username'],
      nim: map['nim'],
      semester: map['semester'],
      matkul: List<String>.from(map['matkul']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) =>
      ProfileModel.fromMap(json.decode(source));
}
