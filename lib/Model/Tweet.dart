import 'package:cloud_firestore/cloud_firestore.dart';

class Tweet {
  String id;
  String authorName;
  String authorId;
  String text;
  String image;
  Timestamp timestamp;
  int likes;
  int reTweets;

  Tweet({
    required this.id,
    required this.authorName,
    required this.authorId,
    required this.text,
    required this.image,
    required this.timestamp,
    required this.likes,
    required this.reTweets,
  });

  factory Tweet.fromDoc(DocumentSnapshot doc) {
    return Tweet(
      id: doc.id,
      authorName: doc['authorName'],
      authorId: doc['authorId'],
      text: doc['text'],
      image: doc['image'],
      timestamp: doc['timestamp'],
      likes: doc['likes'],
      reTweets: doc['reTweets'],
    );
  }
}
