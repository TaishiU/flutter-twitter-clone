import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Activity.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Repository/TweetRepository.dart';
import 'package:twitter_clone/Screens/CreateTweetScreen.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';
import 'package:twitter_clone/Screens/TweetDetailScreen.dart';
import 'package:twitter_clone/ViewModel/NotificationsNotifier.dart';
import 'package:twitter_clone/Widget/DrawerContainer.dart';

class NotificationsScreen extends HookWidget {
  NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? currentUserId = useProvider(currentUserIdProvider);
    final notificationsState = useProvider(notificationsProvider);
    final _activitiesList = notificationsState.activitiesList;
    final TweetRepository _tweetRepository = TweetRepository();

    useEffect(() {
      context.read(notificationsProvider.notifier).setupActivities();
    }, []);

    moveToProfileOrTweetDetail({
      required Activity activity,
      required User user,
    }) async {
      if (activity.follow == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(),
          ),
        );
      }
      if (activity.likes == true || activity.comment == true) {
        DocumentSnapshot tweetSnap = await _tweetRepository.getTweet(
          tweetId: activity.tweetId,
          tweetAuthorId: currentUserId!,
        );
        Tweet tweet = Tweet.fromDoc(tweetSnap);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TweetDetailScreen(
              tweet: tweet,
            ),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0.5,
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
      body: RefreshIndicator(
        onRefresh: () {
          return context.read(notificationsProvider.notifier).setupActivities();
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
                itemCount: _activitiesList.length,
                itemBuilder: (BuildContext context, int index) {
                  Activity activity = _activitiesList[index];
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
                                                  backgroundColor:
                                                      Colors.transparent,
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
