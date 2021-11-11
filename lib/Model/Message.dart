import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? convoId;
  String? content;
  Map<String, String> imagesUrl;
  Map<String, String> imagesPath;
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
