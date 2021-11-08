import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:twitter_clone/Model/Activity.dart';

part 'NotificationsState.freezed.dart';

@freezed
abstract class NotificationsState with _$NotificationsState {
  const factory NotificationsState({
    @Default(<Activity>[]) List<Activity> activitiesList,
  }) = _NotificationsState;
}
