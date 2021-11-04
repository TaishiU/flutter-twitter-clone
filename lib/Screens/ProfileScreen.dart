import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Screens/ChatScreen.dart';
import 'package:twitter_clone/Screens/CreateTweetScreen.dart';
import 'package:twitter_clone/Screens/EditProfileScreen.dart';
import 'package:twitter_clone/Screens/Utils/HelperFunctions.dart';
import 'package:twitter_clone/Widget/ListUserContainer.dart';
import 'package:twitter_clone/Widget/ProfileImageView.dart';
import 'package:twitter_clone/Widget/TweetContainer.dart';

class ProfileScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final String? currentUserId = useProvider(currentUserIdProvider);
    final String visitedUserId = useProvider(visitedUserIdProvider);
    final bool _isFollowing = useProvider(isFollowingProvider);
    final int _profileIndex = useProvider(profileIndexProvider);

    List<String> popUpMenuTitle = [
      'Share',
      'Draft',
      'View Lists',
      'View Moments',
      'QR code'
    ];
    List<String> categories = ['Tweet', 'Media', 'Likes'];

    /*ユーザーをフォローしているか判断するメソッド*/
    setupIsFollowing() async {
      bool isFollowingUser = await Firestore().isFollowingUser(
        currentUserId: currentUserId!,
        visitedUserId: visitedUserId,
      );

      if (isFollowingUser == true) {
        context.read(isFollowingProvider.notifier).update(isFollowing: true);
      } else {
        context.read(isFollowingProvider.notifier).update(isFollowing: false);
      }
    }

    useEffect(() {
      setupIsFollowing();
    }, []);

    Widget buildProfileWidget({required User user}) {
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
                                      builder: (context) => CreateTweetScreen(
                                        currentUserId: currentUserId!,
                                      ),
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
                                      builder: (context) => CreateTweetScreen(
                                        currentUserId: currentUserId!,
                                      ),
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
      context.read(isFollowingProvider.notifier).update(isFollowing: true);
      DocumentSnapshot followingUserSnap =
          await Firestore().getUserProfile(userId: currentUserId!);
      User followingUser = User.fromDoc(followingUserSnap);

      await Firestore().followUser(
        followingUser: followingUser,
        followersUser: followersUser,
      );
    }

    unFollowUser({required User unFollowersUser}) async {
      context.read(isFollowingProvider.notifier).update(isFollowing: false);
      DocumentSnapshot unFollowingUserSnap =
          await Firestore().getUserProfile(userId: currentUserId!);
      User unFollowingUser = User.fromDoc(unFollowingUserSnap);

      await Firestore().unFollowUser(
        unFollowingUser: unFollowingUser,
        unFollowersUser: unFollowersUser,
      );
    }

    final _isOwner = currentUserId == visitedUserId;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(color: Colors.black),
        title: Image.asset(
          'assets/images/TwitterLogo.png',
          width: 45,
          height: 45,
        ),
      ),
      body: StreamBuilder(
        stream: usersRef.doc(visitedUserId).snapshots(),
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PopupMenuButton(
                          icon: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black54,
                            ),
                            child: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          itemBuilder: (BuildContext context) {
                            return popUpMenuTitle.map((String title) {
                              return PopupMenuItem(
                                child: Text(title),
                                value: title,
                              );
                            }).toList();
                          },
                          onSelected: (selectedItem) {
                            if (selectedItem == 'Share') {}
                          },
                        ),
                      ],
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
                                    'Edit Profile',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  primary: Colors.black,
                                  shape: StadiumBorder(),
                                  side: BorderSide(
                                    color: Colors.grey.shade400,
                                    width: 1,
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
                                          color: Colors.black,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          onPrimary: Colors.black,
                                          shape: CircleBorder(
                                            side: BorderSide(
                                              color: Colors.grey.shade400,
                                              width: 1,
                                              style: BorderStyle.solid,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          moveToChatScreen(
                                            context: context,
                                            currentUserId: currentUserId!,
                                            peerUser: user,
                                          );
                                        },
                                      ),
                                      OutlinedButton(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Text(
                                            'Following',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          primary: Colors.black,
                                          shape: StadiumBorder(),
                                          side: BorderSide(
                                            color: Colors.grey.shade400,
                                            width: 1,
                                          ),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Unfollow'),
                                                content: Text(
                                                    'Do you want to Unfollow ${user.name}?'),
                                                actions: [
                                                  TextButton(
                                                    child: Text(
                                                      'No',
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
                                                      primary: Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      unFollowUser(
                                                        unFollowersUser: user,
                                                      );
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                : ElevatedButton(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        'Follow',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.black,
                                      onPrimary: Colors.black,
                                      shape: StadiumBorder(),
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
                                .doc(visitedUserId)
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
                                .doc(visitedUserId)
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
                    SizedBox(height: 20),
                    Container(
                      height: 30,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              context
                                  .read(profileIndexProvider.notifier)
                                  .update(index: index);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 38),
                              child: Column(
                                children: [
                                  Text(
                                    categories[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: _profileIndex == index
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    height: 3,
                                    width: 50,
                                    color: _profileIndex == index
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
                    SizedBox(height: 5),
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
                      currentUserId: currentUserId!,
                    ),
                  ),
                );
              },
            )
          : SizedBox.shrink(),
    );
  }
}
