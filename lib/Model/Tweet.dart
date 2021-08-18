import 'package:cloud_firestore/cloud_firestore.dart';

class Tweet {
  String? tweetId;
  String authorName;
  String authorId;
  String authorProfileImage;
  String text;
  Map<String, String> images;
  bool hasImage;
  Timestamp timestamp;
  int likes;
  int reTweets;

  Tweet({
    this.tweetId,
    required this.authorName,
    required this.authorId,
    required this.authorProfileImage,
    required this.text,
    required this.images,
    required this.hasImage,
    required this.timestamp,
    required this.likes,
    required this.reTweets,
  });

  factory Tweet.fromDoc(DocumentSnapshot postDoc) {
    return Tweet(
      tweetId: postDoc.id,
      authorName: postDoc['authorName'],
      authorId: postDoc['authorId'],
      authorProfileImage: postDoc['authorProfileImage'],
      text: postDoc['text'],
      images: postDoc['images'],
      hasImage: postDoc['hasImage'],
      timestamp: postDoc['timestamp'],
      likes: postDoc['likes'],
      reTweets: postDoc['reTweets'],
    );
  }
}
