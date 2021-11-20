import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class ListUser {
  final String? userId;
  final String name;
  final String bio;
  final String profileImageUrl;
  final Timestamp timestamp;

  const ListUser({
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
