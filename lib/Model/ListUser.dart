import 'package:cloud_firestore/cloud_firestore.dart';

class ListUser {
  String? userId;
  String name;
  String bio;
  String profileImageUrl;
  Timestamp timestamp;

  ListUser({
    this.userId,
    required this.name,
    required this.bio,
    required this.profileImageUrl,
    required this.timestamp,
  });

  factory ListUser.fromDoc(DocumentSnapshot doc) {
    return ListUser(
      userId: doc.id,
      name: doc['name'],
      bio: doc['bio'],
      profileImageUrl: doc['profileImageUrl'],
      timestamp: doc['timestamp'],
    );
  }
}
