import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

/// Class userModel merupakan class yang menyimpan data-data yang dibutuhkan untuk proses login dan register.
/// data tersebut akan disimpan di dalam collection users dengan bantun FirebaseAuth nantinya.
/// Data yang disimpan berupa username, email, uid, dan role user. role user disini sangat berperan penting
/// dalam mendeteksi role user mana yang sedang melakukan login.
class UserModel {
  String username;
  String email;
  String uid;
  String role;
  UserModel({
    required this.username,
    required this.email,
    required this.uid,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'uid': uid,
      'role': role,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      uid: map['uid'] ?? '',
      role: map['role'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  static UserModel? fromFirebaseUser(User user) {}
}
