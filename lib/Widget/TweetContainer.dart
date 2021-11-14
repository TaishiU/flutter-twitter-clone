import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share/share.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Likes.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/TweetProvider.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Repository/TweetRepository.dart';
import 'package:twitter_clone/Repository/UserRepository.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';
import 'package:twitter_clone/Screens/TweetDetailScreen.dart';
import 'package:twitter_clone/Service/DynamicLinkService.dart';
import 'package:twitter_clone/Service/StorageService.dart';
import 'package:twitter_clone/Widget/TweetImage.dart';

class TweetContainer extends HookWidget {
  final Tweet tweet;

  TweetContainer({
    Key? key,
    required this.tweet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? currentUserId = useProvider(currentUserIdProvider);
    final bool _isLiked = useProvider(isLikedProvider);
    final UserRepository _userRepository = UserRepository();
    final TweetRepository _tweetRepository = TweetRepository();
    final StorageService _storageService = StorageService();
    final DynamicLinkService _dynamicLinkService = DynamicLinkService();
    final _isOwner = tweet.authorId == currentUserId;
    bool? isFollowingUser;

    /*ユーザーをフォローしているか判断するメソッド*/
    Future<void> setupIsFollowing() async {
      isFollowingUser = await _userRepository.isFollowingUser(
        currentUserId: currentUserId!,
        visitedUserId: tweet.authorId,
      );

      if (isFollowingUser == true) {
        print('${tweet.authorName}をフォローしています！');
        print('isFollowingUser: $isFollowingUser');
      } else {
        print('${tweet.authorName}をフォローしていません...');
        print('isFollowingUser: $isFollowingUser');
      }
    }

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
      setupIsFollowing();
      setupIsLiked();
    }, []);

    followUser() async {
      //context.read(isFollowingProvider.notifier).update(isFollowing: true);
      isFollowingUser = true;
      DocumentSnapshot followersUserSnap =
          await _userRepository.getUserProfile(userId: tweet.authorId);
      User followersUser = User.fromDoc(followersUserSnap);

      DocumentSnapshot followingUserSnap =
          await _userRepository.getUserProfile(userId: currentUserId!);
      User followingUser = User.fromDoc(followingUserSnap);

      await _userRepository.followUser(
        followingUser: followingUser,
        followersUser: followersUser,
      );
      Navigator.of(context).pop();
      print('${tweet.authorName}をフォローしました！');
      print('isFollowingUser: $isFollowingUser');
    }

    unFollowUser() async {
      //context.read(isFollowingProvider.notifier).update(isFollowing: false);
      isFollowingUser = false;
      DocumentSnapshot unFollowersUserSnap =
          await _userRepository.getUserProfile(userId: tweet.authorId);
      User unFollowersUser = User.fromDoc(unFollowersUserSnap);

      DocumentSnapshot unFollowingUserSnap =
          await _userRepository.getUserProfile(userId: currentUserId!);
      User unFollowingUser = User.fromDoc(unFollowingUserSnap);

      await _userRepository.unFollowUser(
        unFollowingUser: unFollowingUser,
        unFollowersUser: unFollowersUser,
      );
      Navigator.of(context).pop();
      print('${tweet.authorName}のフォローを解除しました！');
      print('isFollowingUser: $isFollowingUser');
    }

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
          postId: tweet.tweetId!,
          postUserId: tweet.authorId,
        );
        _tweetRepository.favoriteTweet(
          currentUserId: currentUserId,
          name: user.name,
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
                          backgroundColor: Colors.transparent,
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
                          crossAxisAlignment: CrossAxisAlignment.end,
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
                            GestureDetector(
                              onTap: () {
                                print('${tweet.authorName}のフォロー状態');
                                print('isFollowingUser: $isFollowingUser');

                                _isOwner
                                    ? showAdaptiveActionSheet(
                                        context: context,
                                        title: SizedBox.shrink(),
                                        actions: <BottomSheetAction>[
                                          BottomSheetAction(
                                            leading: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              child: Icon(
                                                Icons.push_pin,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            title: Text(
                                              'Fixed display in profile',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            onPressed: () {},
                                          ),
                                          BottomSheetAction(
                                            leading: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            title: Text(
                                              'Delete a tweet',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            onPressed: () {
                                              _tweetRepository.deleteTweet(
                                                currentUserId: currentUserId!,
                                                tweet: tweet,
                                              );
                                              _storageService.deleteTweetImage(
                                                imagesPath: tweet.imagesPath,
                                              );
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          BottomSheetAction(
                                            leading: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              child: Icon(
                                                Icons.chat_bubble,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            title: Text(
                                              'Change users who can reply',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            onPressed: () {},
                                          ),
                                        ],
                                      )
                                    : showAdaptiveActionSheet(
                                        context: context,
                                        title: SizedBox.shrink(),
                                        actions: <BottomSheetAction>[
                                          BottomSheetAction(
                                            leading: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              child: Icon(
                                                isFollowingUser == true
                                                    ? Icons.person_add_disabled
                                                    : Icons.person_add,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            title: Text(
                                              isFollowingUser == true
                                                  ? 'Unfollow ${tweet.authorName}'
                                                  : 'Follow ${tweet.authorName}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            onPressed: () {
                                              isFollowingUser == true
                                                  ? unFollowUser()
                                                  : followUser();
                                            },
                                          ),
                                          BottomSheetAction(
                                            leading: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            title: Text(
                                              'Delete a tweet',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            onPressed: () {
                                              _tweetRepository.deleteTweet(
                                                currentUserId: currentUserId!,
                                                tweet: tweet,
                                              );
                                              _storageService.deleteTweetImage(
                                                imagesPath: tweet.imagesPath,
                                              );
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          BottomSheetAction(
                                            leading: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              child: Icon(
                                                Icons.chat_bubble,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            title: Text(
                                              'Change users who can reply',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            onPressed: () {},
                                          ),
                                        ],
                                      );
                              },
                              child: Container(
                                height: 20,
                                width: 30,
                                color: Colors.red,
                                child: Icon(
                                  Icons.more_vert,
                                  color: Colors.grey..shade600,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          tweet.text,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        tweet.imagesUrl.isEmpty
                            ? SizedBox.shrink()
                            : Column(
                                children: [
                                  SizedBox(height: 10),
                                  TweetImage(
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
                                  future: _dynamicLinkService.createDynamicLink(
                                    tweetId: tweet.tweetId!,
                                    tweetAuthorId: tweet.authorId,
                                    tweetText: tweet.text,
                                    imageUrl: tweet.hasImage
                                        ? tweet.imagesUrl['0']!
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
