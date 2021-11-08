import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'ChatState.freezed.dart';

@freezed
abstract class ChatState with _$ChatState {
  const factory ChatState({
    @Default(<File>[]) List<File> chatImageList,
  }) = _ChatState;
}
