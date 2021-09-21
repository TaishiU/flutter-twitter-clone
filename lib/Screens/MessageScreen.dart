import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Model/GetLastMessage.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Screens/ChatScreen.dart';
import 'package:twitter_clone/Screens/SelectChatUserScreen.dart';
import 'package:twitter_clone/Widget/DrawerContainer.dart';

class MessageScreen extends StatelessWidget {
  final String currentUserId;
  final String visitedUserId;

  MessageScreen({
    Key? key,
    required this.currentUserId,
    required this.visitedUserId,
  }) : super(key: key);

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
        builder: (context) => ChatScreen(
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
        centerTitle: true,
        elevation: 0.5,
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectChatUserScreen(
                  currentUserId: currentUserId,
                ),
              ),
            );
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width * 0.7,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Text(
                'Search account',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        actions: [
          SvgPicture.asset(
            'assets/images/SettingLogo.svg',
            width: 23,
            height: 23,
          ),
          Container(
            width: 15,
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
          if (snapshot.data!.docs.length == 0) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Send or receive messages',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'You can send a message directly to Twitter users.\nSince you select the recipient and send it, it will not be published on the timeline.',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Write a message',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: TwitterColor,
                        onPrimary: Colors.black,
                        shape: StadiumBorder(),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectChatUserScreen(
                              currentUserId: currentUserId,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          List<DocumentSnapshot> listLastMessagesSnap = snapshot.data!.docs;
          return ListView(
            //shrinkWrap: true,
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
      drawer: DrawerContainer(
        currentUserId: currentUserId,
        visitedUserId: visitedUserId,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.mail_outline,
          size: 25,
        ),
        backgroundColor: TwitterColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectChatUserScreen(
                currentUserId: currentUserId,
              ),
            ),
          );
        },
      ),
    );
  }
}
