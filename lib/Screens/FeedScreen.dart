import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/AuthProvider.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Repository/TweetRepository.dart';
import 'package:twitter_clone/Repository/UserRepository.dart';
import 'package:twitter_clone/Screens/ChatScreen.dart';
import 'package:twitter_clone/Screens/HomeScreen.dart';
import 'package:twitter_clone/Screens/MessageScreen.dart';
import 'package:twitter_clone/Screens/NotificationsScreen.dart';
import 'package:twitter_clone/Screens/SearchScreen.dart';
import 'package:twitter_clone/Screens/TweetDetailScreen.dart';

class FeedScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final String? currentUserId = useProvider(currentUserIdProvider);
    final String visitedUserId = useProvider(visitedUserIdProvider);
    final bottomTabIndex = useProvider(bottomTabProvider);
    final UserRepository _userRepository = UserRepository();
    final TweetRepository _tweetRepository = TweetRepository();
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    commonDynamicLink({required PendingDynamicLinkData dynamicLink}) async {
      final Uri? deepLink = dynamicLink.link;
      if (deepLink != null) {
        String? tweetId = deepLink.queryParameters['tweetId'];
        String? tweetAuthorId = deepLink.queryParameters['tweetAuthorId'];

        DocumentSnapshot tweetSnap = await _tweetRepository.getTweet(
          tweetId: tweetId!,
          tweetAuthorId: tweetAuthorId!,
        );
        Tweet tweet = Tweet.fromDoc(tweetSnap);

        print('link??????????????????currentUserId: $currentUserId');
        print('link??????????????????visitedUserId: $visitedUserId');

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

    Future<void> initDynamicLink() async {
      /*?????????????????????????????????????????????*/
      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData? dynamicLink) async {
        commonDynamicLink(dynamicLink: dynamicLink!);
        return;
      }, onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
        return;
      });

      /*????????????????????????????????????????????????????????????*/
      final PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      commonDynamicLink(dynamicLink: data!);
    }

    /*getToken()????????????????????????????????????????????????????????????????????????*/
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
      /*???????????????????????????????????????*/
      DocumentSnapshot peerUserProfileDoc =
          await _userRepository.getUserProfile(userId: peerUserId);
      User peerUser = User.fromDoc(peerUserProfileDoc);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            peerUser: peerUser,
          ),
        ),
      );
    }

    useEffect(() {
      initDynamicLink();
      getToken();

      //?????????????????????
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) {
        if (message != null) {
          print("???????????????????????????????????????????????????????????????");
          Map<String, dynamic> data = message.data;
          String _convoId = jsonDecode(data['convoId']);
          String _senderId = jsonDecode(data['senderId']);
          String _receiverId = jsonDecode(data['receiverId']);

          if (_senderId == currentUserId) {
            getProfileAndNavigate(
              convoId: _convoId,
              currentUserId: _senderId,
              peerUserId: _receiverId,
            );
          } else if (_senderId != currentUserId) {
            getProfileAndNavigate(
              convoId: _convoId,
              currentUserId: _receiverId,
              peerUserId: _senderId,
            );
          }
        }
      });

      /*???????????????????????????*/
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("?????????????????????????????????????????????????????????????????????");
        Map<String, dynamic> data = message.data;
        String _convoId = jsonDecode(data['convoId']);
        String _senderId = jsonDecode(data['senderId']);
        String _receiverId = jsonDecode(data['receiverId']);

        if (_senderId == currentUserId) {
          getProfileAndNavigate(
            convoId: _convoId,
            currentUserId: _senderId,
            peerUserId: _receiverId,
          );
        } else if (_senderId != currentUserId) {
          getProfileAndNavigate(
            convoId: _convoId,
            currentUserId: _receiverId,
            peerUserId: _senderId,
          );
        }
      });
    }, []);

    return Scaffold(
      body: [
        HomeScreen(),
        SearchScreen(),
        NotificationsScreen(),
        MessageScreen(),
      ].elementAt(bottomTabIndex),
      bottomNavigationBar: CupertinoTabBar(
        onTap: (index) {
          context.read(bottomTabProvider.notifier).update(index: index);
        },
        activeColor: TwitterColor,
        currentIndex: bottomTabIndex,
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
