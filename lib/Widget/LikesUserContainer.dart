import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Likes.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';

class LikesUserContainer extends HookWidget {
  final String title;
  final List<Likes> allTweetLikesList;

  LikesUserContainer({
    Key? key,
    required this.title,
    required this.allTweetLikesList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _visitedUserIdNotifier = context.read(visitedUserIdProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: BackButton(color: Colors.black),
        title: Text(
          title,
          style: TextStyle(
            color: TwitterColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.transparent,
            height: 7,
          ),
          ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: allTweetLikesList.map((likes) {
              return GestureDetector(
                onTap: () {
                  /*visitedUserId情報を更新*/
                  _visitedUserIdNotifier.update(userId: likes.likesUserId);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                    ),
                  );
                },
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 23,
                              backgroundColor:
                                  likes.likesUserProfileImage.isEmpty
                                      ? TwitterColor
                                      : Colors.transparent,
                              backgroundImage:
                                  likes.likesUserProfileImage.isEmpty
                                      ? null
                                      : CachedNetworkImageProvider(
                                          likes.likesUserProfileImage),
                            ),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  likes.likesUserName,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '@${likes.likesUserBio}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
