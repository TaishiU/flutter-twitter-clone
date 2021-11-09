// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'EditProfileState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$EditProfileStateTearOff {
  const _$EditProfileStateTearOff();

  _EditProfileState call(
      {File? profileImage, File? coverImage, bool isLoading = false}) {
    return _EditProfileState(
      profileImage: profileImage,
      coverImage: coverImage,
      isLoading: isLoading,
    );
  }
}

/// @nodoc
const $EditProfileState = _$EditProfileStateTearOff();

/// @nodoc
mixin _$EditProfileState {
  File? get profileImage => throw _privateConstructorUsedError;
  File? get coverImage => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EditProfileStateCopyWith<EditProfileState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditProfileStateCopyWith<$Res> {
  factory $EditProfileStateCopyWith(
          EditProfileState value, $Res Function(EditProfileState) then) =
      _$EditProfileStateCopyWithImpl<$Res>;
  $Res call({File? profileImage, File? coverImage, bool isLoading});
}

/// @nodoc
class _$EditProfileStateCopyWithImpl<$Res>
    implements $EditProfileStateCopyWith<$Res> {
  _$EditProfileStateCopyWithImpl(this._value, this._then);

  final EditProfileState _value;
  // ignore: unused_field
  final $Res Function(EditProfileState) _then;

  @override
  $Res call({
    Object? profileImage = freezed,
    Object? coverImage = freezed,
    Object? isLoading = freezed,
  }) {
    return _then(_value.copyWith(
      profileImage: profileImage == freezed
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as File?,
      coverImage: coverImage == freezed
          ? _value.coverImage
          : coverImage // ignore: cast_nullable_to_non_nullable
              as File?,
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$EditProfileStateCopyWith<$Res>
    implements $EditProfileStateCopyWith<$Res> {
  factory _$EditProfileStateCopyWith(
          _EditProfileState value, $Res Function(_EditProfileState) then) =
      __$EditProfileStateCopyWithImpl<$Res>;
  @override
  $Res call({File? profileImage, File? coverImage, bool isLoading});
}

/// @nodoc
class __$EditProfileStateCopyWithImpl<$Res>
    extends _$EditProfileStateCopyWithImpl<$Res>
    implements _$EditProfileStateCopyWith<$Res> {
  __$EditProfileStateCopyWithImpl(
      _EditProfileState _value, $Res Function(_EditProfileState) _then)
      : super(_value, (v) => _then(v as _EditProfileState));

  @override
  _EditProfileState get _value => super._value as _EditProfileState;

  @override
  $Res call({
    Object? profileImage = freezed,
    Object? coverImage = freezed,
    Object? isLoading = freezed,
  }) {
    return _then(_EditProfileState(
      profileImage: profileImage == freezed
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as File?,
      coverImage: coverImage == freezed
          ? _value.coverImage
          : coverImage // ignore: cast_nullable_to_non_nullable
              as File?,
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_EditProfileState implements _EditProfileState {
  const _$_EditProfileState(
      {this.profileImage, this.coverImage, this.isLoading = false});

  @override
  final File? profileImage;
  @override
  final File? coverImage;
  @JsonKey(defaultValue: false)
  @override
  final bool isLoading;

  @override
  String toString() {
    return 'EditProfileState(profileImage: $profileImage, coverImage: $coverImage, isLoading: $isLoading)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _EditProfileState &&
            (identical(other.profileImage, profileImage) ||
                const DeepCollectionEquality()
                    .equals(other.profileImage, profileImage)) &&
            (identical(other.coverImage, coverImage) ||
                const DeepCollectionEquality()
                    .equals(other.coverImage, coverImage)) &&
            (identical(other.isLoading, isLoading) ||
                const DeepCollectionEquality()
                    .equals(other.isLoading, isLoading)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(profileImage) ^
      const DeepCollectionEquality().hash(coverImage) ^
      const DeepCollectionEquality().hash(isLoading);

  @JsonKey(ignore: true)
  @override
  _$EditProfileStateCopyWith<_EditProfileState> get copyWith =>
      __$EditProfileStateCopyWithImpl<_EditProfileState>(this, _$identity);
}

abstract class _EditProfileState implements EditProfileState {
  const factory _EditProfileState(
      {File? profileImage,
      File? coverImage,
      bool isLoading}) = _$_EditProfileState;

  @override
  File? get profileImage => throw _privateConstructorUsedError;
  @override
  File? get coverImage => throw _privateConstructorUsedError;
  @override
  bool get isLoading => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$EditProfileStateCopyWith<_EditProfileState> get copyWith =>
      throw _privateConstructorUsedError;
}
