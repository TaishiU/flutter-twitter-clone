import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Model/GetLastMessage.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Screens/MessageScreen.dart';
import 'package:twitter_clone/Screens/SelectChatUser.dart';

class ChatScreen extends StatelessWidget {
  final String currentUserId;
  ChatScreen({Key? key, required this.currentUserId}) : super(key: key);

  Widget buildUserTile({
    required BuildContext context,
    required GetLastMessage getLastMessage,
  }) {
    /*user1Idがユーザー自身のidと一致するか*/
    final _isOwner = currentUserId == getLastMessage.user1Id;
    return Container(
      /*未読状態のメッセージには背景色(青色)を設定する*/
      color: !getLastMessage.read && getLastMessage.idTo == currentUserId
          ? TwitterColor
          : Colors.transparent,
      child: ListTile(
        leading: CircleAvatar(
          radius: 23,
          backgroundColor: TwitterColor,
          backgroundImage: _isOwner
              ? NetworkImage(getLastMessage.user2ProfileImage)
              : NetworkImage(getLastMessage.user1ProfileImage),
        ),
        title: Text(
          _isOwner ? getLastMessage.user2Name : getLastMessage.user1Name,
        ),
        subtitle: DefaultTextStyle(
          style: TextStyle(color: Colors.black),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          child: Text(getLastMessage.content),
        ),
        trailing: Text(
          '${getLastMessage.timestamp.toDate().month.toString()}/${getLastMessage.timestamp.toDate().day.toString()}',
        ),
        onTap: () {
          moveToChatScreen(
            context: context,
            convoId: getLastMessage.convoId!,
            peerUserId:
                _isOwner ? getLastMessage.user2Id : getLastMessage.user1Id,
          );
        },
      ),
    );
  }

  moveToChatScreen({
    required BuildContext context,
    required String convoId,
    required String peerUserId,
  }) async {
    /*相手ユーザーのプロフィール*/
    DocumentSnapshot userProfileDoc =
        await Firestore().getUserProfile(userId: peerUserId);
    User peerUser = User.fromDoc(userProfileDoc);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageScreen(
          currentUserId: currentUserId,
          convoId: convoId,
          peerUser: peerUser,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          'Message',
          style: TextStyle(
            color: TwitterColor,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SelectChatUser(currentUserId: currentUserId),
                  ),
                );
              },
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                ),
                child: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: messagesRef
            .orderBy('timestamp', descending: true)
            .where('users', arrayContains: currentUserId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<DocumentSnapshot> listLastMessagesSnap = snapshot.data!.docs;
          return ListView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: listLastMessagesSnap.map((message) {
              GetLastMessage getLastMessage = GetLastMessage.fromDoc(message);
              return buildUserTile(
                context: context,
                getLastMessage: getLastMessage,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
