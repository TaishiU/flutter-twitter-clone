import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String userId;
  String name;
  String email;
  String bio;
  String profileImage;
  String coverImage;
  String fcmToken;

  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.bio,
    required this.profileImage,
    required this.coverImage,
    required this.fcmToken,
  });

  factory User.fromDoc(DocumentSnapshot doc) {
    return User(
      userId: doc.id,
      name: doc['name'],
      email: doc['email'],
      bio: doc['bio'],
      profileImage: doc['profileImage'],
      coverImage: doc['coverImage'],
      fcmToken: doc['fcmToken'],
    );
  }

  factory User.fromAlgolia(Map<String, dynamic> data) {
    return User(
      userId: data['userId'],
      name: data['name'],
      email: data['email'],
      bio: data['bio'],
      profileImage: data['profileImage'],
      coverImage: data['coverImage'],
      fcmToken: data['fcmToken'],
    );
  }
}
