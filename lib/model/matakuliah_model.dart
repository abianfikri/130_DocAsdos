import 'dart:convert';

class MatakuliahModel {
  String? id;
  final String namaMatkul;
  final String namaDosen;
  final String semester;
  MatakuliahModel({
    this.id,
    required this.namaMatkul,
    required this.namaDosen,
    required this.semester,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'namaMatkul': namaMatkul,
      'namaDosen': namaDosen,
      'semester': semester,
    };
  }

  factory MatakuliahModel.fromMap(Map<String, dynamic> map) {
    return MatakuliahModel(
      id: map['id'],
      namaMatkul: map['namaMatkul'] ?? '',
      namaDosen: map['namaDosen'] ?? '',
      semester: map['semester'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MatakuliahModel.fromJson(String source) =>
      MatakuliahModel.fromMap(json.decode(source));
}
