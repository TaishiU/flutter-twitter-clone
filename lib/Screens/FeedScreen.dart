import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Screens/HomeScreen.dart';
import 'package:twitter_clone/Screens/NotificationsScreen.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';
import 'package:twitter_clone/Screens/SearchScreen.dart';
import 'package:twitter_clone/Screens/TweetDetailScreen.dart';

class FeedScreen extends StatefulWidget {
  final String currentUserId;
  FeedScreen({required this.currentUserId});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    initDynamicLink();
  }

  Future<void> initDynamicLink() async {
    /*アプリが起動状態の時に呼ばれる*/
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      commonDynamicLink(dynamicLink: dynamicLink!);
      return;
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
      return;
    });

    /*アプリが起動していない状態の時に呼ばれる*/
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    commonDynamicLink(dynamicLink: data!);
  }

  commonDynamicLink({required PendingDynamicLinkData dynamicLink}) async {
    final Uri? deepLink = dynamicLink.link;
    if (deepLink != null) {
      String? tweetId = deepLink.queryParameters['tweetId'];
      String? tweetAuthorId = deepLink.queryParameters['tweetAuthorId'];

      DocumentSnapshot userProfile =
          await Firestore().getUserProfile(userId: widget.currentUserId);
      DocumentSnapshot tweetSnap = await Firestore().getTweetForShare(
        tweetId: tweetId!,
        tweetAuthorId: tweetAuthorId!,
      );
      User user = User.fromDoc(userProfile);
      Tweet tweet = Tweet.fromDoc(tweetSnap);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TweetDetailScreen(
            currentUserId: widget.currentUserId,
            tweet: tweet,
            user: user,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        HomeScreen(
          currentUserId: widget.currentUserId,
          visitedUserId: widget.currentUserId,
        ),
        SearchScreen(
          currentUserId: widget.currentUserId,
        ),
        NotificationsScreen(
          currentUserId: widget.currentUserId,
        ),
        ProfileScreen(
          currentUserId: widget.currentUserId,
          visitedUserUserId: widget.currentUserId,
        ),
      ].elementAt(_selectedTab),
      bottomNavigationBar: CupertinoTabBar(
        onTap: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        activeColor: TwitterColor,
        currentIndex: _selectedTab,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications)),
          BottomNavigationBarItem(icon: Icon(Icons.person)),
          // BottomNavigationBarItem(
          //   icon: Container(
          //     child: StreamBuilder(
          //       stream: usersRef.doc(widget.currentUserId).snapshots(),
          //       builder: (BuildContext context, AsyncSnapshot snapshot) {
          //         if (!snapshot.hasData) {
          //           return CircleAvatar(
          //             radius: 20,
          //             backgroundColor: TwitterColor,
          //             backgroundImage: null,
          //           );
          //         }
          //         User user = User.fromDoc(snapshot.data);
          //         return CircleAvatar(
          //           radius: 20,
          //           backgroundImage: NetworkImage(user.profileImage),
          //         );
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
