import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Model/Message.dart';
import 'package:twitter_clone/Widget/ChatImage.dart';

class ChatContainer extends StatelessWidget {
  final String currentUserId;
  final String peerUserId;
  final String peerUserProfileImage;
  final Message message;
  ChatContainer({
    Key? key,
    required this.currentUserId,
    required this.peerUserId,
    required this.message,
    required this.peerUserProfileImage,
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
          GestureDetector(
            onTap: () {
              /*メッセージ削除のアラート*/
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Delete message'),
                    content: Text('Do you want to delete this message?'),
                    actions: [
                      TextButton(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          primary: Colors.red,
                        ),
                        onPressed: () async {
                          await messagesRef
                              .doc(message.convoId)
                              .collection('allMessages')
                              .doc(message.timestamp.toString())
                              .delete();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: message.content != null && message.hasImage == false
                /*テキストのみの場合*/
                ? Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 3),
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        color: TwitterColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        message.content!,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                /*画像がある場合*/
                : Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 3),
                      child: ChatImage(
                        currentUserId: currentUserId,
                        message: message,
                        containerHeight: 230,
                        containerWith: 200,
                        imageHeight: 113,
                        imageWith: 98,
                      ),
                    ),
                  ),
          ),
        ],
      );
    } else if (message.idFrom == peerUserId && message.idTo == currentUserId) {
      /*相手ユーザーのメッセージは左側に表示*/
      return Container(
        margin: EdgeInsets.symmetric(vertical: 3),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 10),
                CircleAvatar(
                  radius: 18,
                  backgroundImage: peerUserProfileImage.isEmpty
                      ? null
                      : NetworkImage(peerUserProfileImage),
                ),
                message.content != null && message.hasImage == false
                    ? Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            message.content!,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 3),
                          child: ChatImage(
                            currentUserId: currentUserId,
                            message: message,
                            containerHeight: 230,
                            containerWith: 200,
                            imageHeight: 113,
                            imageWith: 98,
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
