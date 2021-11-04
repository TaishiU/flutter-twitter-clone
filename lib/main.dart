import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
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

  runApp(
    ProviderScope(child: MyApp()),
  );
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final userIdStream = useProvider(userIdStreamProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: TwitterColor,
      ),
      home: userIdStream.when(
        data: ((String? currentUserId) {
          if (currentUserId != null) {
            /*visitedUserId情報を更新*/
            context
                .read(visitedUserIdProvider.notifier)
                .update(userId: currentUserId);
            return FeedScreen();
          } else {
            return WelcomeScreen();
          }
        }),
        loading: () => CircularProgressIndicator(),
        error: (e, stackTrace) => Text(e.toString()),
      ),
    );
  }
}
