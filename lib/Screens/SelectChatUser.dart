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
  Future<QuerySnapshot>? _users;
  TextEditingController _searchController = TextEditingController();

  // Widget buildUserTile({required User user}) {
  //   return ListTile(
  //     leading: CircleAvatar(
  //       radius: 23,
  //       backgroundColor: TwitterColor,
  //       backgroundImage:
  //           user.profileImage.isEmpty ? null : NetworkImage(user.profileImage),
  //     ),
  //     title: Text(user.name),
  //     subtitle: Text('@${user.bio}'),
  //     onTap: () {
  //       // Navigator.push(
  //       //   context,
  //       //   MaterialPageRoute(
  //       //     builder: (context) => ProfileScreen(
  //       //       currentUserId: widget.currentUserId,
  //       //       visitedUserUserId: user.userId,
  //       //     ),
  //       //   ),
  //       // );
  //     },
  //   );
  // }

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
        centerTitle: true,
        elevation: 0.5,
        title: Container(
          height: 40,
          width: MediaQuery.of(context).size.width * 0.7,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          decoration: BoxDecoration(
            //color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextFormField(
            autofocus: true,
            //controller: textEditingController,
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(bottom: 8),
            ),
            onChanged: (String name) {
              if (name.isNotEmpty) {
                setState(() {
                  _users = Firestore().searchUsers(name: name);
                });
              }
            },
          ),
        ),
      ),
      body: _users == null
          ? StreamBuilder<QuerySnapshot>(
              stream: usersRef.limit(5).snapshots(),
              /*リミットは5件*/
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<DocumentSnapshot> userListSnap = snapshot.data!.docs;
                userListSnap.removeWhere((snapshot) =>
                    snapshot.get('userId') == widget.currentUserId);
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
            )
          : FutureBuilder(
              future: _users,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data!.docs.length == 0) {
                  return Center(
                    child: Text(
                      'No users found!',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                    ),
                  );
                }
                List<DocumentSnapshot> usersListSnap = snapshot.data!.docs;
                /* ユーザー自身は表示リストから削除 → removeWhere */
                usersListSnap.removeWhere((snapshot) =>
                    snapshot.get('userId') == widget.currentUserId);
                return ListView(
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  children: usersListSnap.map((usersList) {
                    User peerUser = User.fromDoc(usersList);
                    return buildUserTile(peerUser: peerUser);
                  }).toList(),
                );
              },
            ),
      // body: StreamBuilder<QuerySnapshot>(
      //   stream: usersRef.snapshots(),
      //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if (!snapshot.hasData) {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //     List<DocumentSnapshot> userListSnap = snapshot.data!.docs;
      //     userListSnap.removeWhere(
      //         (snapshot) => snapshot.get('userId') == widget.currentUserId);
      //     return ListView(
      //       physics: BouncingScrollPhysics(
      //         parent: AlwaysScrollableScrollPhysics(),
      //       ),
      //       children: userListSnap.map((userSnap) {
      //         User peerUser = User.fromDoc(userSnap);
      //         return buildUserTile(peerUser: peerUser);
      //       }).toList(),
      //     );
      //   },
      // ),
    );
  }
}
