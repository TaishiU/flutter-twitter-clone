import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userProvider = StateProvider((ref) => FirebaseAuth.instance.currentUser);

final nameProvider = StateProvider.autoDispose((ref) => '');

final emailProvider = StateProvider.autoDispose((ref) => '');

final passwordProvider = StateProvider.autoDispose((ref) => '');

final isObscureProvider =
    StateNotifierProvider.autoDispose<IsObscureController, bool>(
  /*初期値はtrueにして目隠し状態にする*/
  (ref) => IsObscureController(true),
);

class IsObscureController extends StateNotifier<bool> {
  IsObscureController(bool isObscure) : super(isObscure);

  void update(bool isObscure) => state = isObscure;
}
