import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class Activity {
  final String activityId;
  final String fromUserId;
  final Timestamp timestamp;
  final bool follow;
  final bool likes;
  final bool comment;
  final String tweetId;

  const Activity({
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
