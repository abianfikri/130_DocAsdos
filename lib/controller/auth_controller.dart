import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exam_project/model/profile_model.dart';
import 'package:final_exam_project/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Class AuthController bertugas untuk Login dan Logout menggunakan FirebaseFirestore
/// dan menyimpannya kedalam collection users dengan bantun FirebaseAuth
class AuthController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final profileCollection = FirebaseFirestore.instance.collection('profile');

  bool get succes => false;

  /// Method register menggunakan email dan password dengan bantuan Firbase Auth
  Future<UserModel?> registeremailPassword(
      String email, String password, String username, String role) async {
    try {
      final UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;

      if (user != null) {
        final UserModel newUser = UserModel(
            username: username,
            email: user.email ?? '',
            uid: user.uid,
            role: role);

        await userCollection.doc(newUser.uid).set(newUser.toMap());

        final ProfileModel newProfile = ProfileModel(
          uid: user.uid,
          nama: '',
          username: '',
          nim: '',
          semester: '',
          matkul: [''],
        );

        await profileCollection.doc(user.uid).set(newProfile.toMap());

        return newUser;
      }
    } catch (e) {
      print('Error registering user: $e');
    }
  }

  /// Method SignEmail dan password menggunakan firebase Auth
  /// Dengan Parameter pengecekean email dan password serta role
  /// yang disimpan di dalam collection users
  Future<UserModel?> signEmailandPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await auth
          .signInWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;

      if (user != null) {
        final DocumentSnapshot snapshot =
            await userCollection.doc(user.uid).get();

        final UserModel currentUser = UserModel(
            username: snapshot['username'] ?? '',
            email: user.email ?? '',
            uid: user.uid,
            role: snapshot['role']);

        return currentUser;
      }
    } catch (e) {
      print('Error signing in: $e');
    }

    return null;
  }

  /// Mendapatkan informasi getCurrentUser
  UserModel? getCurrentUser() {
    final User? user = auth.currentUser;
    if (user != null) {
      return UserModel.fromFirebaseUser(user);
    }
    return null;
  }

  /// Method untuk logout dari acccount FirebaseAuth
  Future<void> signOut() async {
    await auth.signOut();
  }
}
