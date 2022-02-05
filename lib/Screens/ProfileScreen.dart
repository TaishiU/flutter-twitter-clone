import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/ListUser.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/ChatProvider.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Repository/UserRepository.dart';
import 'package:twitter_clone/Screens/ChatScreen.dart';
import 'package:twitter_clone/Screens/CreateTweetScreen.dart';
import 'package:twitter_clone/Screens/EditProfileScreen.dart';
import 'package:twitter_clone/Screens/Utils/HelperFunctions.dart';
import 'package:twitter_clone/ViewModel/IsFollowingNotifier.dart';
import 'package:twitter_clone/Widget/ListUserContainer.dart';
import 'package:twitter_clone/Widget/ProfileImageView.dart';
import 'package:twitter_clone/Widget/ProfileTabs.dart';

class ProfileScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final String? currentUserId = useProvider(currentUserIdProvider);
    final String visitedUserId = useProvider(visitedUserIdProvider);
    final asyncUserProfile =
        useProvider(userProfileStreamProvider(visitedUserId));
    final asyncFollowing = useProvider(followingStreamProvider(visitedUserId));
    final asyncFollowers = useProvider(followersStreamProvider(visitedUserId));
    final isFollowingState = useProvider(isFollowingProvider);
    final _isFollowing = isFollowingState.isFollowingUser;
    final _isFollowingNotifier = context.read(isFollowingProvider.notifier);
    final int _profileIndex = useProvider(profileIndexProvider);
    final UserRepository _userRepository = UserRepository();

    List<String> popUpMenuTitle = [
      'Share',
      'Draft',
      'View Lists',
      'View Moments',
      'QR code'
    ];
    List<String> categories = ['Tweet', 'Media', 'Likes'];

    useEffect(() {
      _isFollowingNotifier.setupIsFollowing(visitedUserId: visitedUserId);
    }, []);

    moveToChatScreen({
      required BuildContext context,
      required String currentUserId,
      required User peerUser,
    }) async {
      /*ユーザー自身のプロフィール*/
      DocumentSnapshot userProfileDoc =
          await _userRepository.getUserProfile(userId: currentUserId);
      User currentUser = User.fromDoc(userProfileDoc);
      /*会話Id（トークルームのId）を取得する*/
      String convoId = HelperFunctions.getConvoIDFromHash(
        currentUser: currentUser,
        peerUser: peerUser,
      );

      // convoId情報を更新
      context.read(convoIdProvider.notifier).update(convoId: convoId);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            peerUser: peerUser,
          ),
        ),
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
      body: asyncUserProfile.when(
        loading: () => CircularProgressIndicator(),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (User user) {
          return ListView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: [
              GestureDetector(
                onTap: () {
                  if (user.coverImageUrl.isNotEmpty)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileImageView(
                          tappedImageIndex: 0,
                          image: user.coverImageUrl,
                        ),
                      ),
                    );
                },
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: user.coverImageUrl.isEmpty
                        ? TwitterColor
                        : Colors.transparent,
                    image: user.coverImageUrl.isEmpty
                        ? null
                        : DecorationImage(
                            image:
                                CachedNetworkImageProvider(user.coverImageUrl),
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
                            if (user.profileImageUrl.isNotEmpty)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileImageView(
                                    tappedImageIndex: 0,
                                    image: user.profileImageUrl,
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
                                backgroundColor: user.profileImageUrl.isEmpty
                                    ? TwitterColor
                                    : Colors.transparent,
                                backgroundImage: user.profileImageUrl.isEmpty
                                    ? null
                                    : CachedNetworkImageProvider(
                                        user.profileImageUrl),
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
                                                      _isFollowingNotifier
                                                          .unFollowUserFromProfile(
                                                              visitedUserId:
                                                                  visitedUserId);
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
                                      _isFollowingNotifier
                                          .followUserFromProfile(
                                              visitedUserId: visitedUserId);
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
                          child: asyncFollowing.when(
                            loading: () => SizedBox.shrink(),
                            error: (error, stack) =>
                                Center(child: Text('Error: $error')),
                            data: (List<ListUser> followingList) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ListUserContainer(
                                        title: 'Following',
                                        listUserDocumentSnap: followingList,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      followingList.length.toString(),
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
                          child: asyncFollowers.when(
                            loading: () => SizedBox.shrink(),
                            error: (error, stack) =>
                                Center(child: Text('Error: $error')),
                            data: (List<ListUser> followersList) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ListUserContainer(
                                        title: 'Followers',
                                        listUserDocumentSnap: followersList,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      followersList.length.toString(),
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
                    ProfileTabs(user: user),
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
                    builder: (context) => CreateTweetScreen(),
                  ),
                );
              },
            )
          : SizedBox.shrink(),
    );
  }
}
