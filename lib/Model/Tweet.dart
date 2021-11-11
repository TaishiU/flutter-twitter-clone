import 'package:cloud_firestore/cloud_firestore.dart';

class Tweet {
  String? tweetId;
  String authorName;
  String authorId;
  String authorBio;
  String authorProfileImage;
  String text;
  Map<String, String> imagesUrl;
  Map<String, String> imagesPath;
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
