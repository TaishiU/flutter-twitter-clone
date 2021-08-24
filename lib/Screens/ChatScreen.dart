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
          'Chat',
          style: TextStyle(
            color: TwitterColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SelectChatUser(currentUserId: currentUserId),
                ),
              );
            },
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
              final _isOwner = currentUserId == getLastMessage.user1Id;
              /*user1Idがユーザー自身のidと一致するか*/
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      moveToChatScreen(
                        context: context,
                        convoId: getLastMessage.convoId!,
                        peerUserId: _isOwner
                            ? getLastMessage.user2Id
                            : getLastMessage.user1Id,
                      );
                    },
                    child: Container(
                      /*未読状態のメッセージには背景色(青色)を設定する*/
                      color: !getLastMessage.read &&
                              getLastMessage.idTo == currentUserId
                          ? Colors.yellow
                          : Colors.transparent,
                      height: 80,
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.blue,
                                backgroundImage: _isOwner
                                    ? NetworkImage(
                                        getLastMessage.user2ProfileImage)
                                    : NetworkImage(
                                        getLastMessage.user1ProfileImage),
                              ),
                              SizedBox(width: 20),
                              Container(
                                color: Colors.transparent,
                                width: MediaQuery.of(context).size.width * 0.69,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _isOwner
                                              ? getLastMessage.user2Name
                                              : getLastMessage.user1Name,
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(getLastMessage.content),
                                      ],
                                    ),
                                    Text(
                                      '${getLastMessage.timestamp.toDate().month.toString()}/${getLastMessage.timestamp.toDate().day.toString()}',
                                    ),
                                  ],
                                ),
                              ),
                              //SizedBox(width: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
