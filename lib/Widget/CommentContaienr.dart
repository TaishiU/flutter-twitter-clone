import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Model/Comment.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';

class CommentContainer extends StatefulWidget {
  final String currentUserId;
  final Comment comment;

  const CommentContainer({
    Key? key,
    required this.currentUserId,
    required this.comment,
  }) : super(key: key);

  @override
  _CommentContainerState createState() => _CommentContainerState();
}

class _CommentContainerState extends State<CommentContainer> {
  bool _isLiked = false;

  likeTweet() {
    if (_isLiked) {
      setState(() {
        _isLiked = false;
      });
    } else {
      setState(() {
        _isLiked = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              currentUserId: widget.currentUserId,
                              visitedUserUserId: widget.comment.commentUserId,
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 23,
                        backgroundColor: TwitterColor,
                        backgroundImage:
                            widget.comment.commentUserProfileImage.isEmpty
                                ? null
                                : NetworkImage(
                                    widget.comment.commentUserProfileImage),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.73,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                    currentUserId: widget.currentUserId,
                                    visitedUserUserId:
                                        widget.comment.commentUserId,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  widget.comment.commentUserName,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  '${widget.comment.timestamp.toDate().month.toString()}/${widget.comment.timestamp.toDate().day.toString()}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton(
                            icon: Icon(
                              Icons.more_horiz,
                              color: Colors.grey.shade500,
                              size: 25,
                            ),
                            itemBuilder: (_) {
                              return <PopupMenuItem<String>>[
                                PopupMenuItem(
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          color: Colors.redAccent,
                                        ),
                                        Text('Delete'),
                                      ],
                                    ),
                                  ),
                                  value: 'Delete',
                                )
                              ];
                            },
                            onSelected: (selectedItem) {
                              if (selectedItem == 'Delete') {
                                Firestore().deleteTweet(
                                  userId: widget.currentUserId,
                                  postId: widget.comment.commentId!,
                                );
                              }
                            },
                          )
                        ],
                      ),
                      Text('commentId: ${widget.comment.commentId.toString()}'),
                      Text(
                        widget.comment.commentText,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.mode_comment_outlined,
                              color: Colors.black,
                            ),
                            onPressed: () {},
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            icon: Icon(Icons.repeat),
                            onPressed: () {},
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            icon: _isLiked
                                ? Icon(Icons.favorite)
                                : Icon(Icons.favorite_border),
                            color: _isLiked ? Colors.red : Colors.black,
                            onPressed: () {
                              likeTweet();
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      // Divider(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
