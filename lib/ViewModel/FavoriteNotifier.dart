import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/State/FavoriteState.dart';

final favoriteTweetProvider =
    StateNotifierProvider<FavoriteNotifier, FavoriteState>(
  (ref) => FavoriteNotifier(ref.read),
);

class FavoriteNotifier extends StateNotifier<FavoriteState> {
  final Reader _read;
  FavoriteNotifier(this._read) : super(const FavoriteState());

  void addTweetToList({required Tweet tweet}) {
    final newList = [...state.favoriteTweetList, tweet];
    state = state.copyWith(favoriteTweetList: newList);
    print('リストにツイート「${tweet.text}」を追加しました！');
    print('favoriteTweetList.length: ${state.favoriteTweetList.length}');
    print('favoriteTweetList: ${state.favoriteTweetList}');
  }

  void removeTweetFromList({required Tweet tweet}) {
    final newList = state.favoriteTweetList
        .where((removeTweet) => removeTweet != tweet)
        .toList();
    state = state.copyWith(favoriteTweetList: newList);
    print('リストからツイート「${tweet.text}」を削除しました...');
    print('favoriteTweetList.length: ${state.favoriteTweetList.length}');
    print('favoriteTweetList: ${state.favoriteTweetList}');
  }
}
