import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Comment.dart';
import 'package:twitter_clone/Model/Likes.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Service/DynamicLinkService.dart';

final tweetTextProvider = StateProvider.autoDispose<String>((ref) => '');

final commentProvider = StateProvider.autoDispose<String>((ref) => '');

final selectedPageProvider =
    StateNotifierProvider.autoDispose<SelectedPageController, int>(
  (ref) => SelectedPageController(0),
);

class SelectedPageController extends StateNotifier<int> {
  SelectedPageController(int index) : super(index);
  void update({required int index}) => state = index;
}

//return Tweet Model(List)
final followingUserTweetsStreamProvider =
    StreamProvider.autoDispose<List<Tweet>>((ref) {
  final currentUserId = ref.watch(userIdStreamProvider).data?.value;
  return feedsRef
      .doc(currentUserId)
      .collection('followingUserTweets')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map(_queryToTweetList);
});

final allImageTweetsStreamProvider =
    StreamProvider.autoDispose<List<Tweet>>((ref) {
  return allTweetsRef
      .where('hasImage', isEqualTo: true) /*画像があるツイートを取得*/
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map(_queryToTweetList);
});

final profileTweetProvider =
    StreamProvider.family<List<Tweet>, User>((ref, user) {
  return usersRef
      .doc(user.userId)
      .collection('tweets')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map(_queryToTweetList);
});

final profileImageTweetProvider =
    StreamProvider.family<List<Tweet>, User>((ref, user) {
  return usersRef
      .doc(user.userId)
      .collection('tweets')
      .where('hasImage', isEqualTo: true) /*画像があるツイートを取得*/
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map(_queryToTweetList);
});

final profileFavoriteTweetProvider =
    StreamProvider.family<List<Tweet>, User>((ref, user) {
  return usersRef
      .doc(user.userId)
      .collection('favorite')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map(_queryToTweetList);
});

List<Tweet> _queryToTweetList(QuerySnapshot query) {
  return query.docs.map((doc) {
    Tweet tweet = Tweet.fromDoc(doc);
    return tweet;
  }).toList();
}

//return Comment Model(List)
final allTweetCommentsProvider =
    StreamProvider.family<List<Comment>, Tweet>((ref, tweet) {
  return usersRef
      .doc(tweet.authorId)
      .collection('tweets')
      .doc(tweet.tweetId)
      .collection('comments')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map(_queryToCommentList);
});

List<Comment> _queryToCommentList(QuerySnapshot query) {
  return query.docs.map((doc) {
    Comment comment = Comment.fromDoc(doc);
    return comment;
  }).toList();
}

//return Likes Model(List)
final allTweetLikesProvider =
    StreamProvider.family<List<Likes>, Tweet>((ref, tweet) {
  return usersRef
      .doc(tweet.authorId)
      .collection('tweets')
      .doc(tweet.tweetId)
      .collection('likes')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map(_queryToLikesList);
});

List<Likes> _queryToLikesList(QuerySnapshot query) {
  return query.docs.map((doc) {
    Likes likes = Likes.fromDoc(doc);
    return likes;
  }).toList();
}

//Share
final shareProvider = FutureProvider.family<Uri, Tweet>((ref, tweet) {
  final DynamicLinkService _dynamicLinkService = DynamicLinkService();
  return _dynamicLinkService.createDynamicLink(
    tweetId: tweet.tweetId!,
    tweetAuthorId: tweet.authorId,
    tweetText: tweet.text,
    imageUrl: tweet.hasImage
        ? tweet.imagesUrl['0']!
        : 'https://static.theprint.in/wp-content/uploads/2021/02/twitter--696x391.jpg',
  );
});
