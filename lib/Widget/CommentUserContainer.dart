import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Comment.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';

class CommentUserContainer extends HookWidget {
  final String title;
  final List<DocumentSnapshot> commentListForTweet;

  CommentUserContainer({
    Key? key,
    required this.title,
    required this.commentListForTweet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            color: Colors.white,
            height: 7,
          ),
          ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: commentListForTweet.map((commentForTweet) {
              Comment comment = Comment.fromDoc(commentForTweet);
              return GestureDetector(
                onTap: () {
                  /*visitedUserId情報を更新*/
                  context
                      .read(visitedUserIdProvider.notifier)
                      .update(userId: comment.commentUserId);

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
                              backgroundColor: TwitterColor,
                              backgroundImage:
                                  comment.commentUserProfileImage.isEmpty
                                      ? null
                                      : NetworkImage(
                                          comment.commentUserProfileImage),
                            ),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment.commentUserName,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '@${comment.commentUserBio}',
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
