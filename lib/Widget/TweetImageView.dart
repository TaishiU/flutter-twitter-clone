import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TweetImageView extends StatefulWidget {
  final int tappedImageIndex;
  final Map<String, String> images;

  TweetImageView({
    Key? key,
    required this.tappedImageIndex,
    required this.images,
  }) : super(key: key);

  @override
  _TweetImageViewState createState() => _TweetImageViewState();
}

class _TweetImageViewState extends State<TweetImageView> {
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
    PageController _pageController = PageController(
      initialPage: widget.tappedImageIndex,
    );

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
      body: PageView(
        controller: _pageController,
        children: widget.images.values.toList().map((image) {
          return Center(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(image),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.black45,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.mode_comment_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.repeat,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: _isLiked
                                ? Icon(Icons.favorite)
                                : Icon(Icons.favorite_border),
                            color: _isLiked ? Colors.red : Colors.white,
                            onPressed: () {
                              likeTweet();
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.share,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
