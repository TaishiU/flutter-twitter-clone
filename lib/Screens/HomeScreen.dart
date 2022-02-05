import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Following.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Provider/TweetProvider.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Screens/CreateTweetScreen.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';
import 'package:twitter_clone/Widget/DrawerContainer.dart';
import 'package:twitter_clone/Widget/TweetContainer.dart';

class HomeScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final String? currentUserId = useProvider(currentUserIdProvider);
    final asyncFollowingAvatar = useProvider(followingAvatarStreamProvider);
    final asyncFollowingUserTweets =
        useProvider(followingUserTweetsStreamProvider);
    final _visitedUserIdNotifier = context.read(visitedUserIdProvider.notifier);
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
        title: Image.asset(
          'assets/images/TwitterLogo.png',
          width: 45,
          height: 45,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: IconButton(
              icon: Icon(
                Icons.auto_awesome,
                color: Colors.black,
              ),
              onPressed: () {
                showAdaptiveActionSheet(
                  context: context,
                  title: Container(
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.access_time,
                                size: 30,
                                color: TwitterColor,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 7,
                              child: Icon(
                                Icons.add,
                                size: 12,
                                color: Colors.pinkAccent,
                              ),
                            ),
                            Positioned(
                              top: 12,
                              right: 1,
                              child: Icon(
                                Icons.add,
                                size: 12,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Text(
                          'The latest Tweet will be displayed in the timeline.',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: <BottomSheetAction>[
                    BottomSheetAction(
                      leading: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: SvgPicture.asset(
                          'assets/images/SettingLogo.svg',
                          width: 23,
                          height: 23,
                        ),
                      ),
                      title: Text(
                        'Show content settings',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            width: 5,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: asyncFollowingUserTweets.when(
          loading: () => Center(child: const CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (List<Tweet> followingUserTweetsList) {
            if (followingUserTweetsList.length == 0) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
              );
            }
            return ListView(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              children: [
                asyncFollowingAvatar.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                  data: (List<Following> followingAvatarList) {
                    /* プロフィール画像を登録していないアバターは表示リストから削除 */
                    followingAvatarList.removeWhere(
                        (following) => following.profileImageUrl == '');

                    return followingAvatarList.length >= 1
                        ? Column(
                            children: [
                              Container(
                                height: 83,
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics(),
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: followingAvatarList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Following following =
                                        followingAvatarList[index];

                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 3),
                                      child: GestureDetector(
                                        onTap: () {
                                          /*visitedUserId情報を更新*/
                                          _visitedUserIdNotifier.update(
                                            userId: following.userId,
                                          );

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileScreen(),
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
                                                  ),
                                                ),
                                                CircleAvatar(
                                                  radius: 27,
                                                  backgroundColor: Colors.white,
                                                ),
                                                CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                    following.profileImageUrl,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Text(following.name),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                height: 3,
                                color: Colors.grey.shade300,
                              ),
                              SizedBox(height: 8),
                            ],
                          )
                        : SizedBox.shrink();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: followingUserTweetsList.map((tweet) {
                      return TweetContainer(
                        currentUserId: currentUserId!,
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
      drawer: DrawerContainer(),
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
              builder: (context) => CreateTweetScreen(),
            ),
          );
        },
      ),
    );
  }
}
