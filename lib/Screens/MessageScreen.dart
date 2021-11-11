import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/GetLastMessage.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Repository/UserRepository.dart';
import 'package:twitter_clone/Screens/ChatScreen.dart';
import 'package:twitter_clone/Screens/SelectChatUserScreen.dart';
import 'package:twitter_clone/Widget/DrawerContainer.dart';

class MessageScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final String? currentUserId = useProvider(currentUserIdProvider);
    final UserRepository _userRepository = UserRepository();

    moveToChatScreen({
      required BuildContext context,
      required String convoId,
      required String peerUserId,
    }) async {
      /*相手ユーザーのプロフィール*/
      DocumentSnapshot userProfileDoc =
          await _userRepository.getUserProfile(userId: peerUserId);
      User peerUser = User.fromDoc(userProfileDoc);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            convoId: convoId,
            peerUser: peerUser,
          ),
        ),
      );
    }

    Widget buildUserTile({
      required BuildContext context,
      required GetLastMessage getLastMessage,
    }) {
      /*user1Idがユーザー自身のidと一致するか*/
      final _isOwner = currentUserId == getLastMessage.user1Id;
      final _notRead =
          !getLastMessage.read && getLastMessage.idTo == currentUserId;
      return ListTile(
        leading: CircleAvatar(
          radius: 23,
          backgroundImage: _isOwner
              ? NetworkImage(getLastMessage.user2ProfileImage)
              : NetworkImage(getLastMessage.user1ProfileImage),
        ),
        title: Text(
          _isOwner ? getLastMessage.user2Name : getLastMessage.user1Name,
          style: TextStyle(
            fontWeight: _notRead ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: DefaultTextStyle(
          style: TextStyle(color: Colors.black),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          child: getLastMessage.content != null
              ? Text(
                  getLastMessage.content!,
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
                      '${getLastMessage.userFrom} sent the image.',
                      style: TextStyle(
                        fontWeight:
                            _notRead ? FontWeight.bold : FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
        ),
        trailing: Text(
          '${getLastMessage.timestamp.toDate().month.toString()}/${getLastMessage.timestamp.toDate().day.toString()}',
          style: TextStyle(
            fontWeight: _notRead ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {
          moveToChatScreen(
            context: context,
            convoId: getLastMessage.convoId!,
            peerUserId:
                _isOwner ? getLastMessage.user2Id : getLastMessage.user1Id,
          );
        },
      );
    }

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
                  currentUserId: currentUserId!,
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
                              currentUserId: currentUserId!,
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
      drawer: DrawerContainer(),
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
                currentUserId: currentUserId!,
              ),
            ),
          );
        },
      ),
    );
  }
}
