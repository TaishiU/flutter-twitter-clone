import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Comment.dart';
import 'package:twitter_clone/Model/Likes.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Repository/ActivityRepository.dart';

class TweetRepository {
  final ActivityRepository _activityRepository = ActivityRepository();

  Future<void> createTweet({required Tweet tweet}) async {
    // usersコレクション
    DocumentReference tweetReference =
        usersRef.doc(tweet.authorId).collection('tweets').doc();
    await tweetReference
        .set(_tweetToMap(tweet: tweet, tweetId: tweetReference.id));

    // feedsコレクション
    /*①ユーザー自身のfeedsにツイートを格納*/
    feedsRef.doc(tweet.authorId).set({
      'name': tweet.authorName,
      'userId': tweet.authorId,
    });
    feedsRef
        .doc(tweet.authorId)
        .collection('followingUserTweets')
        .doc(tweetReference.id)
        .set(_tweetToMap(tweet: tweet, tweetId: tweetReference.id));

    /*フォロワーのリストを取得*/
    QuerySnapshot followerSnapshot =
        await usersRef.doc(tweet.authorId).collection('followers').get();

    for (var docSnapshot in followerSnapshot.docs) {
      feedsRef.doc(docSnapshot.id).set({
        'name': docSnapshot.get('name'),
        'userId': docSnapshot.get('userId'),
      });
      /*②フォロワー１人ひとりのfeedsにツイートを格納*/
      feedsRef
          .doc(docSnapshot.id)
          .collection('followingUserTweets')
          .doc(tweetReference.id)
          .set(_tweetToMap(tweet: tweet, tweetId: tweetReference.id));
    }

    // allTweetsコレクション
    DocumentReference allTweetsReference = allTweetsRef.doc(tweetReference.id);
    await allTweetsReference
        .set(_tweetToMap(tweet: tweet, tweetId: tweetReference.id));
  }

  Map<String, dynamic> _tweetToMap({
    required Tweet tweet,
    required String tweetId,
  }) {
    return {
      'tweetId': tweetId,
      'authorName': tweet.authorName,
      'authorId': tweet.authorId,
      'authorBio': tweet.authorBio,
      'authorProfileImage': tweet.authorProfileImage,
      'text': tweet.text,
      'imagesUrl': tweet.imagesUrl,
      'imagesPath': tweet.imagesPath,
      'hasImage': tweet.hasImage,
      'timestamp': tweet.timestamp,
      'likes': tweet.likes,
      'reTweets': tweet.reTweets,
    };
  }

  Future<DocumentSnapshot> getTweet(
      {required String tweetId, required String tweetAuthorId}) async {
    DocumentSnapshot tweetSnap = await usersRef
        .doc(tweetAuthorId)
        .collection('tweets')
        .doc(tweetId)
        .get();
    return tweetSnap;
  }

  Future<void> deleteTweet({
    required String currentUserId,
    required Tweet tweet,
  }) async {
    // usersコレクション
    await usersRef
        .doc(currentUserId)
        .collection('tweets')
        .doc(tweet.tweetId)
        .delete();

    // allTweetsコレクション
    await allTweetsRef.doc(tweet.tweetId).delete();

    // feedsコレクション
    /*①ユーザー自身のfeedsからツイートを削除*/
    await feedsRef
        .doc(currentUserId)
        .collection('followingUserTweets')
        .doc(tweet.tweetId)
        .delete();

    /*フォロワーのリストを取得*/
    QuerySnapshot followerSnapshot =
        await usersRef.doc(tweet.authorId).collection('followers').get();

    for (var docSnapshot in followerSnapshot.docs) {
      /*②フォロワー１人ひとりのfeedsからツイートを削除*/
      feedsRef
          .doc(docSnapshot.id)
          .collection('followingUserTweets')
          .doc(tweet.tweetId)
          .delete();

      // allTweetsコレクション
      await allTweetsRef.doc(tweet.tweetId).delete();
    }
  }

