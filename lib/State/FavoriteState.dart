import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:twitter_clone/Model/Tweet.dart';

part 'FavoriteState.freezed.dart';

@freezed
abstract class FavoriteState with _$FavoriteState {
  const factory FavoriteState({
    @Default(<Tweet>[]) List<Tweet> favoriteTweetList,
  }) = _FavoriteState;
}
