import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'CreateTweetState.freezed.dart';

@freezed
abstract class CreateTweetState with _$CreateTweetState {
  const factory CreateTweetState({
    @Default(<File>[]) List<File> tweetImageList,
    @Default(false) bool isLoading,
  }) = _CreateTweetState;
}
