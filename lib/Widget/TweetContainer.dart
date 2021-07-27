import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';
import 'package:twitter_clone/Screens/TweetDetailScreen.dart';

class TweetContainer extends StatefulWidget {
  final String currentUserId;
  final Tweet tweet;

  TweetContainer({Key? key, required this.currentUserId, required this.tweet})
      : super(key: key);

  @override
  _TweetContainerState createState() => _TweetContainerState();
}

class _TweetContainerState extends State<TweetContainer> {
  int _likesCount = 0;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _likesCount = widget.tweet.likes;
  }

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
                            : Container(
                                height: 180,
                                width: MediaQuery.of(context).size.width * 0.73,
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
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.mode_comment_outlined,
                                color: Colors.black,
                              ),
                              onPressed: () {},
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              icon: Icon(Icons.repeat),
                              onPressed: () {},
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              icon: _isLiked
                                  ? Icon(Icons.favorite)
                                  : Icon(Icons.favorite_border),
                              color: _isLiked ? Colors.red : Colors.black,
                              onPressed: () {
                                likeTweet();
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.share),
                              onPressed: () {},
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
