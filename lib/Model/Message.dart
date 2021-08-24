import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String? convoId;
  final String content;
  final String userFrom;
  final String userTo;
  final String idFrom;
  final String idTo;
  final Timestamp timestamp;
  final bool read;

  Message({
    this.convoId,
    required this.content,
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
      userFrom: doc['userFrom'],
      userTo: doc['userTo'],
      idFrom: doc['idFrom'],
      idTo: doc['idTo'],
      timestamp: doc['timestamp'],
      read: doc['read'],
    );
  }
}
