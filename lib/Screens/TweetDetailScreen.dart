import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Comment.dart';
import 'package:twitter_clone/Model/Likes.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Provider/TweetProvider.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Repository/TweetRepository.dart';
import 'package:twitter_clone/Repository/UserRepository.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';
import 'package:twitter_clone/Service/StorageService.dart';
import 'package:twitter_clone/ViewModel/IsFollowingNotifier.dart';
import 'package:twitter_clone/ViewModel/IsLikedNotifier.dart';
import 'package:twitter_clone/ViewModel/TweetCommentNotifier.dart';
import 'package:twitter_clone/Widget/CommentContainer.dart';
import 'package:twitter_clone/Widget/CommentUserContainer.dart';
import 'package:twitter_clone/Widget/LikesUserContainer.dart';
import 'package:twitter_clone/Widget/TweetImage.dart';

class TweetDetailScreen extends HookWidget {
  final Tweet tweet;

  TweetDetailScreen({
    Key? key,
    required this.tweet,
  }) : super(key: key);

  final _formkey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String? currentUserId = useProvider(currentUserIdProvider);
    final String _comment = useProvider(commentProvider).state;
    final asyncAllTweetComments = useProvider(allTweetCommentsProvider(tweet));
    final asyncAllTweetLikes = useProvider(allTweetLikesProvider(tweet));
    final asyncShare = useProvider(shareProvider(tweet));
    final isLikedState = useProvider(isLikedProvider);
    final _isLiked = isLikedState.isLikedTweet;
    final _visitedUserIdNotifier = context.read(visitedUserIdProvider.notifier);
    final _isFollowingNotifier = context.read(isFollowingProvider.notifier);
    final _isLikedNotifier = context.read(isLikedProvider.notifier);
    final _tweetCommentNotifier = context.read(tweetCommentProvider.notifier);
    final UserRepository _userRepository = UserRepository();
    final TweetRepository _tweetRepository = TweetRepository();
    final StorageService _storageService = StorageService();
    final _isOwner = tweet.authorId == currentUserId;
    final FocusNode _focusNode = FocusNode();

