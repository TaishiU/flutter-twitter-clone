import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Repository/ActivityRepository.dart';

class UserRepository {
  final ActivityRepository _activityRepository = ActivityRepository();

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
      'profileImageUrl': '',
      'profileImagePath': '',
      'coverImageUrl': '',
      'coverImagePath': '',
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
      'profileImageUrl': user.profileImageUrl,
      'profileImagePath': user.profileImagePath,
      'coverImageUrl': user.coverImageUrl,
      'coverImagePath': user.coverImagePath,
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
      'profileImageUrl': followersUser.profileImageUrl,
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
      'profileImageUrl': followingUser.profileImageUrl,
      'bio': followingUser.bio,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });

    _activityRepository.addActivity(
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
}
