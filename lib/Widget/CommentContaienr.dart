import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
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
    return Column(
      children: [
        Row(
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
                          visitedUserId: widget.comment.commentUserId,
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 23,
                    backgroundColor: TwitterColor,
                    backgroundImage: widget
                            .comment.commentUserProfileImage.isEmpty
                        ? null
                        : NetworkImage(widget.comment.commentUserProfileImage),
                  ),
                ),
              ],
            ),
            SizedBox(width: 10),
            Container(
              width: MediaQuery.of(context).size.width * 0.77,
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
                                visitedUserId: widget.comment.commentUserId,
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
                              '@${widget.comment.commentUserBio}・',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '${widget.comment.timestamp.toDate().month.toString()}/${widget.comment.timestamp.toDate().day.toString()}',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.grey..shade600,
                          size: 20,
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
                          if (selectedItem == 'Delete') {}
                        },
                      )
                    ],
                  ),
                  Text(
                    widget.comment.commentText,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.mode_comment_outlined,
                              size: 20,
                              color: Colors.grey.shade600,
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                        SizedBox(width: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.repeat,
                              size: 20,
                              color: Colors.grey.shade600,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                likeTweet();
                              },
                              child: _isLiked
                                  ? Icon(
                                      Icons.favorite,
                                      size: 20,
                                      color: Colors.red,
                                    )
                                  : Icon(
                                      Icons.favorite_border,
                                      size: 20,
                                      color: Colors.grey.shade600,
                                    ),
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.share,
                          size: 20,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}
