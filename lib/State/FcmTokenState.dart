//FcmTokenState

import 'package:freezed_annotation/freezed_annotation.dart';

part 'FcmTokenState.freezed.dart';

@freezed
abstract class FcmTokenState with _$FcmTokenState {
  const factory FcmTokenState({
    String? fcmToken,
  }) = _FcmTokenState;
}
