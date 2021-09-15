import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Auth.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Screens/CreateTweetScreen.dart';
import 'package:twitter_clone/Screens/Intro/WelcomeScreen.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';
import 'package:twitter_clone/Widget/TweetContainer.dart';

class HomeScreen extends StatelessWidget {
  final String currentUserId;
  final String visitedUserId;

  HomeScreen({
    Key? key,
    required this.currentUserId,
    required this.visitedUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Image.asset(
          'assets/images/TwitterLogo.png',
          width: 45,
          height: 45,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: StreamBuilder<QuerySnapshot>(
          stream: feedsRef
              .doc(currentUserId)
              .collection('followingUserTweets')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              children: [
                Container(
                  height: 83,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: usersRef.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox.shrink();
                      }
                      List<DocumentSnapshot> listSnap = snapshot.data!.docs;
                      /* ユーザー自身のアバターは表示リストから削除 → removeWhere */
                      listSnap.removeWhere((snapshot) =>
                          snapshot.get('userId') == currentUserId);
                      /* プロフィール画像を登録していないアバターは表示リストから削除 */
                      listSnap.removeWhere(
                          (snapshot) => snapshot.get('profileImage') == '');

                      return ListView.builder(
                        physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: listSnap.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                      currentUserId: currentUserId,
                                      visitedUserUserId:
                                          listSnap[index].get('userId'),
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: 57,
                                        width: 57,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: TwitterColor,
                                          // gradient: LinearGradient(
                                          //   begin: FractionalOffset.bottomLeft,
                                          //   end: FractionalOffset.topRight,
                                          //   colors: [
                                          //     Colors.red,
                                          //     Colors.yellow,
                                          //   ],
                                          // ),
                                        ),
                                      ),
                                      CircleAvatar(
                                        radius: 27,
                                        backgroundColor: Colors.white,
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
                                  SizedBox(height: 5),
                                  Text(listSnap[index].get('name')),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Container(
                  height: 3,
                  color: Colors.grey.shade300,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: allUserTweets.map((allTweets) {
                      Tweet tweet = Tweet.fromDoc(allTweets);
                      return TweetContainer(
                        currentUserId: currentUserId,
                        tweet: tweet,
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text('Hello'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            Container(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: Colors.grey,
                      size: 30,
                    ),
                    SizedBox(width: 25),
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.article_outlined,
                      color: Colors.grey,
                      size: 30,
                    ),
                    SizedBox(width: 25),
                    Text(
                      'Lists',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_fire_department_outlined,
                      color: Colors.grey,
                      size: 30,
                    ),
                    SizedBox(width: 25),
                    Text(
                      'Moment',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            Container(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  children: [
                    Icon(
                      Icons.wb_incandescent_outlined,
                      color: Colors.grey,
                      size: 30,
                    ),
                    SizedBox(width: 25),
                    Text(
                      'Twitter Advertisement',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            Container(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Setting and Privacy',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Help center',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      //title: ,
                      content: Text('Do you want to Logout?'),
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
                            'Logout',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            primary: Colors.red,
                          ),
                          onPressed: () {
                            Auth().logout();
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
              child: Container(
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
              ),
            ),
          );
        },
      ),
    );
  }
}
