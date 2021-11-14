import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Model/Comment.dart';
import 'package:twitter_clone/Provider/TweetProvider.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';

class CommentContainer extends HookWidget {
  final Comment comment;

  CommentContainer({
    Key? key,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool _isLiked = useProvider(isLikedProvider);

    likeTweet() {
      if (_isLiked) {
        context.read(isLikedProvider.notifier).update(isLiked: false);
      } else {
        context.read(isLikedProvider.notifier).update(isLiked: true);
      }
    }

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
                  child: CircleAvatar(
                    radius: 23,
                    backgroundColor: Colors.transparent,
                    backgroundImage: comment.commentUserProfileImage.isEmpty
                        ? null
                        : NetworkImage(comment.commentUserProfileImage),
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
                              builder: (context) => ProfileScreen(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              comment.commentUserName,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              '@${comment.commentUserBio}・',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '${comment.timestamp.toDate().month.toString()}/${comment.timestamp.toDate().day.toString()}',
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
                    comment.commentText,
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
