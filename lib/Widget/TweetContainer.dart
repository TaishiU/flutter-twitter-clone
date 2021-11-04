import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share/share.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/DynamicLink.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Model/Likes.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/TweetProvider.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';
import 'package:twitter_clone/Screens/TweetDetailScreen.dart';
import 'package:twitter_clone/Widget/TweetImage.dart';

class TweetContainer extends HookWidget {
  final String currentUserId;
  final Tweet tweet;

  TweetContainer({
    Key? key,
    required this.currentUserId,
    required this.tweet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? currentUserId = useProvider(currentUserIdProvider);
    final bool _isLiked = useProvider(isLikedProvider);
    final DynamicLink dynamicLink = DynamicLink();

    /*ツイートにいいねをしているか判断するメソッド*/
    setupIsLiked() async {
      bool isLikedTweet = await Firestore().isLikedTweet(
        currentUserId: currentUserId!,
        tweetAuthorId: tweet.authorId,
        tweetId: tweet.tweetId!,
      );

      if (isLikedTweet == true) {
        context.read(isLikedProvider.notifier).update(isLiked: true);
      } else {
        context.read(isLikedProvider.notifier).update(isLiked: false);
      }
    }

    useEffect(() {
      setupIsLiked();
    }, []);

    likeOrUnLikeTweet() async {
      if (!_isLiked) {
        /*いいねされていない時*/
        context.read(isLikedProvider.notifier).update(isLiked: true);
        DocumentSnapshot userProfileDoc =
            await Firestore().getUserProfile(userId: currentUserId!);
        User user = User.fromDoc(userProfileDoc);
        Likes likes = Likes(
          likesUserId: user.userId,
          likesUserName: user.name,
          likesUserProfileImage: user.profileImage,
          likesUserBio: user.bio,
          timestamp: Timestamp.fromDate(DateTime.now()),
        );
        Firestore().likesForTweet(
          likes: likes,
          postId: tweet.tweetId!,
          postUserId: tweet.authorId,
        );
        Firestore().favoriteTweet(
          currentUserId: currentUserId,
          name: user.name,
          tweet: tweet,
        );
      } else if (_isLiked) {
        /*いいねされている時*/
        context.read(isLikedProvider.notifier).update(isLiked: false);
        DocumentSnapshot userProfileDoc =
            await Firestore().getUserProfile(userId: currentUserId!);
        User user = User.fromDoc(userProfileDoc);
        Firestore().unLikesForTweet(
          tweet: tweet,
          unlikesUser: user,
        );
      }
    }

    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TweetDetailScreen(
                    tweet: tweet,
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
                              .update(userId: tweet.authorId);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 23,
                          backgroundColor: TwitterColor,
                          backgroundImage: tweet.authorProfileImage.isEmpty
                              ? null
                              : NetworkImage(tweet.authorProfileImage),
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
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    tweet.authorName,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '@${tweet.authorBio}・',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '${tweet.timestamp.toDate().month.toString()}/${tweet.timestamp.toDate().day.toString()}',
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
                                          Text(
                                            'Delete',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
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
                                    userId: currentUserId!,
                                    tweet: tweet,
                                  );
                                }
                              },
                            )
                          ],
                        ),
                        Text(
                          tweet.text,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        tweet.images.isEmpty
                            ? SizedBox.shrink()
                            : Column(
                                children: [
                                  SizedBox(height: 15),
                                  TweetImage(
                                    currentUserId: currentUserId!,
                                    tweet: tweet,
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
                                            tweet: tweet,
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
                                  Container(
                                    child: StreamBuilder(
                                      stream: usersRef
                                          .doc(tweet.authorId)
                                          .collection('tweets')
                                          .doc(tweet.tweetId)
                                          .collection('comments')
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (!snapshot.hasData) {
                                          return SizedBox.shrink();
                                        }
                                        return snapshot.data!.size == 0
                                            ? SizedBox.shrink()
                                            : Text(
                                                snapshot.data!.size.toString(),
                                                /*Firestoreコレクションの要素数はsizeで取得できる*/
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                ),
                                              );
                                      },
                                    ),
                                  ),
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
                                  Container(
                                    child: StreamBuilder(
                                      stream: usersRef
                                          .doc(tweet.authorId)
                                          .collection('tweets')
                                          .doc(tweet.tweetId)
                                          .collection('likes')
                                          .orderBy('timestamp',
                                              descending: true)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (!snapshot.hasData) {
                                          return SizedBox.shrink();
                                        }
                                        return snapshot.data!.size == 0
                                            ? SizedBox.shrink()
                                            : Text(
                                                snapshot.data!.size.toString(),
                                                /*Firestoreコレクションの要素数はsizeで取得できる*/
                                                style: TextStyle(
                                                  color: _isLiked
                                                      ? Colors.red
                                                      : Colors.grey,
                                                ),
                                              );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10),
                              Container(
                                child: FutureBuilder<Uri>(
                                  future: dynamicLink.createDynamicLink(
                                    tweetId: tweet.tweetId!,
                                    tweetAuthorId: tweet.authorId,
                                    tweetText: tweet.text,
                                    imageUrl: tweet.hasImage
                                        ? tweet.images['0']!
                                        : 'https://static.theprint.in/wp-content/uploads/2021/02/twitter--696x391.jpg',
                                  ),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      /*データがない間はアイコンボタンを表示するだけ*/
                                      return Icon(
                                        Icons.share,
                                        size: 20,
                                        color: Colors.grey.shade600,
                                      );
                                    }
                                    Uri uri = snapshot.data!;
                                    return GestureDetector(
                                      onTap: () {
                                        Share.share(
                                          '${tweet.text}\n\n${uri.toString()}',
                                        );
                                      },
                                      child: Icon(
                                        Icons.share,
                                        size: 20,
                                        color: Colors.grey.shade600,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 5),
          Divider(),
        ],
      ),
    );
  }
}
