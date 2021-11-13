import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';

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

// final userModelProvider =
//     StateNotifierProvider<UserModelController, UserModel.User>(
//   (ref) => UserModelController(),
// );
//
// class UserModelController extends StateNotifier<UserModel.User> {
//   UserModelController() : super(user);
//
//   void update({required UserModel.User user}) => state = user;
// }

final isFollowingProvider = StateNotifierProvider<IsFollowingController, bool>(
  (ref) => IsFollowingController(false),
);

class IsFollowingController extends StateNotifier<bool> {
  IsFollowingController(bool isFollowing) : super(isFollowing);
  void update({required bool isFollowing}) => state = isFollowing;
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

final currentUserProfileStreamProvider = StreamProvider.autoDispose((ref) {
  final currentUserId = ref.watch(userIdStreamProvider).data?.value;
  return usersRef.doc(currentUserId).snapshots();
});

final followingAvatarStreamProvider = StreamProvider.autoDispose((ref) {
  final currentUserId = ref.watch(userIdStreamProvider).data?.value;
  return usersRef
      .doc(currentUserId)
      .collection('following')
      .limit(8)
      .snapshots();
});

final searchUsersStreamProvider = StreamProvider.autoDispose((ref) {
  return usersRef.limit(5).snapshots();
});

final followingStreamProvider = StreamProvider.autoDispose((ref) {
  final currentUserId = ref.watch(userIdStreamProvider).data?.value;
  return usersRef
      .doc(currentUserId)
      .collection('following')
      .orderBy('timestamp', descending: true)
      .snapshots();
});

final followersStreamProvider = StreamProvider.autoDispose((ref) {
  final currentUserId = ref.watch(userIdStreamProvider).data?.value;
  return usersRef
      .doc(currentUserId)
      .collection('followers')
      .orderBy('timestamp', descending: true)
      .snapshots();
});
