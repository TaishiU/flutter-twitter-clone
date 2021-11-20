import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class User {
  final String userId;
  final String name;
  final String email;
  final String bio;
  final String profileImageUrl;
  final String profileImagePath;
  final String coverImageUrl;
  final String coverImagePath;
  final String fcmToken;

  const User({
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
