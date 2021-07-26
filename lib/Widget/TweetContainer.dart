import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';

class TweetContainer extends StatefulWidget {
  final String currentUserId;
  final User user;
  final Tweet tweet;

  TweetContainer(
      {Key? key,
      required this.currentUserId,
      required this.user,
      required this.tweet})
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
    final _isOwner = widget.currentUserId == widget.tweet.authorId;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    /*tweet型の中にはユーザーのprofileImageが含まれていないため、user型からprofileImageを取得する*/
                    radius: 20,
                    backgroundColor: TwitterColor,
                    backgroundImage: widget.user.profileImage.isEmpty
                        ? null
                        : NetworkImage(widget.user.profileImage),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                          )
                        ],
                      ),
                      Text(
                        'tweetId: ${widget.tweet.tweetId.toString()}',
                        style: TextStyle(
                          fontSize: 13,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              _isOwner
                  ? IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        Firestore().deleteTweet(
                          userId: widget.tweet.authorId,
                          postId: widget.tweet.tweetId!,
                        );
                      },
                    )
                  : SizedBox.shrink()
            ],
          ),
          SizedBox(height: 15),
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
          Row(
            children: [
              IconButton(
                icon: _isLiked
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
                color: _isLiked ? Colors.red : Colors.black,
                onPressed: () {
                  likeTweet();
                },
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.repeat),
                onPressed: () {},
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
