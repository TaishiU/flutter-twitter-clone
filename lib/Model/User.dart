import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String name;
  String email;
  String bio;
  String profileImage;
  String coverImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.bio,
    required this.profileImage,
    required this.coverImage,
  });

  factory User.fromDoc(DocumentSnapshot doc) {
    return User(
      id: doc.id,
      name: doc['name'],
      email: doc['email'],
      bio: doc['bio'],
      profileImage: doc['profileImage'],
      coverImage: doc['coverImage'],
    );
  }
}
