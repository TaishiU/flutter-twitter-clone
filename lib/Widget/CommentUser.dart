import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Comment.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';

class CommentUser extends StatefulWidget {
  final String currentUserId;
  final List<DocumentSnapshot> commentListForTweet;

  CommentUser({
    Key? key,
    required this.currentUserId,
    required this.commentListForTweet,
  }) : super(key: key);

  @override
  _CommentUserState createState() => _CommentUserState();
}

class _CommentUserState extends State<CommentUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'User',
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
            children: widget.commentListForTweet.map((commentForTweet) {
              Comment comment = Comment.fromDoc(commentForTweet);
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        currentUserId: widget.currentUserId,
                        visitedUserUserId: comment.commentUserId,
                      ),
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
                            Text(
                              comment.commentUserName,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
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
