import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share/share.dart';
import 'package:twitter_clone/Model/Comment.dart';
import 'package:twitter_clone/Model/Likes.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Provider/TweetProvider.dart';
import 'package:twitter_clone/ViewModel/IsLikedNotifier.dart';

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
    final asyncAllTweetComments = useProvider(allTweetCommentsProvider(tweet));
    final asyncAllTweetLikes = useProvider(allTweetLikesProvider(tweet));
    final asyncShare = useProvider(shareProvider(tweet));
    final isLikedState = useProvider(isLikedProvider);
    final _isLiked = isLikedState.isLikedTweet;
    final _isLikedNotifier = context.read(isLikedProvider.notifier);

    useEffect(() {
      _isLikedNotifier.setupIsLiked(tweet: tweet);
    }, []);

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
                        imageProvider:
                            CachedNetworkImageProvider(tweet.imagesUrl['$i']!),
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
                          child: asyncAllTweetComments.when(
                            loading: () => SizedBox.shrink(),
                            error: (error, stack) =>
                                Center(child: Text('Error: $error')),
                            data: (List<Comment> allTweetCommentsList) {
                              return allTweetCommentsList.length == 0
                                  ? SizedBox.shrink()
                                  : Text(
                                      allTweetCommentsList.length.toString(),
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
                            _isLikedNotifier.likeOrUnLikeTweet(tweet: tweet);
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
                          child: asyncAllTweetLikes.when(
                            loading: () => SizedBox.shrink(),
                            error: (error, stack) =>
                                Center(child: Text('Error: $error')),
                            data: (List<Likes> allTweetLikesList) {
                              return allTweetLikesList.length == 0
                                  ? SizedBox.shrink()
                                  : Text(
                                      allTweetLikesList.length.toString(),
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
