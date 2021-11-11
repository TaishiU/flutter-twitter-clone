import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Activity.dart';

class ActivityRepository {
  void addActivity({
    required String currentUserId,
    required String? followedUserId,
    required String? tweetAuthorId,
    required bool follow,
    required bool likes,
    required bool comment,
    required String tweetId,
  }) async {
    if (follow == true) {
      //follow
      DocumentReference activitiesReference =
          activitiesRef.doc(followedUserId).collection('userActivities').doc();
      activitiesReference.set({
        'activityId': activitiesReference.id,
        'fromUserId': currentUserId,
        'timestamp': Timestamp.fromDate(DateTime.now()),
        'follow': true,
        'likes': false,
        'comment': false,
        'tweetId': '',
      });
    } else if (likes == true) {
      //like
      DocumentReference activitiesReference =
          activitiesRef.doc(tweetAuthorId).collection('userActivities').doc();
      activitiesReference.set({
        'activityId': activitiesReference.id,
        'fromUserId': currentUserId,
        'timestamp': Timestamp.fromDate(DateTime.now()),
        'follow': false,
        'likes': true,
        'comment': false,
        'tweetId': tweetId,
      });
    } else if (comment == true) {
      //comment
      DocumentReference activitiesReference =
          activitiesRef.doc(tweetAuthorId).collection('userActivities').doc();
      activitiesReference.set({
        'activityId': activitiesReference.id,
        'fromUserId': currentUserId,
        'timestamp': Timestamp.fromDate(DateTime.now()),
        'follow': false,
        'likes': false,
        'comment': true,
        'tweetId': tweetId,
      });
    }
  }

  Future<List<Activity>> getActivity({required String currentUserid}) async {
    QuerySnapshot userActivitiesSnapshot = await activitiesRef
        .doc(currentUserid)
        .collection('userActivities')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .get();
    List<Activity> activities =
        userActivitiesSnapshot.docs.map((userActivitiesSnap) {
      return Activity.fromDoc(userActivitiesSnap);
    }).toList();
    return activities;
  }
}
