import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';

class Firestore {
  Future<void> updateUserData({required User user}) async {
    await FirebaseFirestore.instance.collection('users').doc(user.id).update({
      'name': user.name,
      'bio': user.bio,
      'profileImage': user.profileImage,
      'coverImage': user.coverImage,
    });
  }

  Future<void> createTweet(Tweet tweet) async {
    tweetRef.doc(tweet.authorId).set({'timestamp': tweet.timestamp});
    DocumentReference tweetReference =
        tweetRef.doc(tweet.authorId).collection('allUserTweets').doc();
    tweetReference.set({
      'tweetId': tweetReference.id,
      'authorName': tweet.authorName,
      'authorId': tweet.authorId,
      'text': tweet.text,
      'image': tweet.image,
      'timestamp': tweet.timestamp,
      'likes': tweet.likes,
      'reTweets': tweet.reTweets,
    });
  }
}
