import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Service/DynamicLinkService.dart';

final tweetTextProvider = StateProvider.autoDispose<String>((ref) => '');

final commentProvider = StateProvider.autoDispose<String>((ref) => '');

final isLikedProvider = StateNotifierProvider<IsLikedController, bool>(
  (ref) => IsLikedController(false),
);

class IsLikedController extends StateNotifier<bool> {
  IsLikedController(bool isLiked) : super(false);
  void update({required bool isLiked}) => state = isLiked;
}

final selectedPageProvider =
    StateNotifierProvider.autoDispose<SelectedPageController, int>(
  (ref) => SelectedPageController(0),
);

class SelectedPageController extends StateNotifier<int> {
  SelectedPageController(int index) : super(index);
  void update({required int index}) => state = index;
}

// final isLoadingProvider =
//     StateNotifierProvider.autoDispose<IsLoadingController, bool>(
//   (ref) => IsLoadingController(false),
// );
//
// class IsLoadingController extends StateNotifier<bool> {
//   IsLoadingController(bool isLoading) : super(isLoading);
//   void update({required bool isLoading}) => state = isLoading;
// }

// final followingUsersStreamProvider = StreamProvider((ref) {
//   final currentUserId = ref.watch(userIdStreamProvider).data?.value;
//   return _firestore
//       .collection('users')
//       .doc(currentUserId)
//       .collection('following')
//       .snapshots();
// });

final followingUserTweetsStreamProvider = StreamProvider.autoDispose((ref) {
  final currentUserId = ref.watch(userIdStreamProvider).data?.value;
  return feedsRef
      .doc(currentUserId)
      .collection('followingUserTweets')
      .orderBy('timestamp', descending: true)
      .snapshots();
});

final allTweetsStreamProvider = StreamProvider.autoDispose((ref) {
  return allTweetsRef
      .where('hasImage', isEqualTo: true) /*画像があるツイートを取得*/
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

// final userTweetsStreamProvider = StreamProvider.autoDispose((ref) {
//   final user = ref.watch(userProvider);
//   return usersRef
//       .doc(user!.userId)
//       .collection('tweets')
//       .orderBy('timestamp', descending: true)
//       .snapshots();
// });
