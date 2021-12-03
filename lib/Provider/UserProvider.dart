import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Following.dart';
import 'package:twitter_clone/Model/ListUser.dart';
import 'package:twitter_clone/Model/User.dart' as UserModel;

final _authProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final userIdStreamProvider = StreamProvider<String?>((ref) {
  return ref.watch(_authProvider).authStateChanges().map((User? user) {
    if (user != null) {
      return user.uid;
    }
    print('userIdStreamProvider: user is null');
    return null;
  });
});

final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(userIdStreamProvider).data?.value;
});

final visitedUserIdProvider =
    StateNotifierProvider<VisitedUserIdController, String>(
  (ref) => VisitedUserIdController(''),
);

class VisitedUserIdController extends StateNotifier<String> {
  VisitedUserIdController(String userId) : super(userId);

  void update({required String userId}) => state = userId;
}

final profileIndexProvider = StateNotifierProvider<ProfileIndexController, int>(
  (ref) => ProfileIndexController(0),
);

class ProfileIndexController extends StateNotifier<int> {
  ProfileIndexController(int index) : super(index);
  void update({required int index}) => state = index;
}

final profileNameProvider = StateProvider.autoDispose((ref) => '');

final profileBioProvider = StateProvider.autoDispose((ref) => '');

//return User Model
final currentUserProfileStreamProvider =
    StreamProvider.autoDispose<UserModel.User>((ref) {
  final currentUserId = ref.watch(userIdStreamProvider).data?.value;
  return usersRef.doc(currentUserId).snapshots().map(_snapshotToUser);
});

final userProfileStreamProvider = StreamProvider.autoDispose
    .family<UserModel.User, String>((ref, visitedUserId) {
  return usersRef.doc(visitedUserId).snapshots().map(_snapshotToUser);
});

final activityUserProvider =
    StreamProvider.family<UserModel.User, String>((ref, fromUserId) {
  return usersRef.doc(fromUserId).snapshots().map(_snapshotToUser);
});

UserModel.User _snapshotToUser(DocumentSnapshot snapshot) {
  return UserModel.User.fromDoc(snapshot);
}

//return User Model(List)
final searchUsersStreamProvider =
    StreamProvider.autoDispose<List<UserModel.User>>((ref) {
  return usersRef.limit(8).snapshots().map(_queryToUserList);
});

List<UserModel.User> _queryToUserList(QuerySnapshot query) {
  return query.docs.map((doc) {
    UserModel.User user = UserModel.User.fromDoc(doc);
    return user;
  }).toList();
}

//return Following Model(List)
final followingAvatarStreamProvider =
    StreamProvider.autoDispose<List<Following>>((ref) {
  final currentUserId = ref.watch(userIdStreamProvider).data?.value;
  return usersRef
      .doc(currentUserId)
      .collection('following')
      .limit(8)
      .snapshots()
      .map(_queryToFollowingList);
});

List<Following> _queryToFollowingList(QuerySnapshot query) {
  return query.docs.map((doc) {
    Following following = Following.fromDoc(doc);
    return following;
  }).toList();
}

// return ListUser Model(List)
final followingStreamProvider = StreamProvider.autoDispose
    .family<List<ListUser>, String>((ref, visitedUserId) {
  return usersRef
      .doc(visitedUserId)
      .collection('following')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map(_queryToListUserAboutFollow);
});

final followersStreamProvider = StreamProvider.autoDispose
    .family<List<ListUser>, String>((ref, visitedUserId) {
  return usersRef
      .doc(visitedUserId)
      .collection('followers')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map(_queryToListUserAboutFollow);
});

List<ListUser> _queryToListUserAboutFollow(QuerySnapshot query) {
  return query.docs.map((doc) {
    ListUser listUser = ListUser.fromDoc(doc);
    return listUser;
  }).toList();
}
