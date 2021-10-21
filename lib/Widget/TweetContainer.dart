import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/DynamicLink.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Model/Likes.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';
import 'package:twitter_clone/Screens/TweetDetailScreen.dart';
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
  final DynamicLink dynamicLink = DynamicLink();

  @override
  void initState() {
    super.initState();
    setupIsLiked();
  }

  /*ツイートにいいねをしているか判断するメソッド*/
  setupIsLiked() async {
    bool isLikedTweet = await Firestore().isLikedTweet(
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
          await Firestore().getUserProfile(userId: widget.currentUserId);
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
        postId: widget.tweet.tweetId!,
        postUserId: widget.tweet.authorId,
      );
      Firestore().favoriteTweet(
        currentUserId: widget.currentUserId,
        name: user.name,
        tweet: widget.tweet,
      );
    } else if (_isLiked) {
      /*いいねされている時*/
      setState(() {
        _isLiked = false;
      });
      DocumentSnapshot userProfileDoc =
          await Firestore().getUserProfile(userId: widget.currentUserId);
      User user = User.fromDoc(userProfileDoc);
      Firestore().unLikesForTweet(
        tweet: widget.tweet,
        unlikesUser: user,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TweetDetailScreen(
                    currentUserId: widget.currentUserId,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                currentUserId: widget.currentUserId,
                                visitedUserId: widget.tweet.authorId,
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 23,
                          backgroundColor: TwitterColor,
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
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                      currentUserId: widget.currentUserId,
                                      visitedUserId: widget.tweet.authorId,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
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
                                    '@${widget.tweet.authorBio}・',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '${widget.tweet.timestamp.toDate().month.toString()}/${widget.tweet.timestamp.toDate().day.toString()}',
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
                                    userId: widget.currentUserId,
                                    tweet: widget.tweet,
                                  );
                                }
                              },
                            )
                          ],
                        ),
                        Text(
                          widget.tweet.text,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        widget.tweet.images.isEmpty
                            ? SizedBox.shrink()
                            : Column(
                                children: [
                                  SizedBox(height: 15),
                                  TweetImage(
                                    currentUserId: widget.currentUserId,
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
                                            currentUserId: widget.currentUserId,
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
                                  Container(
                                    child: StreamBuilder(
                                      stream: usersRef
                                          .doc(widget.tweet.authorId)
                                          .collection('tweets')
                                          .doc(widget.tweet.tweetId)
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
                                          .doc(widget.tweet.authorId)
                                          .collection('tweets')
                                          .doc(widget.tweet.tweetId)
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
                                    tweetId: widget.tweet.tweetId!,
                                    tweetAuthorId: widget.tweet.authorId,
                                    tweetText: widget.tweet.text,
                                    imageUrl: widget.tweet.hasImage
                                        ? widget.tweet.images['0']!
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
