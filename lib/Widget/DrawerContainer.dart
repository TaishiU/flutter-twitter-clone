import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Screens/Intro/WelcomeScreen.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';
import 'package:twitter_clone/Service/AuthService.dart';
import 'package:twitter_clone/Widget/ListUserContainer.dart';

class DrawerContainer extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final String? currentUserId = useProvider(currentUserIdProvider);
    final String visitedUserId = useProvider(visitedUserIdProvider);
    final AuthService _authService = AuthService();

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: StreamBuilder(
              stream: usersRef.doc(currentUserId).snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return CircleAvatar(
                    radius: 28,
                    backgroundColor: TwitterColor,
                  );
                }
                User user = User.fromDoc(snapshot.data);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        /*visitedUserId情報を更新*/
                        context
                            .read(visitedUserIdProvider.notifier)
                            .update(userId: user.userId);
                        print('DrawerContainer, visitedUserId: $visitedUserId');

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 28,
                        backgroundImage: user.profileImage.isEmpty
                            ? null
                            : NetworkImage(user.profileImage),
                        backgroundColor: TwitterColor,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    user.bio.isEmpty
                        ? SizedBox.shrink()
                        : Text(
                            '@${user.bio}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Container(
                          child: StreamBuilder(
                            stream: usersRef
                                .doc(currentUserId)
                                .collection('following')
                                .orderBy('timestamp', descending: true)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return SizedBox.shrink();
                              }
                              List<DocumentSnapshot> followingUserList =
                                  snapshot.data!.docs;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ListUserContainer(
                                        title: 'Following',
                                        currentUserId: currentUserId!,
                                        listUserDocumentSnap: followingUserList,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      followingUserList.length.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Following',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        //fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          child: StreamBuilder(
                            stream: usersRef
                                .doc(currentUserId)
                                .collection('followers')
                                .orderBy('timestamp', descending: true)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return SizedBox.shrink();
                              }
                              List<DocumentSnapshot> followersUserList =
                                  snapshot.data!.docs;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ListUserContainer(
                                        title: 'Followers',
                                        currentUserId: currentUserId!,
                                        listUserDocumentSnap: followersUserList,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      followersUserList.length.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Followers',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        //fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                ),
              );
            },
            child: drawerIconContainer(
              icon: Icons.person_outline,
              title: 'profile',
            ),
          ),
          drawerIconContainer(
            icon: Icons.article_outlined,
            title: 'Lists',
          ),
          drawerIconContainer(
            icon: Icons.where_to_vote_outlined,
            title: 'Topic',
          ),
          drawerIconContainer(
            icon: Icons.bookmark_border,
            title: 'Bookmark',
          ),
          drawerIconContainer(
            icon: Icons.local_fire_department_outlined,
            title: 'Moment',
          ),
          drawerIconContainer(
            icon: Icons.attach_money,
            title: 'Earn Money',
          ),
          Divider(),
          drawerTextContainer(
            title: 'Setting and Privacy',
            color: Colors.black,
          ),
          drawerTextContainer(
            title: 'Help center',
            color: Colors.black,
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Logout'),
                    content: Text(
                        'Are you sure you want to log out?\nAll Twitter data will be deleted from this device.'),
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
                          primary: Colors.black,
                        ),
                        onPressed: () {
                          _authService.logout();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WelcomeScreen(),
                              ),
                              (_) => false);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: drawerTextContainer(
              title: 'Logout',
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget drawerIconContainer({
    required IconData icon,
    required String title,
  }) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.grey,
              size: 30,
            ),
            SizedBox(width: 25),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget drawerTextContainer({
    required String title,
    required Color color,
  }) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: color,
          ),
        ),
      ),
    );
  }
}
