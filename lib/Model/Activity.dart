import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  String id;
  String fromUserId;
  Timestamp timestamp;
  bool follow;
  bool likes;

  Activity({
    required this.id,
    required this.fromUserId,
    required this.timestamp,
    required this.follow,
    required this.likes,
  });

  factory Activity.fromDoc(DocumentSnapshot doc) {
    return Activity(
      id: doc.id,
      fromUserId: doc['fromUserId'],
      timestamp: doc['timestamp'],
      follow: doc['follow'],
      likes: doc['likes'],
    );
  }
}
