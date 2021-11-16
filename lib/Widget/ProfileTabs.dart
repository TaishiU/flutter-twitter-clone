import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Screens/CreateTweetScreen.dart';
import 'package:twitter_clone/Widget/TweetContainer.dart';

class ProfileTabs extends HookWidget {
  final User user;
  ProfileTabs({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? currentUserId = useProvider(currentUserIdProvider);
    final int _profileIndex = useProvider(profileIndexProvider);

    switch (_profileIndex) {
      case 0:
        return StreamBuilder<QuerySnapshot>(
          stream: usersRef
              .doc(user.userId)
              .collection('tweets')
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
              return currentUserId == user.userId
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 30),
                            Text(
                              'You have\'t tweeted yet',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'If you tweet, it will be displayed here.',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 15),
                            ElevatedButton(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'Create Tweet',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: TwitterColor,
                                onPrimary: Colors.black,
                                shape: StadiumBorder(),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateTweetScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 30),
                            Text(
                              'There are no tweets.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
            }
            return ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: allUserTweets.map((userTweets) {
                Tweet tweet = Tweet.fromDoc(userTweets);
                return TweetContainer(
                  currentUserId: currentUserId!,
                  tweet: tweet,
                );
              }).toList(),
            );
          },
        );
        break;
      case 1:
        return StreamBuilder<QuerySnapshot>(
          stream: usersRef
              .doc(user.userId)
              .collection('tweets')
              .where('hasImage', isEqualTo: true) /*画像があるツイートを取得*/
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            List<DocumentSnapshot> allUserMediaTweets = snapshot.data!.docs;
            if (allUserMediaTweets.length == 0) {
              return currentUserId == user.userId
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 30),
                            Text(
                              'You haven\'t tweeted with an image yet',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'If you tweet with an image, it will be displayed here.',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 15),
                            ElevatedButton(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'Create Tweet',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: TwitterColor,
                                onPrimary: Colors.black,
                                shape: StadiumBorder(),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateTweetScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 30),
                            Text(
                              'There are no tweets with an image.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
            }
            return ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: allUserMediaTweets.map((userTweet) {
                Tweet tweet = Tweet.fromDoc(userTweet);
                return TweetContainer(
                  currentUserId: currentUserId!,
                  tweet: tweet,
                );
              }).toList(),
            );
          },
        );
        break;
      case 2:
        return StreamBuilder<QuerySnapshot>(
          stream: usersRef
              .doc(user.userId)
              .collection('favorite')
              /*いいねを押した瞬間のタイム順*/
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            List<DocumentSnapshot> allFavoriteTweets = snapshot.data!.docs;
            if (allFavoriteTweets.length == 0) {
              return currentUserId == user.userId
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 30),
                            Text(
                              'There are no tweets you\'ve liked yet.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'If you tap the heart of a tweet you like,\nit will be displayed here.',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 30),
                            Text(
                              'There are no tweets that\n${user.name} have liked yet.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
            }
            return ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: allFavoriteTweets.map((favoriteTweet) {
                Tweet tweet = Tweet.fromDoc(favoriteTweet);
                return TweetContainer(
                  currentUserId: currentUserId!,
                  tweet: tweet,
                );
              }).toList(),
            );
          },
        );
        break;
      default:
        return Center(
          child: Text(
            'user profile tweets wrong',
            style: TextStyle(fontSize: 25),
          ),
        );
        break;
    }
  }
}
