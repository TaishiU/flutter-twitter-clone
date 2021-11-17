import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';

final activityProvider = StreamProvider.autoDispose((ref) {
  final currentUserId = ref.watch(userIdStreamProvider).data?.value;
  return activitiesRef
      .doc(currentUserId)
      .collection('userActivities')
      .orderBy('timestamp', descending: true)
      .limit(10)
      .snapshots();
});
