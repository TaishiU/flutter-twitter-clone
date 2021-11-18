import 'package:freezed_annotation/freezed_annotation.dart';

part 'IsLikedState.freezed.dart';

@freezed
abstract class IsLikedState with _$IsLikedState {
  const factory IsLikedState({
    @Default(false) bool isLikedTweet,
  }) = _IsLikedState;
}
