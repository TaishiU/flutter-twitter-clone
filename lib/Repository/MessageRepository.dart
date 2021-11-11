import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Message.dart';
import 'package:twitter_clone/Model/User.dart';

class MessageRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void>? sendMessage({
    required User currentUser,
    required User peerUser,
    required Message message,
  }) {
    final DocumentReference convoDoc = messagesRef.doc(message.convoId);

    convoDoc.set({
      'user1Id': currentUser.userId,
      /*ユーザー自身*/
      'user2Id': peerUser.userId,
      /*相手ユーザー*/
      'user1Name': currentUser.name,
      'user2Name': peerUser.name,
      'user1ProfileImageUrl': currentUser.profileImageUrl,
      'user2ProfileImageUrl': peerUser.profileImageUrl,
      'convoId': message.convoId,
      'userFrom': message.userFrom,
      'userTo': message.userTo,
      'idFrom': message.idFrom,
      'idTo': message.idTo,
      'timestamp': message.timestamp,
      'content': message.content,
      'imagesUrl': message.imagesUrl,
      'imagesPath': message.imagesPath,
      'hasImage': message.hasImage,
      'read': false,
      'users': [currentUser.userId, peerUser.userId],
    });

    final DocumentReference messageDoc = messagesRef
        .doc(message.convoId)
        .collection('allMessages')
        .doc(message.timestamp.toString());

    /*トランザクション処理*/
    _firestore.runTransaction((Transaction transaction) async {
      transaction.set(
        messageDoc,
        {
          'convoId': message.convoId,
          'userFrom': message.userFrom,
          'userTo': message.userTo,
          'idFrom': message.idFrom,
          'idTo': message.idTo,
          'timestamp': message.timestamp,
          'content': message.content,
          'imagesUrl': message.imagesUrl,
          'imagesPath': message.imagesPath,
          'hasImage': message.hasImage,
          'read': false,
        },
      );
    });
  }

  Future<void> deleteMessageForText({
    required Message message,
  }) async {
    await messagesRef
        .doc(message.convoId)
        .collection('allMessages')
        .doc(message.timestamp.toString())
        .delete();
  }

  Future<void>? updateMessageRead({
    required Message message,
  }) async {
    DocumentReference convoDoc = messagesRef.doc(message.convoId);
    await convoDoc.set(
      {'read': true},
      SetOptions(merge: true),
    );

    DocumentReference documentReference = messagesRef
        .doc(message.convoId)
        .collection('allMessages')
        .doc(message.timestamp.toString());
    await documentReference.set(
      {'read': true},
      SetOptions(merge: true),
    );
  }
}