  Future<void> likesForTweet({
    required Likes likes,
    required String tweetId,
    required String tweetAuthorId,
  }) async {
    DocumentReference likestReferenceInAllTweets =
        allTweetsRef.doc(tweetId).collection('likes').doc(likes.likesUserId);
    await likestReferenceInAllTweets.set(_likesToMap(likes));

    DocumentReference likestReferenceInUser = usersRef
        .doc(tweetAuthorId)
        .collection('tweets')
        .doc(tweetId)
        .collection('likes')
        .doc(likes.likesUserId);
    await likestReferenceInUser.set(_likesToMap(likes));

    _activityRepository.addActivity(
      currentUserId: likes.likesUserId,
      followedUserId: null,
      tweetAuthorId: tweetAuthorId,
      follow: false,
      likes: true,
      comment: false,
      tweetId: tweetId,
    );
  }

  Map<String, dynamic> _likesToMap(Likes likes) {
    return {
      'likesUserId': likes.likesUserId,
      'likesUserName': likes.likesUserName,
      'likesUserProfileImage': likes.likesUserProfileImage,
      'likesUserBio': likes.likesUserBio,
      'timestamp': likes.timestamp,
    };
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

    DocumentReference unLikesTweetReferenceInFavorite = usersRef
        .doc(unlikesUser.userId)
        .collection('favorite')
        .doc(tweet.tweetId);
    await unLikesTweetReferenceInFavorite.delete();

    DocumentReference unLikesTweetReferenceInAllTweets = allTweetsRef
        .doc(tweet.tweetId)
        .collection('likes')
        .doc(unlikesUser.userId);
    await unLikesTweetReferenceInAllTweets.delete();
  }

  Future<void> favoriteTweet({
    required String currentUserId,
    required Tweet tweet,
  }) async {
    await usersRef
        .doc(currentUserId)
        .collection('favorite')
        .doc(tweet.tweetId)
        .set({
      'tweetId': tweet.tweetId,
      'authorName': tweet.authorName,
      'authorId': tweet.authorId,
      'authorBio': tweet.authorBio,
      'authorProfileImage': tweet.authorProfileImage,
      'text': tweet.text,
      'imagesUrl': tweet.imagesUrl,
      'imagesPath': tweet.imagesPath,
      'hasImage': tweet.hasImage,
      'timestamp': Timestamp.fromDate(DateTime.now()),
      /*ユーザー自身がいいねを押した瞬間のタイムスタンプ*/
      'likes': tweet.likes,
      'reTweets': tweet.reTweets,
    });
  }

  Future<bool> isLikedTweet({
    required String currentUserId,
    required String tweetAuthorId,
    required String tweetId,
  }) async {
    DocumentSnapshot isLikedTweetSnap = await usersRef
        .doc(tweetAuthorId)
        .collection('tweets')
        .doc(tweetId)
        .collection('likes')
        .doc(currentUserId)
        .get();
    return isLikedTweetSnap.exists;
  }

  Future<void> commentForTweet({
    required Comment comment,
    required String tweetId,
    required String tweetAuthorId,
  }) async {
    DocumentReference commentReferenceInAllTweets =
        allTweetsRef.doc(tweetId).collection('comments').doc();
    await commentReferenceInAllTweets
        .set(_commentToMap(comment, commentReferenceInAllTweets.id));

    DocumentReference commentReferenceInUser = usersRef
        .doc(tweetAuthorId)
        .collection('tweets')
        .doc(tweetId)
        .collection('comments')
        .doc(commentReferenceInAllTweets.id);
    await commentReferenceInUser
        .set(_commentToMap(comment, commentReferenceInAllTweets.id));

    _activityRepository.addActivity(
      currentUserId: comment.commentUserId,
      followedUserId: null,
      tweetAuthorId: tweetAuthorId,
      follow: false,
      likes: false,
      comment: true,
      tweetId: tweetId,
    );
  }

  Map<String, dynamic> _commentToMap(Comment comment, String commentId) {
    return {
      'commentId': commentId,
      'commentUserId': comment.commentUserId,
      'commentUserName': comment.commentUserName,
      'commentUserProfileImage': comment.commentUserProfileImage,
      'commentUserBio': comment.commentUserBio,
      'commentText': comment.commentText,
      'timestamp': comment.timestamp,
    };
  }

  Future<void> deleteOwnCommentForTweet({
    required Comment comment,
    required String tweetId,
    required String tweetAuthorId,
  }) async {
    await allTweetsRef
        .doc(tweetId)
        .collection('comments')
        .doc(comment.commentId)
        .delete();

    await usersRef
        .doc(tweetAuthorId)
        .collection('tweets')
        .doc(tweetId)
        .collection('comments')
        .doc(comment.commentId)
        .delete();
  }
}
