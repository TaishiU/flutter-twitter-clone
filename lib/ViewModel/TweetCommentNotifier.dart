import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Model/Comment.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Repository/TweetRepository.dart';
import 'package:twitter_clone/Repository/UserRepository.dart';
import 'package:twitter_clone/State/IsLikedState.dart';

final tweetCommentProvider = StateNotifierProvider<TweetCommentNotifier, void>(
  (ref) => TweetCommentNotifier(ref.read),
);

class TweetCommentNotifier extends StateNotifier<void> {
  final Reader _read;
  TweetCommentNotifier(this._read) : super(const IsLikedState());

  final UserRepository _userRepository = UserRepository();
  final TweetRepository _tweetRepository = TweetRepository();

  handleComment({
    required Tweet tweet,
    required String commentText,
  }) async {
    final currentUserId = _read(currentUserIdProvider);

    DocumentSnapshot userProfileDoc =
        await _userRepository.getUserProfile(userId: currentUserId!);
    User user = User.fromDoc(userProfileDoc);
    Comment comment = Comment(
      commentUserId: currentUserId,
      commentUserName: user.name,
      commentUserProfileImage: user.profileImageUrl,
      commentUserBio: user.bio,
      commentText: commentText,
      timestamp: Timestamp.fromDate(DateTime.now()),
    );

    _tweetRepository.commentForTweet(
      comment: comment,
      tweetId: tweet.tweetId!,
      tweetAuthorId: tweet.authorId,
    );
  }
}
