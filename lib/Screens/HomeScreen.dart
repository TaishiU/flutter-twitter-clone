import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Auth.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Screens/CreateTweetScreen.dart';
import 'package:twitter_clone/Screens/Intro/WelcomeScreen.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';
import 'package:twitter_clone/Widget/TweetContainer.dart';

class HomeScreen extends StatelessWidget {
  final String currentUserId;
  final String visitedUserId;

  HomeScreen(
      {Key? key, required this.currentUserId, required this.visitedUserId})
      : super(key: key);

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
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: StreamBuilder(
          stream: usersRef.doc(currentUserId).snapshots(),
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
                  children: [
                    Container(
                      height: 70,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: usersRef.snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return SizedBox.shrink();
                          }
                          List<DocumentSnapshot> listSnap = snapshot.data!.docs;
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: listSnap.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfileScreen(
                                            currentUserId: currentUserId,
                                            visitedUserUserId:
                                                listSnap[index].get('userId')),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: 55,
                                        width: 55,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.yellow,
                                          gradient: LinearGradient(
                                            begin: FractionalOffset.bottomLeft,
                                            end: FractionalOffset.topRight,
                                            colors: [
                                              Colors.red,
                                              Colors.yellow,
                                            ],
                                          ),
                                        ),
                                      ),
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundColor: TwitterColor,
                                        backgroundImage: NetworkImage(
                                          listSnap[index].get('profileImage'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Column(
                      children: allUserTweets.map((allTweets) {
                        Tweet tweet = Tweet.fromDoc(allTweets);
                        return TweetContainer(
                          currentUserId: currentUserId,
                          tweet: tweet,
                          user: user,
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: Container(
        child: StreamBuilder(
          stream: usersRef.doc(currentUserId).snapshots(),
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
                      currentUserId: currentUserId,
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
