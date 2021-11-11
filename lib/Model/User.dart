import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String userId;
  String name;
  String email;
  String bio;
  String profileImageUrl;
  String profileImagePath;
  String coverImageUrl;
  String coverImagePath;
  String fcmToken;

  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.bio,
    required this.profileImageUrl,
    required this.profileImagePath,
    required this.coverImageUrl,
    required this.coverImagePath,
    required this.fcmToken,
  });

  factory User.fromDoc(DocumentSnapshot doc) {
    return User(
      userId: doc.id,
      name: doc['name'],
      email: doc['email'],
      bio: doc['bio'],
      profileImageUrl: doc['profileImageUrl'],
      profileImagePath: doc['profileImagePath'],
      coverImageUrl: doc['coverImageUrl'],
      coverImagePath: doc['coverImagePath'],
      fcmToken: doc['fcmToken'],
    );
  }

  factory User.fromAlgolia(Map<String, dynamic> data) {
    return User(
      userId: data['userId'],
      name: data['name'],
      email: data['email'],
      bio: data['bio'],
      profileImageUrl: data['profileImageUrl'],
      profileImagePath: data['profileImagePath'],
      coverImageUrl: data['coverImageUrl'],
      coverImagePath: data['coverImagePath'],
      fcmToken: data['fcmToken'],
    );
  }
}
