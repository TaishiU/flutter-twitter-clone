import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/DynamicLink.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';
import 'package:twitter_clone/Screens/TweetDetailScreen.dart';
import 'package:twitter_clone/Widget/TweetImageView.dart';

class TweetContainer extends StatefulWidget {
  final String currentUserId;
  final Tweet tweet;
  final User user;

  TweetContainer({
    Key? key,
    required this.currentUserId,
    required this.tweet,
    required this.user,
  }) : super(key: key);

  @override
  _TweetContainerState createState() => _TweetContainerState();
}

class _TweetContainerState extends State<TweetContainer> {
  bool _isLiked = false;
  final DynamicLink dynamicLink = DynamicLink();

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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TweetDetailScreen(
                    currentUserId: widget.currentUserId,
                    tweet: widget.tweet,
                    user: widget.user,
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
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                currentUserId: widget.currentUserId,
                                visitedUserUserId: widget.tweet.authorId,
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
                                      visitedUserUserId: widget.tweet.authorId,
                                    ),
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
                                    postId: widget.tweet.tweetId!,
                                  );
                                }
                              },
                            )
                          ],
                        ),
                        Text('tweetId: ${widget.tweet.tweetId.toString()}'),
                        Text(
                          widget.tweet.text,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 15),
                        widget.tweet.image.isEmpty
                            ? SizedBox.shrink()
                            : GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TweetImageView(
                                        tappedImageIndex: 0,
                                        image: widget.tweet.image,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 180,
                                  width:
                                      MediaQuery.of(context).size.width * 0.73,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        widget.tweet.image,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                        Row(
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TweetDetailScreen(
                                          currentUserId: widget.currentUserId,
                                          tweet: widget.tweet,
                                          user: widget.user,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.mode_comment_outlined,
                                    color: Colors.black,
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
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (!snapshot.hasData) {
                                        return SizedBox.shrink();
                                      }
                                      return Text(
                                        snapshot.data!.size.toString(),
                                        /*Firestoreコレクションの要素数はsizeで取得できる*/
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              icon: Icon(Icons.repeat),
                              onPressed: () {},
                            ),
                            SizedBox(width: 10),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TweetDetailScreen(
                                          currentUserId: widget.currentUserId,
                                          tweet: widget.tweet,
                                          user: widget.user,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.favorite_border,
                                    color: Colors.black,
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
                                        return Text(
                                          snapshot.data!.size.toString(),
                                          /*Firestoreコレクションの要素数はsizeで取得できる*/
                                        );
                                      }),
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
                                ),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return IconButton(
                                      icon: Icon(Icons.share),
                                      onPressed: () {
                                        //Share.share(widget.tweet.text);
                                      },
                                    );
                                  }
                                  Uri uri = snapshot.data!;
                                  return IconButton(
                                    icon: Icon(Icons.share),
                                    onPressed: () {
                                      Share.share(
                                        '${widget.tweet.text}\n\n${uri.toString()}',
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
