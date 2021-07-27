import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';

class TweetDetailScreen extends StatefulWidget {
  final String currentUserId;
  final Tweet tweet;

  TweetDetailScreen(
      {Key? key, required this.currentUserId, required this.tweet})
      : super(key: key);

  @override
  _TweetDetailScreenState createState() => _TweetDetailScreenState();
}

class _TweetDetailScreenState extends State<TweetDetailScreen> {
  bool _isLiked = false;

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: BackButton(
          color: TwitterColor,
        ),
        title: Text(
          'Thread',
          style: TextStyle(
            color: TwitterColor,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
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
                            CircleAvatar(
                              radius: 23,
                              backgroundColor: TwitterColor,
                              backgroundImage:
                                  widget.tweet.authorProfileImage.isEmpty
                                      ? null
                                      : NetworkImage(
                                          widget.tweet.authorProfileImage),
                            ),
                            SizedBox(width: 10),
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
                  SizedBox(height: 15),
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
                          height: 200,
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
                  SizedBox(height: 15),
                  Text(
                    '${widget.tweet.timestamp.toDate().year.toString()}/${widget.tweet.timestamp.toDate().month.toString()}/${widget.tweet.timestamp.toDate().day.toString()}  ${widget.tweet.timestamp.toDate().hour.toString()}:${widget.tweet.timestamp.toDate().minute.toString()}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 5),
                  Divider(),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            '14',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(' Retweets'),
                        ],
                      ),
                      SizedBox(width: 20),
                      Row(
                        children: [
                          Text(
                            '31',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(' Likes'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Divider(),
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
            Divider(),
          ],
        ),
      ),
    );
  }
}
