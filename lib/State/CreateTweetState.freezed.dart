// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'CreateTweetState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$CreateTweetStateTearOff {
  const _$CreateTweetStateTearOff();

  _CreateTweetState call(
      {List<File> tweetImageList = const <File>[], bool isLoading = false}) {
    return _CreateTweetState(
      tweetImageList: tweetImageList,
      isLoading: isLoading,
    );
  }
}

/// @nodoc
const $CreateTweetState = _$CreateTweetStateTearOff();

/// @nodoc
mixin _$CreateTweetState {
  List<File> get tweetImageList => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CreateTweetStateCopyWith<CreateTweetState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateTweetStateCopyWith<$Res> {
  factory $CreateTweetStateCopyWith(
          CreateTweetState value, $Res Function(CreateTweetState) then) =
      _$CreateTweetStateCopyWithImpl<$Res>;
  $Res call({List<File> tweetImageList, bool isLoading});
}

/// @nodoc
class _$CreateTweetStateCopyWithImpl<$Res>
    implements $CreateTweetStateCopyWith<$Res> {
  _$CreateTweetStateCopyWithImpl(this._value, this._then);

  final CreateTweetState _value;
  // ignore: unused_field
  final $Res Function(CreateTweetState) _then;

  @override
  $Res call({
    Object? tweetImageList = freezed,
    Object? isLoading = freezed,
  }) {
    return _then(_value.copyWith(
      tweetImageList: tweetImageList == freezed
          ? _value.tweetImageList
          : tweetImageList // ignore: cast_nullable_to_non_nullable
              as List<File>,
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$CreateTweetStateCopyWith<$Res>
    implements $CreateTweetStateCopyWith<$Res> {
  factory _$CreateTweetStateCopyWith(
          _CreateTweetState value, $Res Function(_CreateTweetState) then) =
      __$CreateTweetStateCopyWithImpl<$Res>;
  @override
  $Res call({List<File> tweetImageList, bool isLoading});
}

/// @nodoc
class __$CreateTweetStateCopyWithImpl<$Res>
    extends _$CreateTweetStateCopyWithImpl<$Res>
    implements _$CreateTweetStateCopyWith<$Res> {
  __$CreateTweetStateCopyWithImpl(
      _CreateTweetState _value, $Res Function(_CreateTweetState) _then)
      : super(_value, (v) => _then(v as _CreateTweetState));

  @override
  _CreateTweetState get _value => super._value as _CreateTweetState;

  @override
  $Res call({
    Object? tweetImageList = freezed,
    Object? isLoading = freezed,
  }) {
    return _then(_CreateTweetState(
      tweetImageList: tweetImageList == freezed
          ? _value.tweetImageList
          : tweetImageList // ignore: cast_nullable_to_non_nullable
              as List<File>,
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_CreateTweetState implements _CreateTweetState {
  const _$_CreateTweetState(
      {this.tweetImageList = const <File>[], this.isLoading = false});

  @JsonKey(defaultValue: const <File>[])
  @override
  final List<File> tweetImageList;
  @JsonKey(defaultValue: false)
  @override
  final bool isLoading;

  @override
  String toString() {
    return 'CreateTweetState(tweetImageList: $tweetImageList, isLoading: $isLoading)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _CreateTweetState &&
            (identical(other.tweetImageList, tweetImageList) ||
                const DeepCollectionEquality()
                    .equals(other.tweetImageList, tweetImageList)) &&
            (identical(other.isLoading, isLoading) ||
                const DeepCollectionEquality()
                    .equals(other.isLoading, isLoading)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(tweetImageList) ^
      const DeepCollectionEquality().hash(isLoading);

  @JsonKey(ignore: true)
  @override
  _$CreateTweetStateCopyWith<_CreateTweetState> get copyWith =>
      __$CreateTweetStateCopyWithImpl<_CreateTweetState>(this, _$identity);
}

abstract class _CreateTweetState implements CreateTweetState {
  const factory _CreateTweetState({List<File> tweetImageList, bool isLoading}) =
      _$_CreateTweetState;

  @override
  List<File> get tweetImageList => throw _privateConstructorUsedError;
  @override
  bool get isLoading => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$CreateTweetStateCopyWith<_CreateTweetState> get copyWith =>
      throw _privateConstructorUsedError;
}
