import 'package:hooks_riverpod/hooks_riverpod.dart';

final isLikedProvider =
    StateNotifierProvider.autoDispose<IsLikedController, bool>(
  (ref) => IsLikedController(false),
);

class IsLikedController extends StateNotifier<bool> {
  IsLikedController(bool isLiked) : super(isLiked);
  void update({required bool isLiked}) => state = isLiked;
}

final commentProvider = StateProvider.autoDispose((ref) => '');

final selectedPageProvider =
    StateNotifierProvider.autoDispose<SelectedPageController, int>(
  (ref) => SelectedPageController(0),
);

class SelectedPageController extends StateNotifier<int> {
  SelectedPageController(int index) : super(index);
  void update({required int index}) => state = index;
}
