import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Repository/UserRepository.dart';
import 'package:twitter_clone/State/IsFollowingState.dart';

final isFollowingProvider =
    StateNotifierProvider<IsFollowingNotifier, IsFollowingState>(
  (ref) => IsFollowingNotifier(ref.read),
);

class IsFollowingNotifier extends StateNotifier<IsFollowingState> {
  final Reader _read;
  IsFollowingNotifier(this._read) : super(const IsFollowingState());

  final UserRepository _userRepository = UserRepository();

  /*ユーザーをフォローしているか判断するメソッド*/
  setupIsFollowing({required String visitedUserId}) async {
    final String? currentUserId = _read(currentUserIdProvider);
    bool _isFollowingUser = await _userRepository.isFollowingUser(
      currentUserId: currentUserId!,
      visitedUserId: visitedUserId,
    );

    if (_isFollowingUser == true) {
      state = state.copyWith(isFollowingUser: true);
    } else if (_isFollowingUser == false) {
      state = state.copyWith(isFollowingUser: false);
    }
  }

  Future<void> followUserFromProfile({required String visitedUserId}) async {
    state = state.copyWith(isFollowingUser: true);
    final String? currentUserId = _read(currentUserIdProvider);

    DocumentSnapshot followingUserSnap =
        await _userRepository.getUserProfile(userId: currentUserId!);
    User followingUser = User.fromDoc(followingUserSnap);

    DocumentSnapshot followersUserSnap =
        await _userRepository.getUserProfile(userId: visitedUserId);
    User followersUser = User.fromDoc(followersUserSnap);

    await _userRepository.followUser(
      followingUser: followingUser,
      followersUser: followersUser,
    );
  }

  Future<void> followUserFromTweet({required Tweet tweet}) async {
    state = state.copyWith(isFollowingUser: true);
    final String? currentUserId = _read(currentUserIdProvider);

    DocumentSnapshot followingUserSnap =
        await _userRepository.getUserProfile(userId: currentUserId!);
    User followingUser = User.fromDoc(followingUserSnap);

    DocumentSnapshot followersUserSnap =
        await _userRepository.getUserProfile(userId: tweet.authorId);
    User followersUser = User.fromDoc(followersUserSnap);

    await _userRepository.followUser(
      followingUser: followingUser,
      followersUser: followersUser,
    );
  }

  Future<void> unFollowUserFromProfile({required String visitedUserId}) async {
    final String? currentUserId = _read(currentUserIdProvider);
    state = state.copyWith(isFollowingUser: false);

    DocumentSnapshot unFollowingUserSnap =
        await _userRepository.getUserProfile(userId: currentUserId!);
    User unFollowingUser = User.fromDoc(unFollowingUserSnap);

    DocumentSnapshot unFollowersUserSnap =
        await _userRepository.getUserProfile(userId: visitedUserId);
    User unFollowersUser = User.fromDoc(unFollowersUserSnap);

    await _userRepository.unFollowUser(
      unFollowingUser: unFollowingUser,
      unFollowersUser: unFollowersUser,
    );
  }

  Future<void> unFollowUserFromTweet({required Tweet tweet}) async {
    final String? currentUserId = _read(currentUserIdProvider);
    state = state.copyWith(isFollowingUser: false);

    DocumentSnapshot unFollowingUserSnap =
        await _userRepository.getUserProfile(userId: currentUserId!);
    User unFollowingUser = User.fromDoc(unFollowingUserSnap);

    DocumentSnapshot unFollowersUserSnap =
        await _userRepository.getUserProfile(userId: tweet.authorId);
    User unFollowersUser = User.fromDoc(unFollowersUserSnap);

    await _userRepository.unFollowUser(
      unFollowingUser: unFollowingUser,
      unFollowersUser: unFollowersUser,
    );
  }
}
