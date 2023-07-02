import 'dart:convert';

class DokumentasiModel {
  String? id;
  final String namaMatkul;
  final String tanggal;
  final String jam;
  String? uid;
  String? image;
  DokumentasiModel({
    this.id,
    required this.namaMatkul,
    required this.tanggal,
    required this.jam,
    this.uid,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'namaMatkul': namaMatkul,
      'tanggal': tanggal,
      'jam': jam,
      'uid': uid,
      'image': image,
    };
  }

  factory DokumentasiModel.fromMap(Map<String, dynamic> map) {
    return DokumentasiModel(
      id: map['id'],
      namaMatkul: map['namaMatkul'] ?? '',
      tanggal: map['tanggal'] ?? '',
      jam: map['jam'] ?? '',
      uid: map['uid'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DokumentasiModel.fromJson(String source) =>
      DokumentasiModel.fromMap(json.decode(source));
}
