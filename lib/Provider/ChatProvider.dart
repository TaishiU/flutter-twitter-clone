import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/LastMessage.dart';
import 'package:twitter_clone/Model/Message.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';

final messageTextProvider = StateProvider.autoDispose<String>((ref) => '');

final convoIdProvider = StateNotifierProvider<ConvoIdController, String>(
  (ref) => ConvoIdController(''),
);

class ConvoIdController extends StateNotifier<String> {
  ConvoIdController(String convoId) : super(convoId);
  void update({required String convoId}) => state = convoId;
}

//return LastMessage Model(List)
final lastMessagesStreamProvider =
    StreamProvider.autoDispose<List<LastMessage>>((ref) {
  final currentUserId = ref.watch(userIdStreamProvider).data?.value;
  return messagesRef
      .orderBy('timestamp', descending: true)
      .where('users', arrayContains: currentUserId)
      .snapshots()
      .map(_queryToLastMessageList);
});

List<LastMessage> _queryToLastMessageList(QuerySnapshot query) {
  return query.docs.map((doc) {
    LastMessage lastMessage = LastMessage.fromDoc(doc);
    return lastMessage;
  }).toList();
}

//return Message Model(List)
final userMessagesStreamProvider = StreamProvider<List<Message>>((ref) {
  final convoId = ref.watch(convoIdProvider);
  return messagesRef
      .doc(convoId)
      .collection('allMessages')
      .orderBy('timestamp', descending: false)
      .snapshots()
      .map(_queryToMessageList);
});

final unReadMessageProvider =
    StreamProvider.family<List<Message>, String>((ref, convoId) {
  return messagesRef
      .doc(convoId)
      .collection('allMessages')
      .where('read', isEqualTo: false) /*未読メッセージを取得*/
      .snapshots()
      .map(_queryToMessageList);
});

List<Message> _queryToMessageList(QuerySnapshot query) {
  return query.docs.map((doc) {
    Message message = Message.fromDoc(doc);
    return message;
  }).toList();
}
