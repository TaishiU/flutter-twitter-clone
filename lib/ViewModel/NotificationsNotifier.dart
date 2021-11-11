//NotificationsNotifier

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Model/Activity.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Repository/ActivityRepository.dart';
import 'package:twitter_clone/State/NotificationsState.dart';

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationsState>(
  (ref) => NotificationsNotifier(ref.read),
);

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final Reader _read;
  NotificationsNotifier(this._read) : super(const NotificationsState());

  final ActivityRepository _activityRepository = ActivityRepository();

  setupActivities() async {
    final String? currentUserId = _read(currentUserIdProvider);
    List<Activity> activities =
        await _activityRepository.getActivity(currentUserid: currentUserId!);

    state = state.copyWith(activitiesList: activities);
  }
}
