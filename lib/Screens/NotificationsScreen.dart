import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Activity.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/ActivityProvider.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Repository/ActivityRepository.dart';
import 'package:twitter_clone/Repository/TweetRepository.dart';
import 'package:twitter_clone/Screens/CreateTweetScreen.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';
import 'package:twitter_clone/Screens/TweetDetailScreen.dart';
import 'package:twitter_clone/Widget/DrawerContainer.dart';

class NotificationsScreen extends HookWidget {
  NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? currentUserId = useProvider(currentUserIdProvider);
    final asyncActivity = useProvider(activityProvider);
    final TweetRepository _tweetRepository = TweetRepository();
    final ActivityRepository _activityRepository = ActivityRepository();
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final _visitedUserUdNotifier = context.read(visitedUserIdProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          SvgPicture.asset(
            'assets/images/SettingLogo.svg',
            width: 23,
            height: 23,
          ),
          Container(
            width: 15,
          ),
        ],
      ),
      body: ListView(
        physics: BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: [
          Container(
            color: Colors.transparent,
            height: 8,
          ),
          asyncActivity.when(
              loading: () => Center(child: const CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
              data: (activitiesQuery) {
                List<DocumentSnapshot> activitiesList = activitiesQuery.docs;
                if (activitiesList.length == 0) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'You have\'t received any notification yet.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'When an account you are following acts on you,\nyou will see it here.',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: activitiesList.map((activities) {
                    Activity activity = Activity.fromDoc(activities);
                    return Consumer(builder: (context, watch, child) {
                      final asyncActivityUser = watch(
                        activityUserProvider(activity.fromUserId),
                      );
                      return asyncActivityUser.when(
                          loading: () => SizedBox.shrink(),
                          error: (error, stack) =>
                              Center(child: Text('Error: $error')),
                          data: (userQuery) {
                            User user = User.fromDoc(userQuery);
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    if (activity.follow == true) {
                                      /*visitedUserId情報を更新*/
                                      _visitedUserUdNotifier.update(
                                          userId: activity.fromUserId);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfileScreen(),
                                        ),
                                      );
                                    }
                                    if (activity.likes == true ||
                                        activity.comment == true) {
                                      DocumentSnapshot tweetSnap =
                                          await _tweetRepository.getTweet(
                                        tweetId: activity.tweetId,
                                        tweetAuthorId: currentUserId!,
                                      );
                                      Tweet tweet = Tweet.fromDoc(tweetSnap);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TweetDetailScreen(
                                            tweet: tweet,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    margin: EdgeInsets.only(left: 15),
                                    child: Row(
                                      children: [
                                        if (activity.follow == true)
                                          Icon(
                                            Icons.person,
                                            color: TwitterColor,
                                          ),
                                        if (activity.likes == true)
                                          Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          ),
                                        if (activity.comment == true)
                                          Icon(
                                            Icons.comment,
                                            color: Colors.green,
                                          ),
                                        SizedBox(width: 20),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.83,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundColor: user
                                                                .profileImageUrl
                                                                .isEmpty
                                                            ? TwitterColor
                                                            : Colors
                                                                .transparent,
                                                        backgroundImage: user
                                                                .profileImageUrl
                                                                .isEmpty
                                                            ? null
                                                            : NetworkImage(
                                                                user.profileImageUrl,
                                                              ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text(
                                                        '${activity.timestamp.toDate().month.toString()}/${activity.timestamp.toDate().day.toString()}',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5),
                                                  if (activity.follow == true)
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '${user.name}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(' follows you'),
                                                      ],
                                                    ),
                                                  if (activity.likes == true)
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '${user.name}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                            ' likes your Tweet'),
                                                      ],
                                                    ),
                                                  if (activity.comment == true)
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '${user.name}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          ' commented on your Tweet',
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.more_vert,
                                                  color: Colors.grey,
                                                ),
                                                onPressed: () {
                                                  showAdaptiveActionSheet(
                                                    context: context,
                                                    title: SizedBox.shrink(),
                                                    actions: <
                                                        BottomSheetAction>[
                                                      BottomSheetAction(
                                                        leading: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 20),
                                                          child: Icon(
                                                            Icons.delete,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        title: Text(
                                                          'Delete a notification',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          _activityRepository
                                                              .deleteActivity(
                                                            currentUserId:
                                                                currentUserId!,
                                                            activityId: activity
                                                                .activityId,
                                                          );
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(),
                              ],
                            );
                          });
                    });
                  }).toList(),
                );
              }),
        ],
      ),
      drawer: DrawerContainer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: TwitterColor,
        child: Image.asset(
          'assets/images/TweetLogo.png',
          fit: BoxFit.cover,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTweetScreen(),
            ),
          );
        },
      ),
    );
  }
}
