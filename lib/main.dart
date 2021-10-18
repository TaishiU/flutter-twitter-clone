import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Screens/FeedScreen.dart';
import 'package:twitter_clone/Screens/Intro/WelcomeScreen.dart';

/*バックグラウンド用*/
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

/*Androidの通知チャネル設定*/
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.max,
);

/*Androidのフォアグラウンド用(グローバルに宣言可)*/
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: '.env');

  /*バックグラウンド用*/
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /*Androidの通知チャネル設定の実装*/
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //theme: ThemeData.light(),
      theme: ThemeData(
        primaryColor: TwitterColor,
      ),
      home: getScreenId(),
    );
  }

  Widget getScreenId() {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return FeedScreen(currentUserId: snapshot.data!.uid);
          } else {
            return WelcomeScreen();
          }
        });
  }
}
