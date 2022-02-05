import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Widget/TweetImageView.dart';

class TweetImage extends StatelessWidget {
  final Tweet tweet;
  final double containerHeight;
  final double containerWith;
  final double imageHeight;
  final double imageWith;

  TweetImage({
    Key? key,
    required this.tweet,
    required this.containerHeight,
    required this.containerWith,
    required this.imageHeight,
    required this.imageWith,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tweet.imagesUrl.isNotEmpty) {
      if (tweet.imagesUrl.length == 1) {
        return _image1(context: context);
      } else if (tweet.imagesUrl.length == 2) {
        return _image2(context: context);
      } else if (tweet.imagesUrl.length == 3) {
        return _image3(context: context);
      } else if (tweet.imagesUrl.length == 4) {
        return _image4(context: context);
      }
    }
    return SizedBox.shrink();
  }

  Widget _image1({required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TweetImageView(
              tappedImageIndex: 0,
              tweet: tweet,
            ),
          ),
        );
      },
      child: Container(
        height: containerHeight,
        width: containerWith,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(
              tweet.imagesUrl['0']!,
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _image2({required BuildContext context}) {
    return Container(
      height: containerHeight,
      width: containerWith,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TweetImageView(
                    tappedImageIndex: 0,
                    tweet: tweet,
                  ),
                ),
              );
            },
            child: Container(
              width: imageWith,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    tweet.imagesUrl['0']!,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TweetImageView(
                    tappedImageIndex: 1,
                    tweet: tweet,
                  ),
                ),
              );
            },
            child: Container(
              width: imageWith,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    tweet.imagesUrl['1']!,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _image3({required BuildContext context}) {
    return Container(
      height: containerHeight,
      width: containerWith,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TweetImageView(
                    tappedImageIndex: 0,
                    tweet: tweet,
                  ),
                ),
              );
            },
            child: Container(
              width: imageWith,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    tweet.imagesUrl['0']!,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(width: 4),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TweetImageView(
                        tappedImageIndex: 1,
                        tweet: tweet,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: imageHeight,
                  width: imageWith,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                    ),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        tweet.imagesUrl['1']!,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TweetImageView(
                        tappedImageIndex: 2,
                        tweet: tweet,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: imageHeight,
                  width: imageWith,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                    ),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        tweet.imagesUrl['2']!,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _image4({required BuildContext context}) {
    return Container(
      height: containerHeight,
      width: containerWith,
      child: Row(
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TweetImageView(
                        tappedImageIndex: 0,
                        tweet: tweet,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: imageHeight,
                  width: imageWith,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                    ),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        tweet.imagesUrl['0']!,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TweetImageView(
                        tappedImageIndex: 2,
                        tweet: tweet,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: imageHeight,
                  width: imageWith,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                    ),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        tweet.imagesUrl['2']!,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 4),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TweetImageView(
                        tappedImageIndex: 1,
                        tweet: tweet,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: imageHeight,
                  width: imageWith,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                    ),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        tweet.imagesUrl['1']!,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TweetImageView(
                        tappedImageIndex: 3,
                        tweet: tweet,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: imageHeight,
                  width: imageWith,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                    ),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        tweet.imagesUrl['3']!,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
