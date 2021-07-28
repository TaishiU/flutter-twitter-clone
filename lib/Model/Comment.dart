import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String? commentId;
  String commentUserId;
  String commentUserName;
  String commentUserProfileImage;
  String commentText;
  Timestamp timestamp;

  Comment({
    this.commentId,
    required this.commentUserId,
    required this.commentUserName,
    required this.commentUserProfileImage,
    required this.commentText,
    required this.timestamp,
  });

  factory Comment.fromDoc(DocumentSnapshot commentDoc) {
    return Comment(
      commentId: commentDoc['commentId'],
      commentUserId: commentDoc['commentUserId'],
      commentUserName: commentDoc['commentUserName'],
      commentUserProfileImage: commentDoc['commentUserProfileImage'],
      commentText: commentDoc['commentText'],
      timestamp: commentDoc['timestamp'],
    );
  }
}
