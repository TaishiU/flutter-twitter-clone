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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Row(
          children: [
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.6,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              decoration: BoxDecoration(
                // color: Colors.grey.shade100,
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: Text(
                  'Search...',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: TwitterColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ],
        ),
        // title: Text(
        //   'Select user',
        //   style: TextStyle(
        //     color: TwitterColor,
        //   ),
        // ),
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
