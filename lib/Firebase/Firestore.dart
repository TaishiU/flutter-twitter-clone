import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';

class Firestore {
  Future<void> registerUser({
    required String userId,
    required String name,
    required String email,
    required String password,
  }) async {
    DocumentReference usersReference = usersRef.doc(userId);
    await usersReference.set({
      'userId': usersReference.id,
      'name': name,
      'email': email,
      'password': password,
      'profileImage': '',
      'coverImage': '',
      'bio': '',
    });
  }

  Future<DocumentSnapshot> getUserProfile({
    required String userId,
  }) async {
    DocumentSnapshot userProfileDoc = await usersRef.doc(userId).get();
    return userProfileDoc;
  }

  Future<void> updateUserData({required User user}) async {
    await usersRef.doc(user.userId).update({
      'name': user.name,
      'bio': user.bio,
      'profileImage': user.profileImage,
      'coverImage': user.coverImage,
    });
  }

  Future<void> createTweet(Tweet tweet) async {
    DocumentReference tweetReference =
        tweetRef.doc(tweet.authorId).collection('allUserTweets').doc();
    await tweetReference.set({
      'tweetId': tweetReference.id,
      'authorName': tweet.authorName,
      'authorId': tweet.authorId,
      'authorProfileImage': tweet.authorProfileImage,
      'text': tweet.text,
      'image': tweet.image,
      'hasImage': tweet.hasImage,
      'timestamp': tweet.timestamp,
      'likes': tweet.likes,
      'reTweets': tweet.reTweets,
    });

    DocumentReference allTweetsReference = allTweetsRef.doc();
    await allTweetsReference.set({
      'tweetId': allTweetsReference.id,
      'authorName': tweet.authorName,
      'authorId': tweet.authorId,
      'authorProfileImage': tweet.authorProfileImage,
      'text': tweet.text,
      'image': tweet.image,
      'hasImage': tweet.hasImage,
      'timestamp': tweet.timestamp,
      'likes': tweet.likes,
      'reTweets': tweet.reTweets,
    });
  }

  Future<void> deleteTweet(
      {required String userId, required String postId}) async {
    await tweetRef.doc(userId).collection('allUserTweets').doc(postId).delete();
  }
}
