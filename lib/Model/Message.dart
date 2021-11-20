import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class Message {
  final String? convoId;
  final String? content;
  final Map<String, String> imagesUrl;
  final Map<String, String> imagesPath;
  final bool hasImage;
  final String userFrom;
  final String userTo;
  final String idFrom;
  final String idTo;
  final Timestamp timestamp;
  final bool read;

  const Message({
    this.convoId,
    required this.content,
    required this.imagesUrl,
    required this.imagesPath,
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
      imagesUrl: Map<String, String>.from(doc['imagesUrl']),
      imagesPath: Map<String, String>.from(doc['imagesPath']),
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
