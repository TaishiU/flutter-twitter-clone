import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
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

final followingUserTweetsStreamProvider = StreamProvider.autoDispose((ref) {
  final currentUserId = ref.watch(userIdStreamProvider).data?.value;
  return feedsRef
      .doc(currentUserId)
      .collection('followingUserTweets')
      .orderBy('timestamp', descending: true)
      .snapshots();
});

final allImageTweetsStreamProvider = StreamProvider.autoDispose((ref) {
  return allTweetsRef
      .where('hasImage', isEqualTo: true) /*画像があるツイートを取得*/
      .orderBy('timestamp', descending: true)
      .snapshots();
});

final allTweetCommentsProvider =
    StreamProvider.family<QuerySnapshot<Map<String, dynamic>>, Tweet>(
        (ref, tweet) {
  return usersRef
      .doc(tweet.authorId)
      .collection('tweets')
      .doc(tweet.tweetId)
      .collection('comments')
      .snapshots();
});

final allTweetLikesProvider =
    StreamProvider.family<QuerySnapshot<Map<String, dynamic>>, Tweet>(
        (ref, tweet) {
  return usersRef
      .doc(tweet.authorId)
      .collection('tweets')
      .doc(tweet.tweetId)
      .collection('likes')
      .orderBy('timestamp', descending: true)
      .snapshots();
});

final profileTweetProvider =
    StreamProvider.family<QuerySnapshot<Map<String, dynamic>>, User>(
        (ref, user) {
  return usersRef
      .doc(user.userId)
      .collection('tweets')
      .orderBy('timestamp', descending: true)
      .snapshots();
});

final profileImageTweetProvider =
    StreamProvider.family<QuerySnapshot<Map<String, dynamic>>, User>(
        (ref, user) {
  return usersRef
      .doc(user.userId)
      .collection('tweets')
      .where('hasImage', isEqualTo: true) /*画像があるツイートを取得*/
      .orderBy('timestamp', descending: true)
      .snapshots();
});

final profileFavoriteTweetProvider =
    StreamProvider.family<QuerySnapshot<Map<String, dynamic>>, User>(
        (ref, user) {
  return usersRef
      .doc(user.userId)
      .collection('favorite')
      .orderBy('timestamp', descending: true)
      .snapshots();
});

final commentForTweetProvider =
    StreamProvider.family<QuerySnapshot<Map<String, dynamic>>, Tweet>(
        (ref, tweet) {
  return usersRef
      .doc(tweet.authorId)
      .collection('tweets')
      .doc(tweet.tweetId)
      .collection('comments')
      .orderBy('timestamp', descending: true)
      .snapshots();
});

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
