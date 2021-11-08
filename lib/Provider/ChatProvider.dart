import 'package:hooks_riverpod/hooks_riverpod.dart';

final messageTextProvider = StateProvider.autoDispose<String>((ref) => '');
