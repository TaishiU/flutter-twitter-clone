import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Auth.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Screens/CreateTweetScreen.dart';
import 'package:twitter_clone/Screens/EditProfileScreen.dart';
import 'package:twitter_clone/Screens/Intro/WelcomeScreen.dart';
import 'package:twitter_clone/Widget/TweetContainer.dart';

class ProfileScreen extends StatefulWidget {
  final String currentUserId;
  final String visitedUserUserId;

  const ProfileScreen(
      {Key? key, required this.currentUserId, required this.visitedUserUserId})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _profileSegmentedValue = 0;

  Map<int, Widget> _profileTabs = <int, Widget>{
    0: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Tweet',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    ),
    1: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Media',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    ),
  };

  Widget buildProfileWidget({required User user}) {
    switch (_profileSegmentedValue) {
      case 0:
        return StreamBuilder<QuerySnapshot>(
          stream: tweetRef
              .doc(user.userId)
              .collection('allUserTweets')
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
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Text(
                      'There is no tweet...',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: allUserTweets.map((userTweets) {
                Tweet tweet = Tweet.fromDoc(userTweets);
                return TweetContainer(
                  currentUserId: widget.currentUserId,
                  user: user,
                  tweet: tweet,
                );
              }).toList(),
            );
          },
        );
        break;
      case 1:
        return StreamBuilder<QuerySnapshot>(
          stream: tweetRef
              .doc(user.userId)
              .collection('allUserTweets')
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
              return Center(
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Text(
                      'There is no media...',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: allUserMediaTweets.map((userTweet) {
                Tweet tweet = Tweet.fromDoc(userTweet);
                return TweetContainer(
                  currentUserId: widget.currentUserId,
                  user: user,
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

  @override
  Widget build(BuildContext context) {
    final isOwner = widget.currentUserId == widget.visitedUserUserId;

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: usersRef.doc(widget.visitedUserUserId).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          User user = User.fromDoc(snapshot.data);
          return ListView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: TwitterColor,
                  image: user.coverImage.isEmpty
                      ? null
                      : DecorationImage(
                          image: NetworkImage(user.coverImage),
                          fit: BoxFit.cover,
                        ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isOwner
                          ? PopupMenuButton(
                              icon: Icon(
                                Icons.more_horiz,
                                color: Colors.white,
                                size: 30,
                              ),
                              itemBuilder: (_) {
                                return <PopupMenuItem<String>>[
                                  PopupMenuItem(
                                    child: Text('Logout'),
                                    value: 'logout',
                                  )
                                ];
                              },
                              onSelected: (selectedItem) {
                                if (selectedItem == 'logout') {
                                  Auth().logout();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              WelcomeScreen()));
                                }
                              },
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
              Container(
                transform: Matrix4.translationValues(0, -45, 0),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 45,
                              backgroundColor: Colors.white,
                            ),
                            CircleAvatar(
                              radius: 42,
                              backgroundImage: user.profileImage.isEmpty
                                  ? null
                                  : NetworkImage(user.profileImage),
                              backgroundColor: TwitterColor,
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditProfileScreen(user: user)),
                            );
                          },
                          child: Container(
                            width: 100,
                            height: 35,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: TwitterColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: TwitterColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      user.bio,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Row(
                          children: [
                            Text(
                              '324',
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
                        SizedBox(width: 20),
                        Row(
                          children: [
                            Text(
                              '352',
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
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: CupertinoSlidingSegmentedControl(
                        groupValue: _profileSegmentedValue,
                        thumbColor: TwitterColor,
                        //backgroundColor: Colors.grey.shade400,
                        backgroundColor: Colors.transparent,
                        children: _profileTabs,
                        onValueChanged: (index) {
                          setState(() {
                            _profileSegmentedValue = index as int;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    buildProfileWidget(user: user),
                  ],
                ),
              ),
              // buildProfileWidget(user: user),
            ],
          );
        },
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
