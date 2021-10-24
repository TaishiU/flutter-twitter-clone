import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/DynamicLink.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Model/Likes.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';

class TweetImageView extends StatefulWidget {
  final String currentUserId;
  final int tappedImageIndex;
  final Tweet tweet;

  TweetImageView({
    Key? key,
    required this.currentUserId,
    required this.tappedImageIndex,
    required this.tweet,
  }) : super(key: key);

  @override
  _TweetImageViewState createState() => _TweetImageViewState();
}

class _TweetImageViewState extends State<TweetImageView> {
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
    int _selectedPage = 0;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: BackButton(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index) {
              setState(() {
                _selectedPage = index;
              });
            },
            children: [
              for (var i = 0; i < widget.tweet.images.length; i++)
                Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.vertical,
                  onDismissed: (direction) {
                    Navigator.pop(context);
                  },
                  background: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    color: Colors.black,
                  ),
                  child: Container(
                    color: Colors.black,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Image.network(
                        widget.tweet.images['$i']!,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.black45,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.mode_comment_outlined,
                          size: 24,
                          color: Colors.white,
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
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return SizedBox.shrink();
                              }
                              return snapshot.data!.size == 0
                                  ? SizedBox.shrink()
                                  : Text(
                                      snapshot.data!.size.toString(),
                                      /*Firestoreコレクションの要素数はsizeで取得できる*/
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
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
                          size: 24,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '',
                          style: TextStyle(
                            color: Colors.white,
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
                                  size: 24,
                                  color: Colors.red,
                                )
                              : Icon(
                                  Icons.favorite_border,
                                  size: 24,
                                  color: Colors.white,
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
                                .orderBy('timestamp', descending: true)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                            : Colors.white,
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
                              size: 24,
                              color: Colors.white,
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
                              size: 24,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
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
