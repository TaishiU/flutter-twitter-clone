import 'package:freezed_annotation/freezed_annotation.dart';

part 'SetupState.freezed.dart';

@freezed
abstract class SetupState with _$SetupState {
  const factory SetupState({
    @Default(false) bool isFollowingUser,
    @Default(false) bool isLikedTweet,
  }) = _SetupState;
}
