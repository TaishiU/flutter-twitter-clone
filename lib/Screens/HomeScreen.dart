import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Screens/CreateTweetScreen.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';
import 'package:twitter_clone/Widget/DrawerContainer.dart';
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
                    stream: usersRef.limit(8).snapshots(),
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
                                      visitedUserId:
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
      drawer: DrawerContainer(
        currentUserId: currentUserId,
        visitedUserId: visitedUserId,
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
