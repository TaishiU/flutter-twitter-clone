import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share/share.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Likes.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/TweetProvider.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Repository/TweetRepository.dart';
import 'package:twitter_clone/Repository/UserRepository.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';
import 'package:twitter_clone/Screens/TweetDetailScreen.dart';
import 'package:twitter_clone/Service/StorageService.dart';
import 'package:twitter_clone/ViewModel/IsFollowingNotifier.dart';
import 'package:twitter_clone/Widget/TweetImage.dart';

class TweetContainer extends StatefulWidget {
  final String currentUserId;
  final Tweet tweet;

  TweetContainer({
    Key? key,
    required this.currentUserId,
    required this.tweet,
  }) : super(key: key);

  @override
  _TweetContainerState createState() => _TweetContainerState();
}

class _TweetContainerState extends State<TweetContainer> {
  bool _isLiked = false;

  final TweetRepository _tweetRepository = TweetRepository();
  final UserRepository _userRepository = UserRepository();
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    setupIsLiked();
  }

  /*ツイートにいいねをしているか判断するメソッド*/
  setupIsLiked() async {
    bool isLikedTweet = await _tweetRepository.isLikedTweet(
      currentUserId: widget.currentUserId,
      tweetAuthorId: widget.tweet.authorId,
      tweetId: widget.tweet.tweetId!,
    );
    if (mounted) {
      if (isLikedTweet == true) {
        setState(() {
          _isLiked = true;
        });
      } else {
        setState(() {
          _isLiked = false;
        });
      }
    }
  }

  likeOrUnLikeTweet() async {
    if (!_isLiked) {
      /*いいねされていない時*/
      setState(() {
        _isLiked = true;
      });
      DocumentSnapshot userProfileDoc =
          await _userRepository.getUserProfile(userId: widget.currentUserId);
      User user = User.fromDoc(userProfileDoc);
      Likes likes = Likes(
        likesUserId: user.userId,
        likesUserName: user.name,
        likesUserProfileImage: user.profileImageUrl,
        likesUserBio: user.bio,
        timestamp: Timestamp.fromDate(DateTime.now()),
      );
      _tweetRepository.likesForTweet(
        likes: likes,
        tweetId: widget.tweet.tweetId!,
        tweetAuthorId: widget.tweet.authorId,
      );
      _tweetRepository.favoriteTweet(
        currentUserId: widget.currentUserId,
        tweet: widget.tweet,
      );
    } else if (_isLiked) {
      /*いいねされている時*/
      setState(() {
        _isLiked = false;
      });
      DocumentSnapshot userProfileDoc =
          await _userRepository.getUserProfile(userId: widget.currentUserId);
      User user = User.fromDoc(userProfileDoc);
      _tweetRepository.unLikesForTweet(
        tweet: widget.tweet,
        unlikesUser: user,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _isOwner = widget.tweet.authorId == widget.currentUserId;

    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TweetDetailScreen(
                    tweet: widget.tweet,
                    //user: widget.user,
                  ),
                ),
              );
            },
            child: Container(
              color: Colors.transparent,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          /*visitedUserId情報を更新*/
                          context
                              .read(visitedUserIdProvider.notifier)
                              .update(userId: widget.tweet.authorId);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 23,
                          backgroundColor:
                              widget.tweet.authorProfileImage.isEmpty
                                  ? TwitterColor
                                  : Colors.transparent,
                          backgroundImage: widget
                                  .tweet.authorProfileImage.isEmpty
                              ? null
                              : NetworkImage(widget.tweet.authorProfileImage),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.76,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                /*visitedUserId情報を更新*/
                                context
                                    .read(visitedUserIdProvider.notifier)
                                    .update(userId: widget.tweet.authorId);

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
                                    widget.tweet.authorName,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '${widget.tweet.timestamp.toDate().month.toString()}/${widget.tweet.timestamp.toDate().day.toString()}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                bool _isFollowingUser =
                                    await _userRepository.isFollowingUser(
                                  currentUserId: widget.currentUserId,
                                  visitedUserId: widget.tweet.authorId,
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
                                                currentUserId:
                                                    widget.currentUserId,
                                                tweet: widget.tweet,
                                              );
                                              _storageService.deleteTweetImage(
                                                imagesPath:
                                                    widget.tweet.imagesPath,
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
                                                  ? 'Unfollow ${widget.tweet.authorName}'
                                                  : 'Follow ${widget.tweet.authorName}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            onPressed: () {
                                              if (_isFollowingUser == true) {
                                                context
                                                    .read(isFollowingProvider
                                                        .notifier)
                                                    .unFollowUserFromTweet(
                                                      tweet: widget.tweet,
                                                    );
                                                Navigator.of(context).pop();
                                              } else {
                                                context
                                                    .read(isFollowingProvider
                                                        .notifier)
                                                    .followUserFromTweet(
                                                      tweet: widget.tweet,
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
                                                currentUserId:
                                                    widget.currentUserId,
                                                tweet: widget.tweet,
                                              );
                                              _storageService.deleteTweetImage(
                                                imagesPath:
                                                    widget.tweet.imagesPath,
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
                        Text(
                          widget.tweet.text,
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
                        widget.tweet.imagesUrl.isEmpty
                            ? SizedBox.shrink()
                            : Column(
                                children: [
                                  SizedBox(height: 15),
                                  TweetImage(
                                    tweet: widget.tweet,
                                    containerHeight: 180,
                                    containerWith:
                                        MediaQuery.of(context).size.width *
                                            0.76,
                                    imageHeight: 88,
                                    imageWith:
                                        MediaQuery.of(context).size.width *
                                            0.3744,
                                  ),
                                ],
                              ),
                        SizedBox(height: 15),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TweetDetailScreen(
                                            tweet: widget.tweet,
                                            //user: widget.user,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.mode_comment_outlined,
                                      size: 20,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Consumer(builder: (context, watch, child) {
                                    final asyncAllTweetComments = watch(
                                      allTweetCommentsProvider(widget.tweet),
                                    );
                                    return asyncAllTweetComments.when(
                                      loading: () => SizedBox.shrink(),
                                      error: (error, stack) =>
                                          Center(child: Text('Error: $error')),
                                      data: (allTweetComments) {
                                        return allTweetComments.size == 0
                                            ? SizedBox.shrink()
                                            : Text(
                                                allTweetComments.size
                                                    .toString(),
                                                /*Firestoreコレクションの要素数はsizeで取得できる*/
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                ),
                                              );
                                      },
                                    );
                                  }),
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
                                  Text(''),
                                ],
                              ),
                              SizedBox(width: 10),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      likeOrUnLikeTweet();
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
                                  Consumer(builder: (context, watch, child) {
                                    final asyncAllTweetLikes = watch(
                                      allTweetLikesProvider(widget.tweet),
                                    );
                                    return asyncAllTweetLikes.when(
                                        loading: () => SizedBox.shrink(),
                                        error: (error, stack) => Center(
                                            child: Text('Error: $error')),
                                        data: (allTweetLikes) {
                                          return allTweetLikes.size == 0
                                              ? SizedBox.shrink()
                                              : Text(
                                                  allTweetLikes.size.toString(),
                                                  /*Firestoreコレクションの要素数はsizeで取得できる*/
                                                  style: TextStyle(
                                                    color: _isLiked == true
                                                        ? Colors.red
                                                        : Colors.grey.shade600,
                                                  ),
                                                );
                                        });
                                  }),
                                ],
                              ),
                              SizedBox(width: 10),
                              Container(
                                child:
                                    Consumer(builder: (context, watch, child) {
                                  final asyncShare =
                                      watch(shareProvider(widget.tweet));
                                  return asyncShare.when(
                                    loading: () => Icon(
                                      Icons.share,
                                      size: 20,
                                      color: Colors.grey.shade600,
                                    ),
                                    error: (error, stack) => Center(
                                        child: Text('ShareUri Error: $error')),
                                    data: (shareUri) {
                                      Uri uri = shareUri;
                                      return GestureDetector(
                                        onTap: () {
                                          Share.share(
                                            '${widget.tweet.text}\n\n${uri.toString()}',
                                          );
                                        },
                                        child: Icon(
                                          Icons.share,
                                          size: 20,
                                          color: Colors.grey.shade600,
                                        ),
                                      );
                                    },
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}

// class TweetContainer extends StatefulHookWidget {
//   const TweetContainer({Key? key}) : super(key: key);
//
//   @override
//   _TweetContainerState createState() => _TweetContainerState();
// }
//
// class _TweetContainerState extends State<TweetContainer> {
//   @override
//   Widget build(BuildContext context) {
//     final share = useProvider(shareProvider(tweet));
//     return Container();
//   }
// }

// import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:share/share.dart';
// import 'package:twitter_clone/Constants/Constants.dart';
// import 'package:twitter_clone/Model/Tweet.dart';
// import 'package:twitter_clone/Provider/UserProvider.dart';
// import 'package:twitter_clone/Repository/TweetRepository.dart';
// import 'package:twitter_clone/Repository/UserRepository.dart';
// import 'package:twitter_clone/Screens/ProfileScreen.dart';
// import 'package:twitter_clone/Screens/TweetDetailScreen.dart';
// import 'package:twitter_clone/Service/DynamicLinkService.dart';
// import 'package:twitter_clone/Service/StorageService.dart';
// import 'package:twitter_clone/ViewModel/SetupNotifier.dart';
// import 'package:twitter_clone/Widget/TweetImage.dart';
//
// class TweetContainer extends HookWidget {
//   final Tweet tweet;
//
//   TweetContainer({
//     Key? key,
//     required this.tweet,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final String? currentUserId = useProvider(currentUserIdProvider);
//     //final _isLiked = setupState.isLikedTweet;
//     //final _isLiked = useProvider(isLikedProvider);
//     final setupState = useProvider(setupProvider);
//     final _isLiked = setupState.isLikedTweet;
//     final _setupNotifier = context.read(setupProvider.notifier);
//     final _visitedUserIdNotifier = context.read(visitedUserIdProvider.notifier);
//     final UserRepository _userRepository = UserRepository();
//     final TweetRepository _tweetRepository = TweetRepository();
//     final StorageService _storageService = StorageService();
//     final DynamicLinkService _dynamicLinkService = DynamicLinkService();
//     final _isOwner = tweet.authorId == currentUserId;
//     //bool _isLiked = false;
//
//     /*ツイートにいいねをしているか判断するメソッド*/
//     // setupIsLiked() async {
//     //   bool isLikedTweet = await _tweetRepository.isLikedTweet(
//     //     currentUserId: currentUserId!,
//     //     tweetAuthorId: tweet.authorId,
//     //     tweetId: tweet.tweetId!,
//     //   );
//     //
//     //   if (isLikedTweet == true) {
//     //     print('「${tweet.text}」にいいねしています');
//     //     context.read(isLikedProvider.notifier).update(isLiked: true);
//     //     print('isLikedTweet: $isLikedTweet');
//     //     //print('!_isLiked: ${!_isLiked}');
//     //     print('_isLiked: ${_isLiked}');
//     //   } else {
//     //     context.read(isLikedProvider.notifier).update(isLiked: false);
//     //     print('「${tweet.text}」にいいねしていません...');
//     //     print('isLikedTweet: $isLikedTweet');
//     //     //print('!_isLiked: ${!_isLiked}');
//     //     print('_isLiked: $_isLiked');
//     //   }
//     // }
//
//     useEffect(() {
//       //setupIsLiked();
//       // print('setupState: $setupState');
//       _setupNotifier.setupIsLiked(tweet: tweet);
//     }, []);
//
//     // likeOrUnLikeTweet() async {
//     //   if (!_isLiked) {
//     //     /*いいねされていない時*/
//     //     context.read(isLikedProvider.notifier).update(isLiked: true);
//     //     print('いいねを押しました!');
//     //     //_isLiked = true;
//     //     // final SharedPreferences prefs = await SharedPreferences.getInstance();
//     //     // prefs.setBool('tweetLike', true);
//     //
//     //     DocumentSnapshot userProfileDoc =
//     //         await _userRepository.getUserProfile(userId: currentUserId!);
//     //     User user = User.fromDoc(userProfileDoc);
//     //     Likes likes = Likes(
//     //       likesUserId: user.userId,
//     //       likesUserName: user.name,
//     //       likesUserProfileImage: user.profileImageUrl,
//     //       likesUserBio: user.bio,
//     //       timestamp: Timestamp.fromDate(DateTime.now()),
//     //     );
//     //     _tweetRepository.likesForTweet(
//     //       likes: likes,
//     //       postId: tweet.tweetId!,
//     //       postUserId: tweet.authorId,
//     //     );
//     //     _tweetRepository.favoriteTweet(
//     //       currentUserId: currentUserId,
//     //       name: user.name,
//     //       tweet: tweet,
//     //     );
//     //   } else if (_isLiked) {
//     //     /*いいねされている時*/
//     //     //_isLiked = false;
//     //     // final SharedPreferences prefs = await SharedPreferences.getInstance();
//     //     // prefs.setBool('tweetLike', false);
//     //     context.read(isLikedProvider.notifier).update(isLiked: false);
//     //     DocumentSnapshot userProfileDoc =
//     //         await _userRepository.getUserProfile(userId: currentUserId!);
//     //     User user = User.fromDoc(userProfileDoc);
//     //     _tweetRepository.unLikesForTweet(
//     //       tweet: tweet,
//     //       unlikesUser: user,
//     //     );
//     //   }
//     // }
//
//     return Container(
//       child: Column(
//         children: [
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => TweetDetailScreen(
//                     tweet: tweet,
//                   ),
//                 ),
//               );
//             },
//             child: Container(
//               color: Colors.transparent,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Column(
//                     children: [
//                       SizedBox(height: 8),
//                       GestureDetector(
//                         onTap: () {
//                           /*visitedUserId情報を更新*/
//                           _visitedUserIdNotifier.update(userId: tweet.authorId);
//
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ProfileScreen(),
//                             ),
//                           );
//                         },
//                         child: CircleAvatar(
//                           radius: 23,
//                           backgroundColor: Colors.transparent,
//                           backgroundImage: tweet.authorProfileImage.isEmpty
//                               ? null
//                               : NetworkImage(tweet.authorProfileImage),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(width: 10),
//                   Container(
//                     width: MediaQuery.of(context).size.width * 0.76,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => ProfileScreen(),
//                                   ),
//                                 );
//                               },
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     tweet.authorName,
//                                     style: TextStyle(
//                                       fontSize: 17,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   SizedBox(width: 10),
//                                   Text(
//                                     '@${tweet.authorBio}・',
//                                     style: TextStyle(
//                                       fontSize: 15,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                   Text(
//                                     '${tweet.timestamp.toDate().month.toString()}/${tweet.timestamp.toDate().day.toString()}',
//                                     style: TextStyle(
//                                       fontSize: 15,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () async {
//                                 bool _isFollowingUser =
//                                     await _userRepository.isFollowingUser(
//                                   currentUserId: currentUserId!,
//                                   visitedUserId: tweet.authorId,
//                                 );
//
//                                 _isOwner
//                                     ? showAdaptiveActionSheet(
//                                         context: context,
//                                         title: SizedBox.shrink(),
//                                         actions: <BottomSheetAction>[
//                                           BottomSheetAction(
//                                             leading: Padding(
//                                               padding:
//                                                   EdgeInsets.only(left: 20),
//                                               child: Icon(
//                                                 Icons.push_pin,
//                                                 color: Colors.grey,
//                                               ),
//                                             ),
//                                             title: Text(
//                                               'Fixed display in profile',
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.normal,
//                                               ),
//                                             ),
//                                             onPressed: () {},
//                                           ),
//                                           BottomSheetAction(
//                                             leading: Padding(
//                                               padding:
//                                                   EdgeInsets.only(left: 20),
//                                               child: Icon(
//                                                 Icons.delete,
//                                                 color: Colors.grey,
//                                               ),
//                                             ),
//                                             title: Text(
//                                               'Delete a tweet',
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.normal,
//                                               ),
//                                             ),
//                                             onPressed: () {
//                                               _tweetRepository.deleteTweet(
//                                                 currentUserId: currentUserId,
//                                                 tweet: tweet,
//                                               );
//                                               _storageService.deleteTweetImage(
//                                                 imagesPath: tweet.imagesPath,
//                                               );
//                                               Navigator.of(context).pop();
//                                             },
//                                           ),
//                                         ],
//                                       )
//                                     : showAdaptiveActionSheet(
//                                         context: context,
//                                         title: SizedBox.shrink(),
//                                         actions: <BottomSheetAction>[
//                                           BottomSheetAction(
//                                             leading: Padding(
//                                               padding:
//                                                   EdgeInsets.only(left: 20),
//                                               child: Icon(
//                                                 _isFollowingUser == true
//                                                     ? Icons.person_add_disabled
//                                                     : Icons.person_add,
//                                                 color: Colors.grey,
//                                               ),
//                                             ),
//                                             title: Text(
//                                               _isFollowingUser == true
//                                                   ? 'Unfollow ${tweet.authorName}'
//                                                   : 'Follow ${tweet.authorName}',
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.normal,
//                                               ),
//                                             ),
//                                             onPressed: () {
//                                               if (_isFollowingUser == true) {
//                                                 _setupNotifier.unFollowUser(
//                                                   tweet: tweet,
//                                                 );
//                                                 Navigator.of(context).pop();
//                                               } else {
//                                                 _setupNotifier.followUser(
//                                                   tweet: tweet,
//                                                 );
//                                                 Navigator.of(context).pop();
//                                               }
//                                             },
//                                           ),
//                                           BottomSheetAction(
//                                             leading: Padding(
//                                               padding:
//                                                   EdgeInsets.only(left: 20),
//                                               child: Icon(
//                                                 Icons.delete,
//                                                 color: Colors.grey,
//                                               ),
//                                             ),
//                                             title: Text(
//                                               'Delete a tweet',
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.normal,
//                                               ),
//                                             ),
//                                             onPressed: () {
//                                               _tweetRepository.deleteTweet(
//                                                 currentUserId: currentUserId,
//                                                 tweet: tweet,
//                                               );
//                                               _storageService.deleteTweetImage(
//                                                 imagesPath: tweet.imagesPath,
//                                               );
//                                               Navigator.of(context).pop();
//                                             },
//                                           ),
//                                         ],
//                                       );
//                               },
//                               child: Icon(
//                                 Icons.more_vert,
//                                 color: Colors.grey..shade600,
//                                 size: 20,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Text(
//                           tweet.text,
//                           style: TextStyle(
//                             fontSize: 15,
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         Container(
//                           height: 100,
//                           color: _isLiked == true ? Colors.red : Colors.blue,
//                           child: Center(
//                             child: Text(
//                               _isLiked == true ? 'true' : 'false',
//                               style: TextStyle(
//                                 fontSize: 60,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                         tweet.imagesUrl.isEmpty
//                             ? SizedBox.shrink()
//                             : Column(
//                                 children: [
//                                   SizedBox(height: 10),
//                                   TweetImage(
//                                     tweet: tweet,
//                                     containerHeight: 180,
//                                     containerWith:
//                                         MediaQuery.of(context).size.width *
//                                             0.76,
//                                     imageHeight: 88,
//                                     imageWith:
//                                         MediaQuery.of(context).size.width *
//                                             0.3744,
//                                   ),
//                                 ],
//                               ),
//                         SizedBox(height: 15),
//                         Container(
//                           width: MediaQuery.of(context).size.width * 0.65,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Row(
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               TweetDetailScreen(
//                                             tweet: tweet,
//                                             //user: widget.user,
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                     child: Icon(
//                                       Icons.mode_comment_outlined,
//                                       size: 20,
//                                       color: Colors.grey.shade600,
//                                     ),
//                                   ),
//                                   SizedBox(width: 8),
//                                   Container(
//                                     child: StreamBuilder(
//                                       stream: usersRef
//                                           .doc(tweet.authorId)
//                                           .collection('tweets')
//                                           .doc(tweet.tweetId)
//                                           .collection('comments')
//                                           .snapshots(),
//                                       builder: (BuildContext context,
//                                           AsyncSnapshot<QuerySnapshot>
//                                               snapshot) {
//                                         if (!snapshot.hasData) {
//                                           return SizedBox.shrink();
//                                         }
//                                         return snapshot.data!.size == 0
//                                             ? SizedBox.shrink()
//                                             : Text(
//                                                 snapshot.data!.size.toString(),
//                                                 /*Firestoreコレクションの要素数はsizeで取得できる*/
//                                                 style: TextStyle(
//                                                   color: Colors.grey.shade600,
//                                                 ),
//                                               );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(width: 10),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.repeat,
//                                     size: 20,
//                                     color: Colors.grey.shade600,
//                                   ),
//                                   SizedBox(width: 8),
//                                   Text(
//                                     '',
//                                     style: TextStyle(
//                                       color: Colors.grey.shade600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(width: 10),
//                               Row(
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () {
//                                       //likeOrUnLikeTweet();
//                                       // final SharedPreferences prefs =
//                                       //     await SharedPreferences.getInstance();
//                                       // prefs.setBool('tweetLike', true);
//                                       // _setupNotifier.likeOrUnLikeTweet(
//                                       //   tweet: tweet,
//                                       // );
//                                       _setupNotifier.likeOrUnLikeTweet(
//                                           tweet: tweet);
//                                     },
//                                     child: _isLiked == true
//                                         ? Icon(
//                                             Icons.favorite,
//                                             size: 20,
//                                             color: Colors.red,
//                                           )
//                                         : Icon(
//                                             Icons.favorite_border,
//                                             size: 20,
//                                             color: Colors.grey.shade600,
//                                           ),
//                                   ),
//                                   SizedBox(width: 8),
//                                   Container(
//                                     child: StreamBuilder(
//                                       stream: usersRef
//                                           .doc(tweet.authorId)
//                                           .collection('tweets')
//                                           .doc(tweet.tweetId)
//                                           .collection('likes')
//                                           .orderBy('timestamp',
//                                               descending: true)
//                                           .snapshots(),
//                                       builder: (BuildContext context,
//                                           AsyncSnapshot<QuerySnapshot>
//                                               snapshot) {
//                                         if (!snapshot.hasData) {
//                                           return SizedBox.shrink();
//                                         }
//                                         return snapshot.data!.size == 0
//                                             ? SizedBox.shrink()
//                                             : Text(
//                                                 snapshot.data!.size.toString(),
//                                                 /*Firestoreコレクションの要素数はsizeで取得できる*/
//                                                 style: TextStyle(
//                                                   color: _isLiked
//                                                       ? Colors.red
//                                                       : Colors.grey,
//                                                 ),
//                                               );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(width: 10),
//                               Container(
//                                 child: FutureBuilder<Uri>(
//                                   future: _dynamicLinkService.createDynamicLink(
//                                     tweetId: tweet.tweetId!,
//                                     tweetAuthorId: tweet.authorId,
//                                     tweetText: tweet.text,
//                                     imageUrl: tweet.hasImage
//                                         ? tweet.imagesUrl['0']!
//                                         : 'https://static.theprint.in/wp-content/uploads/2021/02/twitter--696x391.jpg',
//                                   ),
//                                   builder: (context, snapshot) {
//                                     if (!snapshot.hasData) {
//                                       /*データがない間はアイコンボタンを表示するだけ*/
//                                       return Icon(
//                                         Icons.share,
//                                         size: 20,
//                                         color: Colors.grey.shade600,
//                                       );
//                                     }
//                                     Uri uri = snapshot.data!;
//                                     return GestureDetector(
//                                       onTap: () {
//                                         Share.share(
//                                           '${tweet.text}\n\n${uri.toString()}',
//                                         );
//                                       },
//                                       child: Icon(
//                                         Icons.share,
//                                         size: 20,
//                                         color: Colors.grey.shade600,
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(height: 5),
//           Divider(),
//         ],
//       ),
//     );
//   }
// }
