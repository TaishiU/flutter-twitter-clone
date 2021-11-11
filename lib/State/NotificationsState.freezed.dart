// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'NotificationsState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$NotificationsStateTearOff {
  const _$NotificationsStateTearOff();

  _NotificationsState call(
      {List<Activity> activitiesList = const <Activity>[]}) {
    return _NotificationsState(
      activitiesList: activitiesList,
    );
  }
}

/// @nodoc
const $NotificationsState = _$NotificationsStateTearOff();

/// @nodoc
mixin _$NotificationsState {
  List<Activity> get activitiesList => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NotificationsStateCopyWith<NotificationsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationsStateCopyWith<$Res> {
  factory $NotificationsStateCopyWith(
          NotificationsState value, $Res Function(NotificationsState) then) =
      _$NotificationsStateCopyWithImpl<$Res>;
  $Res call({List<Activity> activitiesList});
}

/// @nodoc
class _$NotificationsStateCopyWithImpl<$Res>
    implements $NotificationsStateCopyWith<$Res> {
  _$NotificationsStateCopyWithImpl(this._value, this._then);

  final NotificationsState _value;
  // ignore: unused_field
  final $Res Function(NotificationsState) _then;

  @override
  $Res call({
    Object? activitiesList = freezed,
  }) {
    return _then(_value.copyWith(
      activitiesList: activitiesList == freezed
          ? _value.activitiesList
          : activitiesList // ignore: cast_nullable_to_non_nullable
              as List<Activity>,
    ));
  }
}

/// @nodoc
abstract class _$NotificationsStateCopyWith<$Res>
    implements $NotificationsStateCopyWith<$Res> {
  factory _$NotificationsStateCopyWith(
          _NotificationsState value, $Res Function(_NotificationsState) then) =
      __$NotificationsStateCopyWithImpl<$Res>;
  @override
  $Res call({List<Activity> activitiesList});
}

/// @nodoc
class __$NotificationsStateCopyWithImpl<$Res>
    extends _$NotificationsStateCopyWithImpl<$Res>
    implements _$NotificationsStateCopyWith<$Res> {
  __$NotificationsStateCopyWithImpl(
      _NotificationsState _value, $Res Function(_NotificationsState) _then)
      : super(_value, (v) => _then(v as _NotificationsState));

  @override
  _NotificationsState get _value => super._value as _NotificationsState;

  @override
  $Res call({
    Object? activitiesList = freezed,
  }) {
    return _then(_NotificationsState(
      activitiesList: activitiesList == freezed
          ? _value.activitiesList
          : activitiesList // ignore: cast_nullable_to_non_nullable
              as List<Activity>,
    ));
  }
}

/// @nodoc

class _$_NotificationsState implements _NotificationsState {
  const _$_NotificationsState({this.activitiesList = const <Activity>[]});

  @JsonKey(defaultValue: const <Activity>[])
  @override
  final List<Activity> activitiesList;

  @override
  String toString() {
    return 'NotificationsState(activitiesList: $activitiesList)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _NotificationsState &&
            (identical(other.activitiesList, activitiesList) ||
                const DeepCollectionEquality()
                    .equals(other.activitiesList, activitiesList)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(activitiesList);

  @JsonKey(ignore: true)
  @override
  _$NotificationsStateCopyWith<_NotificationsState> get copyWith =>
      __$NotificationsStateCopyWithImpl<_NotificationsState>(this, _$identity);
}

abstract class _NotificationsState implements NotificationsState {
  const factory _NotificationsState({List<Activity> activitiesList}) =
      _$_NotificationsState;

  @override
  List<Activity> get activitiesList => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$NotificationsStateCopyWith<_NotificationsState> get copyWith =>
      throw _privateConstructorUsedError;
}