import 'dart:convert';

class DokumentasiModel {
  String? id;
  final String namaAsisten;
  final String namaMatkul;
  final String tanggal;
  final String jam;
  String? uid;
  DokumentasiModel({
    this.id,
    required this.namaAsisten,
    required this.namaMatkul,
    required this.tanggal,
    required this.jam,
    this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'namaAsisten': namaAsisten,
      'namaMatkul': namaMatkul,
      'tanggal': tanggal,
      'jam': jam,
      'uid': uid,
    };
  }

  factory DokumentasiModel.fromMap(Map<String, dynamic> map) {
    return DokumentasiModel(
      id: map['id'],
      namaAsisten: map['namaAsisten'] ?? '',
      namaMatkul: map['namaMatkul'] ?? '',
      tanggal: map['tanggal'] ?? '',
      jam: map['jam'] ?? '',
      uid: map['uid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DokumentasiModel.fromJson(String source) =>
      DokumentasiModel.fromMap(json.decode(source));
}
