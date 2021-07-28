import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Model/Comment.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';
import 'package:twitter_clone/Widget/CommentContaienr.dart';
import 'package:twitter_clone/Widget/TweetImageView.dart';

class TweetDetailScreen extends StatefulWidget {
  final String currentUserId;
  final Tweet tweet;
  final User user;

  TweetDetailScreen({
    Key? key,
    required this.currentUserId,
    required this.tweet,
    required this.user,
  }) : super(key: key);

  @override
  _TweetDetailScreenState createState() => _TweetDetailScreenState();
}

class _TweetDetailScreenState extends State<TweetDetailScreen> {
  bool _isLiked = false;
  late String _comment;
  final _formkey = GlobalKey<FormState>();

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

  handleComment() async {
    _formkey.currentState!.save();
    if (_formkey.currentState!.validate()) {
      DocumentSnapshot userProfileDoc =
          await Firestore().getUserProfile(userId: widget.currentUserId);
      User user = User.fromDoc(userProfileDoc);
      Comment comment = Comment(
        commentUserId: widget.currentUserId,
        commentUserName: user.name,
        commentUserProfileImage: user.profileImage,
        commentText: _comment,
        timestamp: Timestamp.fromDate(DateTime.now()),
      );

      Firestore().commentForTweet(
        comment: comment,
        postId: widget.tweet.tweetId!,
        postUserId: widget.tweet.authorId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        centerTitle: true,
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
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: Container(
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
                                    backgroundImage: widget
                                            .tweet.authorProfileImage.isEmpty
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
                        //Text('tweetId: ${widget.tweet.tweetId.toString()}'),
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
                                  '31',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(' Likes'),
                              ],
                            ),
                            SizedBox(width: 20),
                            Row(
                              children: [
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

                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Text(' Comments'),
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
                  Container(
                    height: 10,
                    color: Colors.transparent,
                  ),
                  Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: usersRef
                          .doc(widget.tweet.authorId)
                          .collection('tweets')
                          .doc(widget.tweet.tweetId)
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
                              currentUserId: widget.currentUserId,
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
              color: Colors.white,
              child: Padding(
                padding:
                    EdgeInsets.only(right: 20, left: 20, top: 5, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Form(
                        key: _formkey,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Comment for tweet',
                            contentPadding: EdgeInsets.only(bottom: 11),
                          ),
                          validator: (String? input) {
                            if (input!.isEmpty) {
                              return 'You can\'t comment without text.';
                            }
                            return null;
                          },
                          onChanged: (input) {
                            setState(() {
                              _comment = input;
                            });
                          },
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
