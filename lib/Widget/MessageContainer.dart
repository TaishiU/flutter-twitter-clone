import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Model/Message.dart';

class MessageContainer extends StatelessWidget {
  final String currentUserId;
  final String peerUserId;
  final Message message;
  MessageContainer({
    Key? key,
    required this.currentUserId,
    required this.peerUserId,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!message.read && message.idTo == currentUserId) {
      /*会話を未読から既読へ変更*/
      Firestore().updateMessageRead(message: message);
    }
    if (message.idFrom == currentUserId && message.idTo == peerUserId) {
      /*ユーザー自身のメッセージは右側に表示*/
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await messagesRef
                  .doc(message.convoId)
                  .collection('allMessages')
                  .doc(message.timestamp.toString())
                  .delete();
              print('削除しました！');
            },
          ),
          Container(
            width: 200,
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Bubble(
              color: Colors.blue,
              elevation: 0,
              padding: BubbleEdges.all(10.0),
              nip: BubbleNip.rightTop,
              child: Text(
                message.content,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    } else if (message.idFrom == peerUserId && message.idTo == currentUserId) {
      /*相手ユーザーのメッセージは左側に表示*/
      return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200.0,
                  margin: EdgeInsets.only(left: 10.0),
                  child: Bubble(
                    color: Colors.yellow,
                    elevation: 0,
                    padding: const BubbleEdges.all(10.0),
                    nip: BubbleNip.leftTop,
                    child: Text(
                      message.content,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
    return Container(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 100),
            Text(
              'error!!!',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
