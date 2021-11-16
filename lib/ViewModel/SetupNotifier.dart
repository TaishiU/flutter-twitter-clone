import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Model/Likes.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Repository/TweetRepository.dart';
import 'package:twitter_clone/Repository/UserRepository.dart';
import 'package:twitter_clone/State/SetupState.dart';

final setupProvider = StateNotifierProvider<SetupNotifier, SetupState>(
  (ref) => SetupNotifier(ref.read),
);

class SetupNotifier extends StateNotifier<SetupState> {
  final Reader _read;
  SetupNotifier(this._read) : super(const SetupState());

  final UserRepository _userRepository = UserRepository();
  final TweetRepository _tweetRepository = TweetRepository();

  /*ユーザーをフォローしているか判断するメソッド*/
  // setupIsFollowing({required Tweet tweet}) async {
  //   final String? currentUserId = _read(currentUserIdProvider);
  //   bool _isFollowingUser = await _userRepository.isFollowingUser(
  //     currentUserId: currentUserId!,
  //     visitedUserId: tweet.authorId,
  //   );
  //   // state = state.copyWith(isFollowingUser: _isFollowingUser);
  //
  //   if (_isFollowingUser == true) {
  //     state = state.copyWith(isFollowingUser: true);
  //     print('${tweet.authorName}をフォローしています！');
  //     print('isFollowingUser: ${state.isFollowingUser}');
  //     return state.isFollowingUser;
  //   } else if (_isFollowingUser == false) {
  //     state = state.copyWith(isFollowingUser: false);
  //     print('${tweet.authorName}をフォローしていません...');
  //     print('isFollowingUser: ${state.isFollowingUser}');
  //     print('ユーザーをフォローしているか判断するメソッドを終了しました！');
  //   }
  //   // state = state.copyWith(isFollowingUser: true);
  //   // print('${tweet.authorName}をフォローしています！');
  //   // print('isFollowingUser: ${state.isFollowingUser}');
  //   // print('ユーザーをフォローしているか判断するメソッドを終了しました！');
  //
  //   // return state.isFollowingUser;
  // }

  /*ツイートにいいねをしているか判断するメソッド*/
  Future<void> setupIsLiked({required Tweet tweet}) async {
    final String? currentUserId = _read(currentUserIdProvider);
    bool _isLikedTweet = await _tweetRepository.isLikedTweet(
      currentUserId: currentUserId!,
      tweetAuthorId: tweet.authorId,
      tweetId: tweet.tweetId!,
    );

    // state = state.copyWith(isLikedTweet: _isLikedTweet);

    if (_isLikedTweet == true) {
      state = state.copyWith(isLikedTweet: true);
      //context.read(isLikedProvider.notifier).update(isLiked: true);
      // print('tweet.text: ${tweet.text}にいいねをしています！');
      // print('state.isLikedTweet: ${state.isLikedTweet}');
    } else {
      state = state.copyWith(isLikedTweet: false);
      //context.read(isLikedProvider.notifier).update(isLiked: false);
      // print('tweet.text: ${tweet.text}にいいねをしていません...');
      // print('state.isLikedTweet: ${state.isLikedTweet}');
    }
  }

  Future<void> followUser({required Tweet tweet}) async {
    //context.read(isFollowingProvider.notifier).update(isFollowing: true);
    final String? currentUserId = _read(currentUserIdProvider);
    //state = state.copyWith(isFollowingUser: true);

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

    //print('${tweet.authorName}をフォローしました！');
    //print('isFollowingUser: ${state.isFollowingUser}');
  }

  Future<void> unFollowUser({required Tweet tweet}) async {
    //context.read(isFollowingProvider.notifier).update(isFollowing: false);
    final String? currentUserId = _read(currentUserIdProvider);
    //state = state.copyWith(isFollowingUser: false);

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

    //print('${tweet.authorName}のフォローを解除しました！');
    //print('isFollowingUser: ${state.isFollowingUser}');
  }

  likeOrUnLikeTweet({required Tweet tweet}) async {
    if (state.isLikedTweet == false) {
      /*いいねされていない時*/
      //context.read(isLikedProvider.notifier).update(isLiked: true);
      state = state.copyWith(isLikedTweet: true);
      print('投稿にいいねしました');
      print('state.isLikedTweet: ${state.isLikedTweet}');
      final String? currentUserId = _read(currentUserIdProvider);

      DocumentSnapshot userProfileDoc =
          await _userRepository.getUserProfile(userId: currentUserId!);
      User user = User.fromDoc(userProfileDoc);

      Likes likes = Likes(
        likesUserId: user.userId,
        likesUserName: user.name,
        likesUserProfileImage: user.profileImageUrl,
        likesUserBio: user.bio,
        timestamp: Timestamp.fromDate(DateTime.now()),
      );
      _tweetRepository.likesForTweet(
        likes: likes,
        tweetId: tweet.tweetId!,
        tweetAuthorId: tweet.authorId,
      );
      _tweetRepository.favoriteTweet(
        currentUserId: currentUserId,
        tweet: tweet,
      );
    } else if (state.isLikedTweet == true) {
      /*いいねされている時*/
      //context.read(isLikedProvider.notifier).update(isLiked: false);
      state = state.copyWith(isLikedTweet: false);
      print('投稿からいいねを外しました');
      print('state.isLikedTweet: ${state.isLikedTweet}');
      final String? currentUserId = _read(currentUserIdProvider);

      DocumentSnapshot userProfileDoc =
          await _userRepository.getUserProfile(userId: currentUserId!);
      User user = User.fromDoc(userProfileDoc);
      _tweetRepository.unLikesForTweet(
        tweet: tweet,
        unlikesUser: user,
      );
    }
  }
}
