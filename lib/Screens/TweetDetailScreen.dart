import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/DynamicLink.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Model/Comment.dart';
import 'package:twitter_clone/Model/Likes.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';
import 'package:twitter_clone/Widget/CommentContaienr.dart';
import 'package:twitter_clone/Widget/CommentUser.dart';
import 'package:twitter_clone/Widget/LikesUserContainer.dart';
import 'package:twitter_clone/Widget/TweetImage.dart';

class TweetDetailScreen extends StatefulWidget {
  final String currentUserId;
  final Tweet tweet;

  TweetDetailScreen({
    Key? key,
    required this.currentUserId,
    required this.tweet,
    // required this.user,
  }) : super(key: key);

  @override
  _TweetDetailScreenState createState() => _TweetDetailScreenState();
}

class _TweetDetailScreenState extends State<TweetDetailScreen> {
  bool _isLiked = false;
  late String _comment;
  final _formkey = GlobalKey<FormState>();
  TextEditingController _commentController = TextEditingController();
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
        likesUserId: widget.currentUserId,
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
        commentUserBio: user.bio,
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

  clearComment() {
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => _commentController.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        centerTitle: true,
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
                                    postId: widget.tweet.tweetId!,
                                  );
                                }
                              },
                            )
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
                        widget.tweet.images.isEmpty
                            ? SizedBox.shrink()
                            : TweetImage(
                                images: widget.tweet.images,
                                containerHeight: 200,
                                containerWith:
                                    MediaQuery.of(context).size.width,
                                imageHeight: 98,
                                imageWith:
                                    MediaQuery.of(context).size.width * 0.452,
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
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6),
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
                                  List<DocumentSnapshot> likesListForTweet =
                                      snapshot.data!.docs;
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              LikesUserContainer(
                                            title: 'Liked account',
                                            currentUserId: widget.currentUserId,
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
                                    .doc(widget.tweet.authorId)
                                    .collection('tweets')
                                    .doc(widget.tweet.tweetId)
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
                                          builder: (context) => CommentUser(
                                              title: 'Commented account',
                                              currentUserId:
                                                  widget.currentUserId,
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
                              icon: _isLiked
                                  ? Icon(Icons.favorite)
                                  : Icon(Icons.favorite_border),
                              color:
                                  _isLiked ? Colors.red : Colors.grey.shade600,
                              onPressed: () {
                                likeOrUnLikeTweet();
                              },
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
                        clearComment();
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
