import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Message.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Repository/MessageRepository.dart';
import 'package:twitter_clone/Service/StorageService.dart';
import 'package:twitter_clone/Widget/ChatImage.dart';

class ChatContainer extends HookWidget {
  final String peerUserId;
  final String peerUserProfileImage;
  final Message message;

  ChatContainer({
    Key? key,
    required this.peerUserId,
    required this.message,
    required this.peerUserProfileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? currentUserId = useProvider(currentUserIdProvider);
    final MessageRepository _messageRepository = MessageRepository();
    final StorageService _storageService = StorageService();

    if (!message.read && message.idTo == currentUserId) {
      /*会話を未読から既読へ変更*/
      _messageRepository.updateMessageRead(message: message);
    }
    if (message.idFrom == currentUserId && message.idTo == peerUserId) {
      /*ユーザー自身のメッセージは右側に表示*/
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onLongPress: () {
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
                          _messageRepository.deleteMessageForText(
                            message: message,
                          );
                          _storageService.deleteMessageForImage(
                            imagesPath: message.imagesPath,
                          );
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
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
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
                    ),
                  )
                /*画像がある場合*/
                : Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 3),
                      child: ChatImage(
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(width: 10),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: peerUserProfileImage.isEmpty
                      ? TwitterColor
                      : Colors.transparent,
                  backgroundImage: peerUserProfileImage.isEmpty
                      ? null
                      : NetworkImage(peerUserProfileImage),
                ),
                message.content != null && message.hasImage == false
                    ? Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.6,
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14, vertical: 9),
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
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 3),
                          child: ChatImage(
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
              'ChatContainer error...',
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
