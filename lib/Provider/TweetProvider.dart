import 'package:hooks_riverpod/hooks_riverpod.dart';

final tweetTextProvider = StateProvider.autoDispose<String>((ref) => '');

final commentProvider = StateProvider.autoDispose<String>((ref) => '');

final isLikedProvider =
    StateNotifierProvider.autoDispose<IsLikedController, bool>(
  (ref) => IsLikedController(false),
);

class IsLikedController extends StateNotifier<bool> {
  IsLikedController(bool isLiked) : super(isLiked);
  void update({required bool isLiked}) => state = isLiked;
}

final selectedPageProvider =
    StateNotifierProvider.autoDispose<SelectedPageController, int>(
  (ref) => SelectedPageController(0),
);

class SelectedPageController extends StateNotifier<int> {
  SelectedPageController(int index) : super(index);
  void update({required int index}) => state = index;
}

final isObscureProvider =
    StateNotifierProvider.autoDispose<IsObscureController, bool>(
  /*初期値はtrueにして目隠し状態にする*/
  (ref) => IsObscureController(true),
);

class IsObscureController extends StateNotifier<bool> {
  IsObscureController(bool isObscure) : super(isObscure);

  void update(bool isObscure) => state = isObscure;
}

final isLoadingProvider =
    StateNotifierProvider.autoDispose<IsLoadingController, bool>(
  (ref) => IsLoadingController(false),
);

class IsLoadingController extends StateNotifier<bool> {
  IsLoadingController(bool isLoading) : super(isLoading);
  void update({required bool isLoading}) => state = isLoading;
}
