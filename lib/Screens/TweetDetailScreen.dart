import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Comment.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/TweetProvider.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Repository/TweetRepository.dart';
import 'package:twitter_clone/Repository/UserRepository.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';
import 'package:twitter_clone/Service/DynamicLinkService.dart';
import 'package:twitter_clone/Service/StorageService.dart';
import 'package:twitter_clone/ViewModel/SetupNotifier.dart';
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
    // final _isLiked = useProvider(isLikedProvider);
    final setupState = useProvider(setupProvider);
    final _isLiked = setupState.isLikedTweet;
    final String _comment = useProvider(commentProvider).state;
    final _visitedUserIdNotifier = context.read(visitedUserIdProvider.notifier);
    final _setupNotifier = context.read(setupProvider.notifier);
    final UserRepository _userRepository = UserRepository();
    final TweetRepository _tweetRepository = TweetRepository();
    final StorageService _storageService = StorageService();
    final DynamicLinkService _dynamicLinkService = DynamicLinkService();
    final _isOwner = tweet.authorId == currentUserId;
    final FocusNode _focusNode = FocusNode();

    /*ツイートにいいねをしているか判断するメソッド*/
    // setupIsLiked() async {
    //   bool isLikedTweet = await _tweetRepository.isLikedTweet(
    //     currentUserId: currentUserId!,
    //     tweetAuthorId: tweet.authorId,
    //     tweetId: tweet.tweetId!,
    //   );
    //
    //   if (isLikedTweet == true) {
    //     print('TweetDetailScreen:「${tweet.text}」にいいねしています');
    //     context.read(isLikedProvider.notifier).update(isLiked: true);
    //     //print('isLikedTweet: $isLikedTweet');
    //     //print('!_isLiked: ${!_isLiked}');
    //     print('_isLiked: $_isLiked');
    //   } else {
    //     context.read(isLikedProvider.notifier).update(isLiked: false);
    //     print('TweetDetailScreen:「${tweet.text}」にいいねしていません...');
    //     //print('isLikedTweet: $isLikedTweet');
    //     //print('!_isLiked: ${!_isLiked}');
    //     print('_isLiked: $_isLiked');
    //   }
    // }

    useEffect(() {
      //print('初期状態の_isLiked: ${_isLiked}');
      //setupIsLiked();
      _setupNotifier.setupIsLiked(tweet: tweet);
    }, []);

    // if (_isLiked == true) {
    //   print('いいねしています');
    //   print('_isLiked: $_isLiked');
    // } else {
    //   print('いいねしていません...');
    //   print('_isLiked: $_isLiked');
    // }

    // likeOrUnLikeTweet() async {
    //   print('ボタン押した瞬間の_isLiked: $_isLiked');
    //   if (_isLiked == false) {
    //     /*いいねされていない時*/
    //     context.read(isLikedProvider.notifier).update(isLiked: true);
    //     print('いいね');
    //     print('_isLiked: $_isLiked');
    //     DocumentSnapshot userProfileDoc =
    //         await _userRepository.getUserProfile(userId: currentUserId!);
    //     User user = User.fromDoc(userProfileDoc);
    //     Likes likes = Likes(
    //       likesUserId: currentUserId,
    //       likesUserName: user.name,
    //       likesUserProfileImage: user.profileImageUrl,
    //       likesUserBio: user.bio,
    //       timestamp: Timestamp.fromDate(DateTime.now()),
    //     );
    //     _tweetRepository.likesForTweet(
    //       likes: likes,
    //       postId: tweet.tweetId!,
    //       postUserId: tweet.authorId,
    //     );
    //     _tweetRepository.favoriteTweet(
    //       currentUserId: currentUserId,
    //       name: user.name,
    //       tweet: tweet,
    //     );
    //   } else if (_isLiked == true) {
    //     /*いいねされている時*/
    //     context.read(isLikedProvider.notifier).update(isLiked: false);
    //     print('いいね外し');
    //     print('_isLiked: $_isLiked');
    //     DocumentSnapshot userProfileDoc =
    //         await _userRepository.getUserProfile(userId: currentUserId!);
    //     User user = User.fromDoc(userProfileDoc);
    //     _tweetRepository.unLikesForTweet(
    //       tweet: tweet,
    //       unlikesUser: user,
    //     );
    //   }
    // }

    handleComment() async {
      _formkey.currentState!.save();
      if (_formkey.currentState!.validate()) {
        DocumentSnapshot userProfileDoc =
            await _userRepository.getUserProfile(userId: currentUserId!);
        User user = User.fromDoc(userProfileDoc);
        Comment comment = Comment(
          commentUserId: currentUserId,
          commentUserName: user.name,
          commentUserProfileImage: user.profileImageUrl,
          commentUserBio: user.bio,
          commentText: _comment,
          timestamp: Timestamp.fromDate(DateTime.now()),
        );

        _tweetRepository.commentForTweet(
          comment: comment,
          postId: tweet.tweetId!,
          postUserId: tweet.authorId,
        );
      }
    }

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
                                    backgroundColor: Colors.transparent,
                                    backgroundImage:
                                        tweet.authorProfileImage.isEmpty
                                            ? null
                                            : NetworkImage(
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
                            // PopupMenuButton(
                            //   icon: Icon(
                            //     Icons.more_vert,
                            //     color: Colors.grey..shade600,
                            //     size: 20,
                            //   ),
                            //   itemBuilder: (_) {
                            //     return <PopupMenuItem<String>>[
                            //       PopupMenuItem(
                            //         child: Center(
                            //           child: Row(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.spaceAround,
                            //             children: [
                            //               Icon(
                            //                 Icons.delete,
                            //                 color: Colors.redAccent,
                            //               ),
                            //               Text(
                            //                 'Delete',
                            //                 style: TextStyle(
                            //                   color: Colors.red,
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //         value: 'Delete',
                            //       )
                            //     ];
                            //   },
                            //   onSelected: (selectedItem) {
                            //     if (selectedItem == 'Delete') {
                            //       _tweetRepository.deleteTweet(
                            //         currentUserId: currentUserId!,
                            //         tweet: tweet,
                            //       );
                            //       _storageService.deleteTweetImage(
                            //         imagesPath: tweet.imagesPath,
                            //       );
                            //     }
                            //   },
                            // ),
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
                                                _setupNotifier.unFollowUser(
                                                  tweet: tweet,
                                                );
                                                Navigator.of(context).pop();
                                              } else {
                                                _setupNotifier.followUser(
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
                        Container(
                          height: 100,
                          color: _isLiked == true ? Colors.red : Colors.blue,
                          child: Center(
                            child: Text(
                              _isLiked == true ? 'true' : 'false',
                              style: TextStyle(
                                fontSize: 60,
                                color: Colors.white,
                              ),
                            ),
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
                              child: StreamBuilder(
                                stream: usersRef
                                    .doc(tweet.authorId)
                                    .collection('tweets')
                                    .doc(tweet.tweetId)
                                    .collection('likes')
                                    .orderBy('timestamp', descending: true)
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return SizedBox.shrink();
                                  }
                                  List<DocumentSnapshot> likesListForTweet =
                                      snapshot.data!.docs;
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              LikesUserContainer(
                                            title: 'Liked by',
                                            likesListForTweet:
                                                likesListForTweet,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          likesListForTweet.length.toString(),
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
                              child: StreamBuilder(
                                stream: usersRef
                                    .doc(tweet.authorId)
                                    .collection('tweets')
                                    .doc(tweet.tweetId)
                                    .collection('comments')
                                    .orderBy('timestamp', descending: true)
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return SizedBox.shrink();
                                  }
                                  List<DocumentSnapshot> commentListForTweet =
                                      snapshot.data!.docs;
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CommentUserContainer(
                                                  title: 'Commented by',
                                                  commentListForTweet:
                                                      commentListForTweet),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          commentListForTweet.length.toString(),
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
                                _setupNotifier.likeOrUnLikeTweet(tweet: tweet);
                              },
                            ),
                            SizedBox(width: 10),
                            Container(
                              child: FutureBuilder<Uri>(
                                future: _dynamicLinkService.createDynamicLink(
                                  tweetId: tweet.tweetId!,
                                  tweetAuthorId: tweet.authorId,
                                  tweetText: tweet.text,
                                  imageUrl: tweet.hasImage
                                      ? tweet.imagesUrl['0']!
                                      : 'https://static.theprint.in/wp-content/uploads/2021/02/twitter--696x391.jpg',
                                ),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    /*データがない間はアイコンボタンを表示するだけ*/
                                    return IconButton(
                                      icon: Icon(
                                        Icons.share,
                                        color: Colors.grey.shade600,
                                      ),
                                      onPressed: () {},
                                    );
                                  }
                                  Uri uri = snapshot.data!;
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
                    child: StreamBuilder<QuerySnapshot>(
                      stream: usersRef
                          .doc(tweet.authorId)
                          .collection('tweets')
                          .doc(tweet.tweetId)
                          .collection('comments')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        List<DocumentSnapshot> commentsForTweet =
                            snapshot.data!.docs;
                        return ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: commentsForTweet.map((commentForTweet) {
                            Comment comment = Comment.fromDoc(commentForTweet);
                            return CommentContainer(
                              comment: comment,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          },
                          focusNode: _focusNode,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.send_rounded,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        handleComment();
                        _commentController.clear();
                        _focusNode.unfocus();
                      },
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
