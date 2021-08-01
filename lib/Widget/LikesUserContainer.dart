import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Likes.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';

class LikesUserContainer extends StatefulWidget {
  final String title;
  final String currentUserId;
  final List<DocumentSnapshot> likesListForTweet;

  LikesUserContainer({
    Key? key,
    required this.title,
    required this.currentUserId,
    required this.likesListForTweet,
  }) : super(key: key);

  @override
  _LikesUserContainerState createState() => _LikesUserContainerState();
}

class _LikesUserContainerState extends State<LikesUserContainer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.title,
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
            children: widget.likesListForTweet.map((likesForTweet) {
              Likes likes = Likes.fromDoc(likesForTweet);
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        currentUserId: widget.currentUserId,
                        visitedUserUserId: likes.likesUserId,
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
                              backgroundImage: likes
                                      .likesUserProfileImage.isEmpty
                                  ? null
                                  : NetworkImage(likes.likesUserProfileImage),
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
