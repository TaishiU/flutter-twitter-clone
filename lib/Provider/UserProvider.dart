import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _authProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

// final userProvider =
//     Provider<User>((ref) => ref.watch(_authProvider).currentUser);

// final userProvider = StateNotifierProvider<UserController, User>(
//       (ref) => UserController(),
// );
// class UserController extends StateNotifier<User> {
//   UserController(User user) : super(user);
//   void update({required User user}) => state = user;
// }

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
