import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';

class SearchUserScreen extends StatefulWidget {
  final String currentUserId;

  const SearchUserScreen({Key? key, required this.currentUserId})
      : super(key: key);

  @override
  _SearchUserScreenState createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  Future<QuerySnapshot>? _users;
  TextEditingController _searchController = TextEditingController();

  Widget buildUserTile({required User user}) {
    return ListTile(
      leading: CircleAvatar(
        radius: 23,
        backgroundColor: TwitterColor,
        backgroundImage:
            user.profileImage.isEmpty ? null : NetworkImage(user.profileImage),
      ),
      title: Text(user.name),
      subtitle: Text('@${user.bio}'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              currentUserId: widget.currentUserId,
              visitedUserId: user.userId,
            ),
          ),
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
        centerTitle: true,
        elevation: 0.5,
        title: Container(
          height: 40,
          width: MediaQuery.of(context).size.width * 0.7,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextFormField(
            autofocus: true,
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.black,
                ),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _users = null;
                  });
                },
              ),
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
      body: _users == null
          // ? Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Icon(Icons.search, size: 150),
          //         Text(
          //           'Search user...',
          //           style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
          //         )
          //       ],
          //     ),
          //   )
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
                /*ユーザー自身のアバターは削除*/
                userListSnap.removeWhere((snapshot) =>
                    snapshot.get('userId') == widget.currentUserId);
                return ListView(
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  children: userListSnap.map((userSnap) {
                    User user = User.fromDoc(userSnap);
                    return buildUserTile(user: user);
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
                return ListView(
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  children: usersListSnap.map((usersList) {
                    User user = User.fromDoc(usersList);
                    return buildUserTile(user: user);
                  }).toList(),
                );
              },
            ),
    );
  }
}
