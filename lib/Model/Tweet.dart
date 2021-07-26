import 'package:cloud_firestore/cloud_firestore.dart';

class Tweet {
  String? tweetId;
  String authorName;
  String authorId;
  String text;
  String image;
  bool hasImage;
  Timestamp timestamp;
  int likes;
  int reTweets;

  Tweet({
    this.tweetId,
    required this.authorName,
    required this.authorId,
    required this.text,
    required this.image,
    required this.hasImage,
    required this.timestamp,
    required this.likes,
    required this.reTweets,
  });

  factory Tweet.fromDoc(DocumentSnapshot doc) {
    return Tweet(
      tweetId: doc.id,
      authorName: doc['authorName'],
      authorId: doc['authorId'],
      text: doc['text'],
      image: doc['image'],
      hasImage: doc['hasImage'],
      timestamp: doc['timestamp'],
      likes: doc['likes'],
      reTweets: doc['reTweets'],
    );
  }
}
