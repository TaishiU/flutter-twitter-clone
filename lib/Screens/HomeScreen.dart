import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Auth.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Screens/CreateTweetScreen.dart';
import 'package:twitter_clone/Screens/Intro/WelcomeScreen.dart';
import 'package:twitter_clone/Widget/TweetContainer.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserId;
  final String visitedUserId;

  HomeScreen(
      {Key? key, required this.currentUserId, required this.visitedUserId})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: Image.asset(
          'assets/images/TwitterLogo.png',
          width: 45,
          height: 45,
        ),
        title: Text(
          'Twitter',
          style: TextStyle(
            color: TwitterColor,
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(
              Icons.logout,
              color: TwitterColor,
              size: 25,
            ),
            itemBuilder: (_) {
              return <PopupMenuItem<String>>[
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Logout'),
                    ],
                  ),
                  value: 'logout',
                )
              ];
            },
            onSelected: (selectedItem) {
              if (selectedItem == 'logout') {
                Auth().logout();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()));
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: StreamBuilder(
          stream: usersRef.doc(widget.currentUserId).snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            User user = User.fromDoc(snapshot.data);
            return StreamBuilder<QuerySnapshot>(
              stream: allTweetsRef
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<DocumentSnapshot> allUserTweets = snapshot.data!.docs;
                if (allUserTweets.length == 0) {
                  return Center(
                    child: Text('There is no tweet...'),
                  );
                }
                return ListView(
                  //shrinkWrap: true,
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  children: allUserTweets.map((allTweets) {
                    Tweet tweet = Tweet.fromDoc(allTweets);
                    return TweetContainer(
                      currentUserId: widget.currentUserId,
                      tweet: tweet,
                      user: user,
                    );
                  }).toList(),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: Container(
        child: StreamBuilder(
          stream: usersRef.doc(widget.currentUserId).snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return SizedBox.shrink();
            }
            User user = User.fromDoc(snapshot.data);
            return FloatingActionButton(
              backgroundColor: TwitterColor,
              child: Image.asset(
                'assets/images/TweetLogo.png',
                fit: BoxFit.cover,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateTweetScreen(
                      currentUserId: widget.currentUserId,
                      user: user,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
