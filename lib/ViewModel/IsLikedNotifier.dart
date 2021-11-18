import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Model/Likes.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Repository/TweetRepository.dart';
import 'package:twitter_clone/Repository/UserRepository.dart';
import 'package:twitter_clone/State/IsLikedState.dart';

final isLikedProvider = StateNotifierProvider<IsLikedNotifier, IsLikedState>(
  (ref) => IsLikedNotifier(ref.read),
);

class IsLikedNotifier extends StateNotifier<IsLikedState> {
  final Reader _read;
  IsLikedNotifier(this._read) : super(const IsLikedState());

  final UserRepository _userRepository = UserRepository();
  final TweetRepository _tweetRepository = TweetRepository();

  /*ツイートにいいねをしているか判断するメソッド*/
  Future<void> setupIsLiked({required Tweet tweet}) async {
    final String? currentUserId = _read(currentUserIdProvider);
    bool _isLikedTweet = await _tweetRepository.isLikedTweet(
      currentUserId: currentUserId!,
      tweetAuthorId: tweet.authorId,
      tweetId: tweet.tweetId!,
    );

    if (_isLikedTweet == true) {
      state = state.copyWith(isLikedTweet: true);
    } else {
      state = state.copyWith(isLikedTweet: false);
    }
  }

  likeOrUnLikeTweet({required Tweet tweet}) async {
    if (state.isLikedTweet == false) {
      /*いいねされていない時*/
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
