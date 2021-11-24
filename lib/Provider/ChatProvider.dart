import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';

final messageTextProvider = StateProvider.autoDispose<String>((ref) => '');

final lastMessagesStreamProvider = StreamProvider.autoDispose((ref) {
  final currentUserId = ref.watch(userIdStreamProvider).data?.value;
  return messagesRef
      .orderBy('timestamp', descending: true)
      .where('users', arrayContains: currentUserId)
      .snapshots();
});

final convoIdProvider = StateNotifierProvider<ConvoIdController, String>(
  (ref) => ConvoIdController(''),
);

class ConvoIdController extends StateNotifier<String> {
  ConvoIdController(String convoId) : super(convoId);
  void update({required String convoId}) => state = convoId;
}

final userMessagesStreamProvider = StreamProvider((ref) {
  final convoId = ref.watch(convoIdProvider);
  return messagesRef
      .doc(convoId)
      .collection('allMessages')
      .orderBy('timestamp', descending: false)
      .snapshots();
});

final unReadMessageProvider =
    StreamProvider.family<QuerySnapshot<Map<String, dynamic>>, String>(
        (ref, convoId) {
  return messagesRef
      .doc(convoId)
      .collection('allMessages')
      .where('read', isEqualTo: false) /*未読メッセージを取得*/
      .snapshots();
});
