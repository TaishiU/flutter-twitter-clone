import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';

class Auth {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<bool> signUp(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? signedInUser = authResult.user;

      if (signedInUser != null) {
        Firestore().registerUser(
          userId: signedInUser.uid,
          name: name,
          email: email,
          password: password,
        );
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      print('something wrong...');
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void logout() {
    _auth.signOut();
  }
}
