//FcmTokenNotifier

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/State/FcmTokenState.dart';

final fcmTokenProvider = StateNotifierProvider<FcmTokenNotifier, FcmTokenState>(
  (ref) => FcmTokenNotifier(),
);

class FcmTokenNotifier extends StateNotifier<FcmTokenState> {
  FcmTokenNotifier() : super(const FcmTokenState());

  getFcmToken() async {
    print('ゼロ状態fcmToken: ${state.fcmToken}');
    String? _fcmToken = await FirebaseMessaging.instance.getToken();
    state = state.copyWith(fcmToken: _fcmToken);
    print('取得後のfcmToken: ${state.fcmToken}');
  }
}
