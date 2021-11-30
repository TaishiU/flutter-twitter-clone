import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Activity.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';

final activityProvider = StreamProvider.autoDispose<List<Activity>>((ref) {
  final currentUserId = ref.watch(userIdStreamProvider).data?.value;
  return activitiesRef
      .doc(currentUserId)
      .collection('userActivities')
      .orderBy('timestamp', descending: true)
      .limit(10)
      .snapshots()
      .map(_queryToActivityList);
});

List<Activity> _queryToActivityList(QuerySnapshot query) {
  return query.docs.map((doc) {
    Activity activity = Activity.fromDoc(doc);
    return activity;
  }).toList();
}
