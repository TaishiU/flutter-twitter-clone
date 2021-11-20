import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class Likes {
  final String likesUserId;
  final String likesUserName;
  final String likesUserProfileImage;
  final String likesUserBio;
  final Timestamp timestamp;

  const Likes({
    required this.likesUserId,
    required this.likesUserName,
    required this.likesUserProfileImage,
    required this.likesUserBio,
    required this.timestamp,
  });

  factory Likes.fromDoc(DocumentSnapshot likesDoc) {
    return Likes(
      likesUserId: likesDoc['likesUserId'],
      likesUserName: likesDoc['likesUserName'],
      likesUserProfileImage: likesDoc['likesUserProfileImage'],
      likesUserBio: likesDoc['likesUserBio'],
      timestamp: likesDoc['timestamp'],
    );
  }
}
