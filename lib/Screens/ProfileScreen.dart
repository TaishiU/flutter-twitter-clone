import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Screens/ChatScreen.dart';
import 'package:twitter_clone/Screens/CreateTweetScreen.dart';
import 'package:twitter_clone/Screens/EditProfileScreen.dart';
import 'package:twitter_clone/Screens/Utils/HelperFunctions.dart';
import 'package:twitter_clone/Widget/ListUserContainer.dart';
import 'package:twitter_clone/Widget/ProfileImageView.dart';
import 'package:twitter_clone/Widget/TweetContainer.dart';

class ProfileScreen extends StatefulWidget {
  final String currentUserId;
  final String visitedUserId;

  const ProfileScreen(
      {Key? key, required this.currentUserId, required this.visitedUserId})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _profileSegmentedValue = 0;
  bool _isFollowing = false;
  List<String> categories = ['Tweet', 'Media', 'Likes'];

  @override
  void initState() {
    super.initState();
    setupIsFollowing();
  }

  /*ユーザーをフォローしているか判断するメソッド*/
  setupIsFollowing() async {
    bool isFollowingUser = await Firestore().isFollowingUser(
      currentUserId: widget.currentUserId,
      visitedUserId: widget.visitedUserId,
    );
    if (mounted) {
      if (isFollowingUser == true) {
        setState(() {
          _isFollowing = true;
        });
      } else {
        setState(() {
          _isFollowing = false;
        });
      }
    }
  }

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
    2: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Likes',
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
              return Center(
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Text(
                      'There is no favorite tweet...',
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
              children: allFavoriteTweets.map((favoriteTweet) {
                Tweet tweet = Tweet.fromDoc(favoriteTweet);
                return TweetContainer(
                  currentUserId: widget.currentUserId,
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
        builder: (context) => ChatScreen(
          currentUserId: currentUserId,
          convoId: convoId,
          peerUser: peerUser,
        ),
      ),
    );
  }

  followUser({required User followersUser}) async {
    setState(() {
      _isFollowing = true;
    });
    DocumentSnapshot followingUserSnap =
        await Firestore().getUserProfile(userId: widget.currentUserId);
    User followingUser = User.fromDoc(followingUserSnap);

    await Firestore().followUser(
      followingUser: followingUser,
      followersUser: followersUser,
    );
  }

  unFollowUser({required User unFollowersUser}) async {
    setState(() {
      _isFollowing = false;
    });
    DocumentSnapshot unFollowingUserSnap =
        await Firestore().getUserProfile(userId: widget.currentUserId);
    User unFollowingUser = User.fromDoc(unFollowingUserSnap);

    await Firestore().unFollowUser(
      unFollowingUser: unFollowingUser,
      unFollowersUser: unFollowersUser,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _isOwner = widget.currentUserId == widget.visitedUserId;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/images/TwitterLogo.png',
          width: 45,
          height: 45,
        ),
      ),
      body: StreamBuilder(
        stream: usersRef.doc(widget.visitedUserId).snapshots(),
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
              GestureDetector(
                onTap: () {
                  if (user.coverImage.isNotEmpty)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileImageView(
                          tappedImageIndex: 0,
                          image: user.coverImage,
                        ),
                      ),
                    );
                },
                child: Container(
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
                ),
              ),
              Container(
                transform: Matrix4.translationValues(0, -40, 0),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (user.profileImage.isNotEmpty)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileImageView(
                                    tappedImageIndex: 0,
                                    image: user.profileImage,
                                  ),
                                ),
                              );
                          },
                          child: Stack(
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
                        ),
                        _isOwner
                            ? OutlinedButton(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: TwitterColor,
                                    ),
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  primary: Colors.black,
                                  shape: StadiumBorder(),
                                  side: BorderSide(
                                    color: TwitterColor,
                                    width: 2,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditProfileScreen(user: user),
                                    ),
                                  );
                                },
                              )
                            : _isFollowing
                                ? Row(
                                    children: [
                                      ElevatedButton(
                                        child: Icon(
                                          Icons.mail_outline,
                                          color: TwitterColor,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          onPrimary: Colors.black,
                                          shape: CircleBorder(
                                            side: BorderSide(
                                              color: TwitterColor,
                                              width: 1,
                                              style: BorderStyle.solid,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          moveToChatScreen(
                                            context: context,
                                            currentUserId: widget.currentUserId,
                                            peerUser: user,
                                          );
                                        },
                                      ),
                                      ElevatedButton(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            'Following',
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
                                          unFollowUser(unFollowersUser: user);
                                        },
                                      ),
                                    ],
                                  )
                                : OutlinedButton(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Text(
                                        'Follow',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: TwitterColor,
                                        ),
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      primary: Colors.black,
                                      shape: StadiumBorder(),
                                      side: BorderSide(
                                        color: TwitterColor,
                                        width: 2,
                                      ),
                                    ),
                                    onPressed: () {
                                      followUser(followersUser: user);
                                    },
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
                    user.bio.isEmpty
                        ? SizedBox.shrink()
                        : Text(
                            '@${user.bio}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          child: StreamBuilder(
                            stream: usersRef
                                .doc(widget.visitedUserId)
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
                                        title: 'Following User',
                                        currentUserId: widget.currentUserId,
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
                                .doc(widget.visitedUserId)
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
                                        currentUserId: widget.currentUserId,
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
                    // SizedBox(height: 20),
                    // Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   child: CupertinoSlidingSegmentedControl(
                    //     groupValue: _profileSegmentedValue,
                    //     thumbColor: TwitterColor,
                    //     backgroundColor: Colors.transparent,
                    //     children: _profileTabs,
                    //     onValueChanged: (index) {
                    //       setState(() {
                    //         _profileSegmentedValue = index as int;
                    //       });
                    //     },
                    //   ),
                    // ),
                    SizedBox(height: 20),
                    Container(
                      height: 30,
                      color: Colors.transparent,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _profileSegmentedValue = index;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 36),
                              child: Column(
                                children: [
                                  Text(
                                    categories[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: _profileSegmentedValue == index
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    height: 3,
                                    width: 50,
                                    color: _profileSegmentedValue == index
                                        ? TwitterColor
                                        : Colors.transparent,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(),
                    buildProfileWidget(user: user),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: _isOwner
          ? FloatingActionButton(
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
                    ),
                  ),
                );
              },
            )
          : SizedBox.shrink(),
    );
  }
}
