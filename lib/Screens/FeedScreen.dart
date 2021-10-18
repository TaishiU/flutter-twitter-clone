import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Screens/ChatScreen.dart';
import 'package:twitter_clone/Screens/HomeScreen.dart';
import 'package:twitter_clone/Screens/MessageScreen.dart';
import 'package:twitter_clone/Screens/NotificationsScreen.dart';
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
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    initDynamicLink();
    getToken();

    //ターミネイト用
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print("ターミネイトでメッセージを受け取りました！");
        Map<String, dynamic> data = message.data;
        String _convoId = jsonDecode(data['convoId']);
        String _senderId = jsonDecode(data['senderId']);
        String _receiverId = jsonDecode(data['receiverId']);

        if (_senderId == widget.currentUserId) {
          getProfileAndNavigate(
            convoId: _convoId,
            currentUserId: _senderId,
            peerUserId: _receiverId,
          );
        } else if (_senderId != widget.currentUserId) {
          getProfileAndNavigate(
            convoId: _convoId,
            currentUserId: _receiverId,
            peerUserId: _senderId,
          );
        }
      }
    });

    //フォアグラウンド用
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print("フォアグラウンドでメッセージを受け取りました！");
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification!.android;
    //
    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //       notification.hashCode,
    //       notification.title,
    //       notification.body,
    //       NotificationDetails(
    //         android: AndroidNotificationDetails(
    //           channel.id,
    //           channel.name,
    //           channelDescription: channel.description,
    //           /*「android/app/src/main/AndroidManifest.xml」に記述*/
    //           /*「android/app/src/main/res/drawable」にpng画像を配置*/
    //           icon: 'twitter_logo',
    //           importance: Importance.max,
    //           /*通知の右側にアイコンが出る*/
    //           //largeIcon: DrawableResourceAndroidBitmap('shopping_cart'),
    //           //largeIcon: data['senderProfileImage'],
    //           //largeIcon: FilePathAndroidBitmap('assets/images/shopping_cart'),
    //         ),
    //       ),
    //     );
    //   }
    // });

    /*バックグラウンド用*/
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("バックグラウンドでメッセージを受け取りました！");
      Map<String, dynamic> data = message.data;
      String _convoId = jsonDecode(data['convoId']);
      String _senderId = jsonDecode(data['senderId']);
      String _receiverId = jsonDecode(data['receiverId']);

      if (_senderId == widget.currentUserId) {
        getProfileAndNavigate(
          convoId: _convoId,
          currentUserId: _senderId,
          peerUserId: _receiverId,
        );
      } else if (_senderId != widget.currentUserId) {
        getProfileAndNavigate(
          convoId: _convoId,
          currentUserId: _receiverId,
          peerUserId: _senderId,
        );
      }
    });
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

      DocumentSnapshot tweetSnap = await Firestore().getTweet(
        tweetId: tweetId!,
        tweetAuthorId: tweetAuthorId!,
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

  /*getToken()メソッドを必ず実行しないとプッシュ通知が送れない*/
  getToken() {
    _firebaseMessaging.getToken().then((deviceToken) {
      print('device token: $deviceToken');
    });
  }

  getProfileAndNavigate({
    required String convoId,
    required String currentUserId,
    required String peerUserId,
  }) async {
    /*相手ユーザーのプロフィール*/
    DocumentSnapshot peerUserProfileDoc =
        await Firestore().getUserProfile(userId: peerUserId);
    User peerUser = User.fromDoc(peerUserProfileDoc);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          currentUserId: currentUserId,
          convoId: convoId,
          peerUser: peerUser,
        ),
      ),
    );
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
          visitedUserId: widget.currentUserId,
        ),
        NotificationsScreen(
          currentUserId: widget.currentUserId,
          visitedUserId: widget.currentUserId,
        ),
        MessageScreen(
          currentUserId: widget.currentUserId,
          visitedUserId: widget.currentUserId,
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
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none_outlined)),
          BottomNavigationBarItem(icon: Icon(Icons.mail_outline_rounded)),
        ],
      ),
    );
  }
}
