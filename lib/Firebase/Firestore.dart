import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_clone/Model/User.dart';

class Firestore {
  Future<void> updateUserData({required User user}) async {
    await FirebaseFirestore.instance.collection('users').doc(user.id).update({
      'name': user.name,
      'bio': user.bio,
      'profileImage': user.profileImage,
      'coverImage': user.coverImage,
    });
  }
}
