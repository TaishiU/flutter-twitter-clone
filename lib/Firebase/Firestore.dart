import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Comment.dart';
import 'package:twitter_clone/Model/Likes.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';

class Firestore {
  /*プロフィール関連*/
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

  Future<QuerySnapshot> searchUsers({required String name}) async {
    QuerySnapshot users = await usersRef
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThan: name + 'z')
        .get();
    return users;
  }

  Future<void> followUser(
      {required User followingUser, required User followersUser}) async {
    /*フォローする側*/
    DocumentReference followingReference = usersRef
        .doc(followingUser.userId)
        .collection('following')
        .doc(followersUser.userId);
    await followingReference.set({
      'userId': followersUser.userId,
      'name': followersUser.name,
      'profileImage': followersUser.profileImage,
      'bio': followersUser.bio,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });

    /*フォローされる側*/
    DocumentReference followersReference = usersRef
        .doc(followersUser.userId)
        .collection('followers')
        .doc(followingUser.userId);
    await followersReference.set({
      'userId': followingUser.userId,
      'name': followingUser.name,
      'profileImage': followingUser.profileImage,
      'bio': followingUser.bio,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> unFollowUser(
      {required User unFollowingUser, required User unFollowersUser}) async {
    /*フォローしている側*/
    DocumentReference followingReference = usersRef
        .doc(unFollowingUser.userId)
        .collection('following')
        .doc(unFollowersUser.userId);
    followingReference.delete();

    /*フォローされている側*/
    DocumentReference followersReference = usersRef
        .doc(unFollowersUser.userId)
        .collection('followers')
        .doc(unFollowingUser.userId);
    followersReference.delete();
  }

  /*ツイート関連*/
  Future<void> createTweet({required Tweet tweet}) async {
    DocumentReference tweetReference =
        usersRef.doc(tweet.authorId).collection('tweets').doc();
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

    String tweetReferenceId = tweetReference.id;

    DocumentReference allTweetsReference = allTweetsRef.doc(tweetReferenceId);
    await allTweetsReference.set({
      'tweetId': tweetReferenceId,
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
    await usersRef.doc(userId).collection('tweets').doc(postId).delete();
    await allTweetsRef.doc(postId).delete();
  }

  Future<void> likesForTweet({
    required Likes likes,
    required String postId,
    required String postUserId,
  }) async {
    DocumentReference likestReferenceInAllTweets =
        allTweetsRef.doc(postId).collection('likes').doc(likes.likesUserId);
    await likestReferenceInAllTweets.set({
      'likesUserId': likes.likesUserId,
      'likesUserName': likes.likesUserName,
      'likesUserProfileImage': likes.likesUserProfileImage,
      'likesUserBio': likes.likesUserBio,
      'timestamp': likes.timestamp,
    });

    DocumentReference likestReferenceInUser = usersRef
        .doc(postUserId)
        .collection('tweets')
        .doc(postId)
        .collection('likes')
        .doc(likes.likesUserId);
    await likestReferenceInUser.set({
      'likesUserId': likes.likesUserId,
      'likesUserName': likes.likesUserName,
      'likesUserProfileImage': likes.likesUserProfileImage,
      'likesUserBio': likes.likesUserBio,
      'timestamp': likes.timestamp,
    });
  }

  Future<void> unLikesForTweet({
    required Tweet tweet,
    required User unlikesUser,
  }) async {
    DocumentReference unLikesTweetReferenceInUser = usersRef
        .doc(tweet.authorId)
        .collection('tweets')
        .doc(tweet.tweetId)
        .collection('likes')
        .doc(unlikesUser.userId);
    await unLikesTweetReferenceInUser.delete();

    DocumentReference unLikesTweetReferenceInAllTweets = allTweetsRef
        .doc(tweet.tweetId)
        .collection('likes')
        .doc(unlikesUser.userId);
    await unLikesTweetReferenceInAllTweets.delete();
  }

  Future<void> commentForTweet({
    required Comment comment,
    required String postId,
    required String postUserId,
  }) async {
    DocumentReference commentReferenceInAllTweets =
        allTweetsRef.doc(postId).collection('comments').doc();
    await commentReferenceInAllTweets.set({
      'commentId': commentReferenceInAllTweets.id,
      'commentUserId': comment.commentUserId,
      'commentUserName': comment.commentUserName,
      'commentUserProfileImage': comment.commentUserProfileImage,
      'commentUserBio': comment.commentUserBio,
      'commentText': comment.commentText,
      'timestamp': comment.timestamp,
    });

    String commentReferenceId = commentReferenceInAllTweets.id;

    DocumentReference commentReferenceInUser = usersRef
        .doc(postUserId)
        .collection('tweets')
        .doc(postId)
        .collection('comments')
        .doc(commentReferenceId);
    await commentReferenceInUser.set({
      'commentId': commentReferenceId,
      'commentUserId': comment.commentUserId,
      'commentUserName': comment.commentUserName,
      'commentUserProfileImage': comment.commentUserProfileImage,
      'commentUserBio': comment.commentUserBio,
      'commentText': comment.commentText,
      'timestamp': comment.timestamp,
    });
  }

  /*シェア関連*/
  Future<DocumentSnapshot> getTweetForShare(
      {required String tweetId, required String tweetAuthorId}) async {
    DocumentSnapshot tweetSnap = await usersRef
        .doc(tweetAuthorId)
        .collection('tweets')
        .doc(tweetId)
        .get();
    return tweetSnap;
  }
}
