import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_clone/Constants/Constants.dart';

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

  deleteActivity({
    required String currentUserId,
    required String activityId,
  }) async {
    await activitiesRef
        .doc(currentUserId)
        .collection('userActivities')
        .doc(activityId)
        .delete();
  }
}
