import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  String activityId;
  String fromUserId;
  Timestamp timestamp;
  bool follow;
  bool likes;
  bool comment;
  String tweetId;

  Activity({
    required this.activityId,
    required this.fromUserId,
    required this.timestamp,
    required this.follow,
    required this.likes,
    required this.comment,
    required this.tweetId,
  });

  factory Activity.fromDoc(DocumentSnapshot doc) {
    return Activity(
      activityId: doc.id,
      fromUserId: doc['fromUserId'],
      timestamp: doc['timestamp'],
      follow: doc['follow'],
      likes: doc['likes'],
      comment: doc['comment'],
      tweetId: doc['tweetId'],
    );
  }
}