    useEffect(() {
      _isLikedNotifier.setupIsLiked(tweet: tweet);
    }, []);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: BackButton(color: Colors.black),
        title: Text(
          'Tweet',
          style: TextStyle(
            color: TwitterColor,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                /*visitedUserId情報を更新*/
                                _visitedUserIdNotifier.update(
                                  userId: tweet.authorId,
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        tweet.authorProfileImage.isEmpty
                                            ? TwitterColor
                                            : Colors.transparent,
                                    backgroundImage:
                                        tweet.authorProfileImage.isEmpty
                                            ? null
                                            : CachedNetworkImageProvider(
                                                tweet.authorProfileImage,
                                              ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tweet.authorName,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        '@${tweet.authorBio}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                bool _isFollowingUser =
                                    await _userRepository.isFollowingUser(
                                  currentUserId: currentUserId!,
                                  visitedUserId: tweet.authorId,
                                );

                                _isOwner
                                    ? showAdaptiveActionSheet(
                                        context: context,
                                        title: SizedBox.shrink(),
                                        actions: <BottomSheetAction>[
                                          BottomSheetAction(
                                            leading: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              child: Icon(
                                                Icons.push_pin,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            title: Text(
                                              'Fixed display in profile',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            onPressed: () {},
                                          ),
                                          BottomSheetAction(
                                            leading: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            title: Text(
                                              'Delete a tweet',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            onPressed: () {
                                              _tweetRepository.deleteTweet(
                                                currentUserId: currentUserId,
                                                tweet: tweet,
                                              );
                                              _storageService.deleteTweetImage(
                                                imagesPath: tweet.imagesPath,
                                              );
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      )
                                    : showAdaptiveActionSheet(
                                        context: context,
                                        title: SizedBox.shrink(),
                                        actions: <BottomSheetAction>[
                                          BottomSheetAction(
                                            leading: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              child: Icon(
                                                _isFollowingUser == true
                                                    ? Icons.person_add_disabled
                                                    : Icons.person_add,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            title: Text(
                                              _isFollowingUser == true
                                                  ? 'Unfollow ${tweet.authorName}'
                                                  : 'Follow ${tweet.authorName}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            onPressed: () {
                                              if (_isFollowingUser == true) {
                                                _isFollowingNotifier
                                                    .unFollowUserFromTweet(
                                                  tweet: tweet,
                                                );
                                                Navigator.of(context).pop();
                                              } else {
                                                _isFollowingNotifier
                                                    .followUserFromTweet(
                                                  tweet: tweet,
                                                );
                                                Navigator.of(context).pop();
                                              }
                                            },
                                          ),
                                          BottomSheetAction(
                                            leading: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            title: Text(
                                              'Delete a tweet',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            onPressed: () {
                                              _tweetRepository.deleteTweet(
                                                currentUserId: currentUserId,
                                                tweet: tweet,
                                              );
                                              _storageService.deleteTweetImage(
                                                imagesPath: tweet.imagesPath,
                                              );
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
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          tweet.text,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 10),
                        tweet.imagesUrl.isEmpty
                            ? SizedBox.shrink()
                            : TweetImage(
                                tweet: tweet,
                                containerHeight: 200,
                                containerWith:
                                    MediaQuery.of(context).size.width,
                                imageHeight: 98,
                                imageWith:
                                    MediaQuery.of(context).size.width * 0.452,
                              ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Text(
                              '${tweet.timestamp.toDate().year.toString()}/${tweet.timestamp.toDate().month.toString()}/${tweet.timestamp.toDate().day.toString()}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              DateFormat("HH:mm").format(
                                /* DateTimeに変換 → toDate() */
                                tweet.timestamp.toDate(),
                              ),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Divider(),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6),
                              child: asyncAllTweetLikes.when(
                                loading: () => SizedBox.shrink(),
                                error: (error, stack) =>
                                    Center(child: Text('Error: $error')),
                                data: (List<Likes> allTweetLikesList) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              LikesUserContainer(
                                            title: 'Liked by',
                                            allTweetLikesList:
                                                allTweetLikesList,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          allTweetLikesList.length.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(' Likes'),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 20),
                            Container(
                              padding: EdgeInsets.all(6),
                              child: asyncAllTweetComments.when(
                                loading: () => SizedBox.shrink(),
                                error: (error, stack) =>
                                    Center(child: Text('Error: $error')),
                                data: (List<Comment> allTweetCommentsList) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CommentUserContainer(
                                                  title: 'Commented by',
                                                  allTweetCommentsList:
                                                      allTweetCommentsList),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          allTweetCommentsList.length
                                              .toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(' Comments'),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.mode_comment_outlined,
                                color: Colors.grey.shade600,
                              ),
                              onPressed: () {},
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              icon: Icon(
                                Icons.repeat,
                                color: Colors.grey.shade600,
                              ),
                              onPressed: () {},
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              icon: _isLiked == true
                                  ? Icon(Icons.favorite)
                                  : Icon(Icons.favorite_border),
                              color: _isLiked == true
                                  ? Colors.red
                                  : Colors.grey.shade600,
                              onPressed: () {
                                _isLikedNotifier.likeOrUnLikeTweet(
                                    tweet: tweet);
                              },
                            ),
                            SizedBox(width: 10),
                            Container(
                              child: asyncShare.when(
                                loading: () => Icon(
                                  Icons.share,
                                  color: Colors.grey.shade600,
                                ),
                                error: (error, stack) => Center(
                                    child: Text('ShareUri Error: $error')),
                                data: (shareUri) {
                                  Uri uri = shareUri;
                                  return IconButton(
                                    icon: Icon(
                                      Icons.share,
                                      color: Colors.grey.shade600,
                                    ),
                                    onPressed: () {
                                      Share.share(
                                        '${tweet.text}\n\n${uri.toString()}',
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        // Divider(),
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    child: asyncAllTweetComments.when(
                      loading: () => SizedBox.shrink(),
                      error: (error, stack) =>
                          Center(child: Text('Error: $error')),
                      data: (List<Comment> allTweetCommentsList) {
                        return ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: allTweetCommentsList.map((comment) {
                            return CommentContainer(
                              comment: comment,
                              tweet: tweet,
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 70,
                    color: Colors.transparent,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
              ),
              child: Padding(
                padding:
                    EdgeInsets.only(right: 20, left: 20, top: 5, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Form(
                        key: _formkey,
                        child: TextFormField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: 'Comment for tweet',
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.only(bottom: 11),
                          ),
                          validator: (String? input) {
                            if (input!.isEmpty) {
                              return 'You can\'t comment without text.';
                            }
                            return null;
                          },
                          onChanged: (input) {
                            context.read(commentProvider).state = input;
                            print('_comment: $_comment');
                          },
                          focusNode: _focusNode,
                        ),
                      ),
                    ),
                    _commentController.text.length > 0
                        ? GestureDetector(
                            onTap: () {
                              _tweetCommentNotifier.handleComment(
                                tweet: tweet,
                                commentText: _comment,
                              );
                              _commentController.clear();
                              _focusNode.unfocus();
                            },
                            child: Icon(
                              Icons.send_rounded,
                              color: Colors.blue,
                            ),
                          )
                        : Icon(
                            Icons.send_rounded,
                            color: Colors.grey,
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
