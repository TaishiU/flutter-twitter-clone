//NotificationsNotifier

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Model/Activity.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/State/NotificationsState.dart';

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationsState>(
  (ref) => NotificationsNotifier(ref.read),
);

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final Reader _read;
  NotificationsNotifier(this._read) : super(const NotificationsState());

  setupActivities() async {
    final String? currentUserId = _read(currentUserIdProvider);
    List<Activity> activities =
        await Firestore().getActivity(currentUserid: currentUserId!);

    state = state.copyWith(activitiesList: activities);
  }
}
