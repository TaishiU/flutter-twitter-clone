import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Screens/HomeScreen.dart';
import 'package:twitter_clone/Screens/NotificationsScreen.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';
import 'package:twitter_clone/Screens/SearchScreen.dart';

class FeedScreen extends StatefulWidget {
  final String currentUserId;
  FeedScreen({required this.currentUserId});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        HomeScreen(
          currentUserId: widget.currentUserId,
          visitedUserId: widget.currentUserId,
        ),
        SearchScreen(
          currentUserId: widget.currentUserId,
        ),
        NotificationsScreen(
          currentUserId: widget.currentUserId,
        ),
        ProfileScreen(
          currentUserId: widget.currentUserId,
          visitedUserUserId: widget.currentUserId,
        ),
      ].elementAt(_selectedTab),
      bottomNavigationBar: CupertinoTabBar(
        onTap: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        activeColor: TwitterColor,
        currentIndex: _selectedTab,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications)),
          BottomNavigationBarItem(icon: Icon(Icons.person)),
          // BottomNavigationBarItem(
          //   icon: Container(
          //     child: StreamBuilder(
          //       stream: usersRef.doc(widget.currentUserId).snapshots(),
          //       builder: (BuildContext context, AsyncSnapshot snapshot) {
          //         if (!snapshot.hasData) {
          //           return CircleAvatar(
          //             radius: 20,
          //             backgroundColor: TwitterColor,
          //             backgroundImage: null,
          //           );
          //         }
          //         User user = User.fromDoc(snapshot.data);
          //         return CircleAvatar(
          //           radius: 20,
          //           backgroundImage: NetworkImage(user.profileImage),
          //         );
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
