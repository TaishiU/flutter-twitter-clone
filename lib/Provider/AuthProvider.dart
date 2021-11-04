import 'package:hooks_riverpod/hooks_riverpod.dart';

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

final bottomTabProvider = StateNotifierProvider<BottomTabController, int>(
  (ref) => BottomTabController(0),
);

class BottomTabController extends StateNotifier<int> {
  BottomTabController(int index) : super(index);
  void update({required int index}) => state = index;
}
