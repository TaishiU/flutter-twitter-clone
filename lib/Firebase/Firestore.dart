import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Activity.dart';
import 'package:twitter_clone/Model/Comment.dart';
import 'package:twitter_clone/Model/Likes.dart';
import 'package:twitter_clone/Model/Message.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';

class Firestore {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /*プロフィール関連*/
  Future<void> registerUser({
    required String userId,
    required String name,
    required String email,
    required String? fcmToken,
  }) async {
    DocumentReference usersReference = usersRef.doc(userId);
    await usersReference.set({
      'userId': usersReference.id,
      'name': name,
      'email': email,
      'profileImage': '',
      'coverImage': '',
      'bio': '',
      'fcmToken': fcmToken,
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

    addActivity(
      currentUserId: followingUser.userId,
      followedUserId: followersUser.userId,
      tweetAuthorId: null,
      follow: true,
      likes: false,
      comment: false,
      tweetId: '',
    );
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

  /*ユーザーをフォローしているか判断するメソッド*/
  Future<bool> isFollowingUser({
    required String currentUserId,
    required String visitedUserId,
  }) async {
    DocumentSnapshot isFollowingUsrSnap = await usersRef
        .doc(currentUserId)
        .collection('following')
        .doc(visitedUserId)
        .get();
    return isFollowingUsrSnap.exists;
  }

  /*ツイート関連*/
  Future<void> createTweet({required Tweet tweet}) async {
    // usersコレクション
    DocumentReference tweetReference =
        usersRef.doc(tweet.authorId).collection('tweets').doc();
    await tweetReference.set({
      'tweetId': tweetReference.id,
      'authorName': tweet.authorName,
      'authorId': tweet.authorId,
      'authorBio': tweet.authorBio,
      'authorProfileImage': tweet.authorProfileImage,
      'text': tweet.text,
      'images': tweet.images,
      'hasImage': tweet.hasImage,
      'timestamp': tweet.timestamp,
      'likes': tweet.likes,
      'reTweets': tweet.reTweets,
    });

    String tweetReferenceId = tweetReference.id;

    // feedsコレクション
    /*①ユーザー自身のfeedsにツイートを格納*/
    feedsRef.doc(tweet.authorId).set({
      'name': tweet.authorName,
      'userId': tweet.authorId,
    });
    feedsRef
        .doc(tweet.authorId)
        .collection('followingUserTweets')
        .doc(tweetReferenceId)
        .set({
      'tweetId': tweetReferenceId,
      'authorName': tweet.authorName,
      'authorId': tweet.authorId,
      'authorBio': tweet.authorBio,
      'authorProfileImage': tweet.authorProfileImage,
      'text': tweet.text,
      'images': tweet.images,
      'hasImage': tweet.hasImage,
      'timestamp': tweet.timestamp,
      'likes': tweet.likes,
      'reTweets': tweet.reTweets,
    });

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
          .doc(tweetReferenceId)
          .set({
        'tweetId': tweetReference.id,
        'authorName': tweet.authorName,
        'authorId': tweet.authorId,
        'authorBio': tweet.authorBio,
        'authorProfileImage': tweet.authorProfileImage,
        'text': tweet.text,
        'images': tweet.images,
        'hasImage': tweet.hasImage,
        'timestamp': tweet.timestamp,
        'likes': tweet.likes,
        'reTweets': tweet.reTweets,
      });
    }

    // allTweetsコレクション
    DocumentReference allTweetsReference = allTweetsRef.doc(tweetReferenceId);
    await allTweetsReference.set({
      'tweetId': tweetReferenceId,
      'authorName': tweet.authorName,
      'authorId': tweet.authorId,
      'authorBio': tweet.authorBio,
      'authorProfileImage': tweet.authorProfileImage,
      'text': tweet.text,
      'images': tweet.images,
      'hasImage': tweet.hasImage,
      'timestamp': tweet.timestamp,
      'likes': tweet.likes,
      'reTweets': tweet.reTweets,
    });
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
    required String userId,
    required Tweet tweet,
  }) async {
    // usersコレクション
    await usersRef.doc(userId).collection('tweets').doc(tweet.tweetId).delete();

    // feedsコレクション
    /*①ユーザー自身のfeedsからツイートを削除*/
    await feedsRef
        .doc(userId)
        .collection('followingUserTweets')
        .doc(tweet.tweetId)
        .delete();

    /*フォロワーのリストを取得*/
    QuerySnapshot followerSnapshot =
        await usersRef.doc(tweet.authorId).collection('followers').get();

    for (var docSnapshot in followerSnapshot.docs) {
      /*②フォロワー１人ひとりのfeedsにツイートを格納*/
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

    addActivity(
      currentUserId: likes.likesUserId,
      followedUserId: null,
      tweetAuthorId: postUserId,
      follow: false,
      likes: true,
      comment: false,
      tweetId: postId,
    );
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
    required String name,
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
      'images': tweet.images,
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

    addActivity(
      currentUserId: comment.commentUserId,
      followedUserId: null,
      tweetAuthorId: postUserId,
      follow: false,
      likes: false,
      comment: true,
      tweetId: postId,
    );
  }

  /*チャット関連*/
  Future<void>? sendMessage({
    required User currentUser,
    required User peerUser,
    required Message message,
  }) {
    final DocumentReference convoDoc = messagesRef.doc(message.convoId);

    convoDoc.set({
      'user1Id': currentUser.userId,
      /*ユーザー自身*/
      'user2Id': peerUser.userId,
      /*相手ユーザー*/
      'user1Name': currentUser.name,
      'user2Name': peerUser.name,
      'user1ProfileImage': currentUser.profileImage,
      'user2ProfileImage': peerUser.profileImage,
      'convoId': message.convoId,
      'userFrom': message.userFrom,
      'userTo': message.userTo,
      'idFrom': message.idFrom,
      'idTo': message.idTo,
      'timestamp': message.timestamp,
      'content': message.content,
      'read': false,
      'users': [currentUser.userId, peerUser.userId],
    });

    final DocumentReference messageDoc = messagesRef
        .doc(message.convoId)
        .collection('allMessages')
        .doc(message.timestamp.toString());

    /*トランザクション処理*/
    _firestore.runTransaction((Transaction transaction) async {
      transaction.set(
        messageDoc,
        {
          'convoId': message.convoId,
          'userFrom': message.userFrom,
          'userTo': message.userTo,
          'idFrom': message.idFrom,
          'idTo': message.idTo,
          'timestamp': message.timestamp,
          'content': message.content,
          'read': false,
        },
      );
    });
  }

  Future<void>? updateMessageRead({
    required Message message,
  }) async {
    DocumentReference convoDoc = messagesRef.doc(message.convoId);
    await convoDoc.set(
      {'read': true},
      SetOptions(merge: true),
    );

    DocumentReference documentReference = messagesRef
        .doc(message.convoId)
        .collection('allMessages')
        .doc(message.timestamp.toString());
    await documentReference.set(
      {'read': true},
      SetOptions(merge: true),
    );
  }

  /*通知関連*/
  static void addActivity({
    required String currentUserId,
    required String? followedUserId,
    required String? tweetAuthorId,
    required bool follow,
    required bool likes,
    required bool comment,
    required String tweetId,
  }) async {
    if (follow == true) {
      //follow
      DocumentReference activitiesReference =
          activitiesRef.doc(followedUserId).collection('userActivities').doc();
      activitiesReference.set({
        'activityId': activitiesReference.id,
        'fromUserId': currentUserId,
        'timestamp': Timestamp.fromDate(DateTime.now()),
        'follow': true,
        'likes': false,
        'comment': false,
        'tweetId': '',
      });
    } else if (likes == true) {
      //like
      DocumentReference activitiesReference =
          activitiesRef.doc(tweetAuthorId).collection('userActivities').doc();
      activitiesReference.set({
        'activityId': activitiesReference.id,
        'fromUserId': currentUserId,
        'timestamp': Timestamp.fromDate(DateTime.now()),
        'follow': false,
        'likes': true,
        'comment': false,
        'tweetId': tweetId,
      });
    } else if (comment == true) {
      //comment
      DocumentReference activitiesReference =
          activitiesRef.doc(tweetAuthorId).collection('userActivities').doc();
      activitiesReference.set({
        'activityId': activitiesReference.id,
        'fromUserId': currentUserId,
        'timestamp': Timestamp.fromDate(DateTime.now()),
        'follow': false,
        'likes': false,
        'comment': true,
        'tweetId': tweetId,
      });
    }
  }

  Future<List<Activity>> getActivity({required String currentUserid}) async {
    QuerySnapshot userActivitiesSnapshot = await activitiesRef
        .doc(currentUserid)
        .collection('userActivities')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .get();
    List<Activity> activities =
        userActivitiesSnapshot.docs.map((userActivitiesSnap) {
      return Activity.fromDoc(userActivitiesSnap);
    }).toList();
    return activities;
  }
}
