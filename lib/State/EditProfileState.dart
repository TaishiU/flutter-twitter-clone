import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'EditProfileState.freezed.dart';

@freezed
abstract class EditProfileState with _$EditProfileState {
  const factory EditProfileState({
    File? profileImage,
    File? coverImage,
    @Default(false) bool isLoading,
  }) = _EditProfileState;
}
