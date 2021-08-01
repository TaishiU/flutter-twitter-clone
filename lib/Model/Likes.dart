import 'package:cloud_firestore/cloud_firestore.dart';

class Likes {
  String? likesId;
  String likesUserId;
  String likesUserName;
  String likesUserProfileImage;
  String likesUserBio;
  Timestamp timestamp;

  Likes({
    this.likesId,
    required this.likesUserId,
    required this.likesUserName,
    required this.likesUserProfileImage,
    required this.likesUserBio,
    required this.timestamp,
  });

  factory Likes.fromDoc(DocumentSnapshot likesDoc) {
    return Likes(
      likesId: likesDoc.id,
      likesUserId: likesDoc['likesUserId'],
      likesUserName: likesDoc['likesUserName'],
      likesUserProfileImage: likesDoc['likesUserProfileImage'],
      likesUserBio: likesDoc['likesUserBio'],
      timestamp: likesDoc['timestamp'],
    );
  }
}
