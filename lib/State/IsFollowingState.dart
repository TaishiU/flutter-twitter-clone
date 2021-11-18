import 'package:freezed_annotation/freezed_annotation.dart';

part 'IsFollowingState.freezed.dart';

@freezed
abstract class IsFollowingState with _$IsFollowingState {
  const factory IsFollowingState({
    @Default(false) bool isFollowingUser,
  }) = _IsFollowingState;
}
