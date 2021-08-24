import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Screens/MessageScreen.dart';
import 'package:twitter_clone/Screens/Utils/HelperFunctions.dart';

class SelectChatUser extends StatefulWidget {
  final String currentUserId;
  const SelectChatUser({Key? key, required this.currentUserId})
      : super(key: key);

  @override
  _SelectChatUserState createState() => _SelectChatUserState();
}

class _SelectChatUserState extends State<SelectChatUser> {
  moveToChatScreen({
    required BuildContext context,
    required String currentUserId,
    required User peerUser,
  }) async {
    /*ユーザー自身のプロフィール*/
    DocumentSnapshot userProfileDoc =
        await Firestore().getUserProfile(userId: currentUserId);
    User currentUser = User.fromDoc(userProfileDoc);
    /*会話Id（トークルームのId）を取得する*/
    String convoId = HelperFunctions.getConvoIDFromHash(
      currentUser: currentUser,
      peerUser: peerUser,
    );
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

  Widget buildUserTile({required User peerUser}) {
    return ListTile(
      leading: CircleAvatar(
        radius: 23,
        backgroundColor: TwitterColor,
        backgroundImage: peerUser.profileImage.isEmpty
            ? null
            : NetworkImage(peerUser.profileImage),
      ),
      title: Text(peerUser.name),
      subtitle: Text('@${peerUser.bio}'),
      onTap: () {
        moveToChatScreen(
          context: context,
          currentUserId: widget.currentUserId,
          peerUser: peerUser,
        );
      },
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
          'Select user',
          style: TextStyle(
            color: TwitterColor,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<DocumentSnapshot> userListSnap = snapshot.data!.docs;
          userListSnap.removeWhere(
              (snapshot) => snapshot.get('userId') == widget.currentUserId);
          return ListView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: userListSnap.map((userSnap) {
              User peerUser = User.fromDoc(userSnap);
              return buildUserTile(peerUser: peerUser);
            }).toList(),
          );
        },
      ),
    );
  }
}
