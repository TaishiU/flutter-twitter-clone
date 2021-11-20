import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class Tweet {
  final String? tweetId;
  final String authorName;
  final String authorId;
  final String authorBio;
  final String authorProfileImage;
  final String text;
  final Map<String, String> imagesUrl;
  final Map<String, String> imagesPath;
  final bool hasImage;
  final Timestamp timestamp;
  final int likes;
  final int reTweets;

  const Tweet({
    this.tweetId,
    required this.authorName,
    required this.authorId,
    required this.authorBio,
    required this.authorProfileImage,
    required this.text,
    required this.imagesUrl,
    required this.imagesPath,
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
      /* Map型のデータをFirestoreから取得する際は「Map<String,dynamic>.from(snapshot.data["songs"])」とする */
      imagesUrl: Map<String, String>.from(postDoc['imagesUrl']),
      imagesPath: Map<String, String>.from(postDoc['imagesPath']),
      hasImage: postDoc['hasImage'],
      timestamp: postDoc['timestamp'],
      likes: postDoc['likes'],
      reTweets: postDoc['reTweets'],
    );
  }
}
