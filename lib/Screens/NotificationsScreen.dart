import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Model/Activity.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';
import 'package:twitter_clone/Screens/TweetDetailScreen.dart';

class NotificationsScreen extends StatefulWidget {
  final String currentUserId;

  NotificationsScreen({Key? key, required this.currentUserId})
      : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Activity> _activities = [];

  setupActivities() async {
    List<Activity> activities =
        await Firestore().getActivity(currentUserid: widget.currentUserId);
    if (mounted) {
      setState(() {
        _activities = activities;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setupActivities();
  }

  moveToProfileOrTweetDetail({
    required Activity activity,
    required User user,
  }) async {
    if (activity.follow == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(
            currentUserId: widget.currentUserId,
            visitedUserId: user.userId,
          ),
        ),
      );
    }
    if (activity.likes == true || activity.comment == true) {
      DocumentSnapshot tweetSnap = await Firestore().getTweet(
        tweetId: activity.tweetId,
        tweetAuthorId: widget.currentUserId,
      );
      Tweet tweet = Tweet.fromDoc(tweetSnap);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TweetDetailScreen(
            currentUserId: widget.currentUserId,
            tweet: tweet,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: TwitterColor,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return setupActivities();
        },
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: Column(
            children: [
              Container(
                color: Colors.transparent,
                height: 8,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _activities.length,
                itemBuilder: (BuildContext context, int index) {
                  Activity activity = _activities[index];
                  return FutureBuilder(
                    future: usersRef.doc(activity.fromUserId).get(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox.shrink();
                      }
                      User user = User.fromDoc(snapshot.data);
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              moveToProfileOrTweetDetail(
                                activity: activity,
                                user: user,
                              );
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
                                    width: MediaQuery.of(context).size.width *
                                        0.83,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: TwitterColor,
                                                  backgroundImage:
                                                      user.profileImage.isEmpty
                                                          ? null
                                                          : NetworkImage(
                                                              user.profileImage,
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
                                                  Text(' likes your Tweet'),
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
                                                      ' commented on your Tweet'),
                                                ],
                                              ),
                                          ],
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {},
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
                    },
                  );
                },
              ),
            ],
          ),
        ),
        //child: ,
      ),
    );
  }
}
