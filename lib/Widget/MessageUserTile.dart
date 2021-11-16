import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Model/LastMessage.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/ChatProvider.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Repository/UserRepository.dart';
import 'package:twitter_clone/Screens/ChatScreen.dart';

class MessageUserTile extends HookWidget {
  final LastMessage lastMessage;
  MessageUserTile({
    Key? key,
    required this.lastMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? currentUserId = useProvider(currentUserIdProvider);
    final UserRepository _userRepository = UserRepository();

    /*user1Idがユーザー自身のidと一致するか*/
    final _isOwner = currentUserId == lastMessage.user1Id;
    final _notRead = !lastMessage.read && lastMessage.idTo == currentUserId;
    return ListTile(
      leading: CircleAvatar(
        radius: 23,
        backgroundColor: Colors.transparent,
        backgroundImage: _isOwner
            ? NetworkImage(lastMessage.user2ProfileImage)
            : NetworkImage(lastMessage.user1ProfileImage),
      ),
      title: Text(
        _isOwner ? lastMessage.user2Name : lastMessage.user1Name,
        style: TextStyle(
          fontWeight: _notRead ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: DefaultTextStyle(
        style: TextStyle(color: Colors.black),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        child: lastMessage.content != null
            ? Text(
                lastMessage.content!,
                style: TextStyle(
                  fontWeight: _notRead ? FontWeight.bold : FontWeight.normal,
                  color: Colors.black,
                ),
              )
            : _isOwner
                ? Text(
                    'You sent the image.',
                    style: TextStyle(
                      fontWeight:
                          _notRead ? FontWeight.bold : FontWeight.normal,
                      color: Colors.grey,
                    ),
                  )
                : Text(
                    '${lastMessage.userFrom} sent the image.',
                    style: TextStyle(
                      fontWeight:
                          _notRead ? FontWeight.bold : FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
      ),
      trailing: Text(
        '${lastMessage.timestamp.toDate().month.toString()}/${lastMessage.timestamp.toDate().day.toString()}',
        style: TextStyle(
          fontWeight: _notRead ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () async {
        /*相手ユーザーのプロフィール*/
        DocumentSnapshot userProfileDoc = await _userRepository.getUserProfile(
          userId: _isOwner ? lastMessage.user2Id : lastMessage.user1Id,
        );
        User peerUser = User.fromDoc(userProfileDoc);
        // convoId情報を更新
        context
            .read(convoIdProvider.notifier)
            .update(convoId: lastMessage.convoId!);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              peerUser: peerUser,
            ),
          ),
        );
      },
    );
  }
}