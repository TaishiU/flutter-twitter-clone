import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? convoId;
  String? content;
  Map<String, String> images;
  bool hasImage;
  String userFrom;
  String userTo;
  String idFrom;
  String idTo;
  Timestamp timestamp;
  bool read;

  Message({
    this.convoId,
    required this.content,
    required this.images,
    required this.hasImage,
    required this.userFrom,
    required this.userTo,
    required this.idFrom,
    required this.idTo,
    required this.timestamp,
    required this.read,
  });

  factory Message.fromDoc(DocumentSnapshot doc) {
    return Message(
      convoId: doc['convoId'],
      content: doc['content'],
      /* Map型のデータをFirestoreから取得する際は「Map<String,dynamic>.from(snapshot.data["songs"])」とする */
      images: Map<String, String>.from(doc['images']),
      hasImage: doc['hasImage'],
      userFrom: doc['userFrom'],
      userTo: doc['userTo'],
      idFrom: doc['idFrom'],
      idTo: doc['idTo'],
      timestamp: doc['timestamp'],
      read: doc['read'],
    );
  }
}
