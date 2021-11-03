import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_clone/Constants/Constants.dart';

class AuthRepository {
  Future<void> registerUser({
    required String userId,
    required String name,
    required String email,
    required String? fcmToken,
  }) async {
    DocumentReference usersReference = usersRef.doc(userId);
    await usersReference.set({
      'userId': usersReference.id,
      'name': name,
      'email': email,
      'profileImage': '',
      'coverImage': '',
      'bio': '',
      'fcmToken': fcmToken,
    });
  }
}
