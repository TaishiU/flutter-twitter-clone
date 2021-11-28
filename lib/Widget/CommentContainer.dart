import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Comment.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Repository/TweetRepository.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';

class CommentContainer extends HookWidget {
  final Comment comment;
  final Tweet tweet;

  CommentContainer({
    Key? key,
    required this.comment,
    required this.tweet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? currentUserId = useProvider(currentUserIdProvider);
    final TweetRepository _tweetRepository = TweetRepository();
    final _isOwner = comment.commentUserId == currentUserId;
    final _visitedUserIdNotifier = context.read(visitedUserIdProvider.notifier);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    /*visitedUserId情報を更新*/
                    _visitedUserIdNotifier.update(
                        userId: comment.commentUserId);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 23,
                    backgroundColor: comment.commentUserProfileImage.isEmpty
                        ? TwitterColor
                        : Colors.transparent,
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
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      _isOwner
                          ? GestureDetector(
                              onTap: () {
                                showAdaptiveActionSheet(
                                  context: context,
                                  title: SizedBox.shrink(),
                                  actions: <BottomSheetAction>[
                                    BottomSheetAction(
                                      leading: Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      title: Text(
                                        'Delete a comment',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      onPressed: () {
                                        _tweetRepository
                                            .deleteOwnCommentForTweet(
                                          comment: comment,
                                          tweetId: tweet.tweetId!,
                                          tweetAuthorId: tweet.authorId,
                                        );
                                        print('自身のコメントを削除しました！');
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                              child: Icon(
                                Icons.more_vert,
                                color: Colors.grey..shade600,
                                size: 20,
                              ),
                            )
                          : SizedBox.shrink(),
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
                              onTap: () {},
                              child: Icon(
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
