import 'package:cloud_firestore/cloud_firestore.dart';

class Tweet {
  String? tweetId;
  String authorName;
  String authorId;
  String authorBio;
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
    required this.authorBio,
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
      authorBio: postDoc['authorBio'],
      authorProfileImage: postDoc['authorProfileImage'],
      text: postDoc['text'],
      images: Map<String, String>.from(postDoc['images']),
      /* Map型のデータをFirestoreから取得する際は「Map<String,dynamic>.from(snapshot.data["songs"])」とする */
      hasImage: postDoc['hasImage'],
      timestamp: postDoc['timestamp'],
      likes: postDoc['likes'],
      reTweets: postDoc['reTweets'],
    );
  }
}
