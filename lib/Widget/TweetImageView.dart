import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share/share.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Likes.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/TweetProvider.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Repository/TweetRepository.dart';
import 'package:twitter_clone/Repository/UserRepository.dart';
import 'package:twitter_clone/Service/DynamicLinkService.dart';

class TweetImageView extends HookWidget {
  final int tappedImageIndex;
  final Tweet tweet;

  TweetImageView({
    Key? key,
    required this.tappedImageIndex,
    required this.tweet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? currentUserId = useProvider(currentUserIdProvider);
    final bool _isLiked = useProvider(isLikedProvider);
    final asyncShare = useProvider(shareProvider(tweet));
    final UserRepository _userRepository = UserRepository();
    final TweetRepository _tweetRepository = TweetRepository();
    final DynamicLinkService _dynamicLinkService = DynamicLinkService();

    /*ツイートにいいねをしているか判断するメソッド*/
    setupIsLiked() async {
      bool isLikedTweet = await _tweetRepository.isLikedTweet(
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
            await _userRepository.getUserProfile(userId: currentUserId!);
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
          tweetId: tweet.tweetId!,
          tweetAuthorId: tweet.authorId,
        );
        _tweetRepository.favoriteTweet(
          currentUserId: currentUserId,
          tweet: tweet,
        );
      } else if (_isLiked) {
        /*いいねされている時*/
        context.read(isLikedProvider.notifier).update(isLiked: false);
        DocumentSnapshot userProfileDoc =
            await _userRepository.getUserProfile(userId: currentUserId!);
        User user = User.fromDoc(userProfileDoc);
        _tweetRepository.unLikesForTweet(
          tweet: tweet,
          unlikesUser: user,
        );
      }
    }

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
              context.read(selectedPageProvider.notifier).update(index: index);
            },
            children: [
              for (var i = 0; i < tweet.imagesUrl.length; i++)
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
                      child: PhotoView(
                        imageProvider: NetworkImage(tweet.imagesUrl['$i']!),
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
                                .doc(tweet.authorId)
                                .collection('tweets')
                                .doc(tweet.tweetId)
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
                                .doc(tweet.authorId)
                                .collection('tweets')
                                .doc(tweet.tweetId)
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
                      child: asyncShare.when(
                        loading: () => Icon(
                          Icons.share,
                          size: 24,
                          color: Colors.white,
                        ),
                        error: (error, stack) =>
                            Center(child: Text('ShareUri Error: $error')),
                        data: (shareUri) {
                          Uri uri = shareUri;
                          return IconButton(
                            icon: Icon(
                              Icons.share,
                              size: 24,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Share.share(
                                '${tweet.text}\n\n${uri.toString()}',
                              );
                            },
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
