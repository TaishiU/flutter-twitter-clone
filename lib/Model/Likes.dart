import 'package:cloud_firestore/cloud_firestore.dart';

class Likes {
  String likesUserId;
  String likesUserName;
  String likesUserProfileImage;
  String likesUserBio;
  Timestamp timestamp;

  Likes({
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
