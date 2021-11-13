import 'package:cloud_firestore/cloud_firestore.dart';

class LastMessage {
  final String? content;
  final String? convoId;
  final String idFrom;
  final String idTo;
  final bool read;
  final Timestamp timestamp;
  final String user1Id;
  final String user1Name;
  final String user1ProfileImage;
  final String user2Id;
  final String user2Name;
  final String user2ProfileImage;
  final String userFrom;
  final String userTo;

  LastMessage({
    required this.content,
    this.convoId,
    required this.idFrom,
    required this.idTo,
    required this.read,
    required this.timestamp,
    required this.user1Id,
    required this.user1Name,
    required this.user1ProfileImage,
    required this.user2Id,
    required this.user2Name,
    required this.user2ProfileImage,
    required this.userFrom,
    required this.userTo,
  });

  factory LastMessage.fromDoc(DocumentSnapshot doc) {
    return LastMessage(
      content: doc['content'],
      convoId: doc['convoId'],
      idFrom: doc['idFrom'],
      idTo: doc['idTo'],
      read: doc['read'],
      timestamp: doc['timestamp'],
      user1Id: doc['user1Id'],
      user1Name: doc['user1Name'],
      user1ProfileImage: doc['user1ProfileImageUrl'],
      user2Id: doc['user2Id'],
      user2Name: doc['user2Name'],
      user2ProfileImage: doc['user2ProfileImageUrl'],
      userFrom: doc['userFrom'],
      userTo: doc['userTo'],
    );
  }
}
