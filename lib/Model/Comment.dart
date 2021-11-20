import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class Comment {
  final String? commentId;
  final String commentUserId;
  final String commentUserName;
  final String commentUserProfileImage;
  final String commentUserBio;
  final String commentText;
  final Timestamp timestamp;

  const Comment({
    this.commentId,
    required this.commentUserId,
    required this.commentUserName,
    required this.commentUserProfileImage,
    required this.commentUserBio,
    required this.commentText,
    required this.timestamp,
  });

  factory Comment.fromDoc(DocumentSnapshot commentDoc) {
    return Comment(
      commentId: commentDoc['commentId'],
      commentUserId: commentDoc['commentUserId'],
      commentUserName: commentDoc['commentUserName'],
      commentUserProfileImage: commentDoc['commentUserProfileImage'],
      commentUserBio: commentDoc['commentUserBio'],
      commentText: commentDoc['commentText'],
      timestamp: commentDoc['timestamp'],
    );
  }
}
