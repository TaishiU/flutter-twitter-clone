import 'package:flutter/material.dart';
import 'package:twitter_clone/Widget/TweetImageView.dart';

class TweetImage extends StatelessWidget {
  final Map<String, String> images;
  final double containerHeight;
  final double containerWith;
  final double imageHeight;
  final double imageWith;

  TweetImage({
    Key? key,
    required this.images,
    required this.containerHeight,
    required this.containerWith,
    required this.imageHeight,
    required this.imageWith,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (images.isNotEmpty) {
      if (images.length == 1) {
        return _image1(context: context);
      } else if (images.length == 2) {
        return _image2(context: context);
      } else if (images.length == 3) {
        return _image3(context: context);
      } else if (images.length == 4) {
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
              images: images,
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
              images['0']!,
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
                    images: images,
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
                  image: NetworkImage(
                    images['0']!,
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
                    images: images,
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
                  image: NetworkImage(
                    images['1']!,
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
                    images: images,
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
                  image: NetworkImage(
                    images['0']!,
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
                        images: images,
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
                      image: NetworkImage(
                        images['1']!,
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
                        images: images,
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
                      image: NetworkImage(
                        images['2']!,
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
                        images: images,
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
                      image: NetworkImage(
                        images['0']!,
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
                        images: images,
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
                      image: NetworkImage(
                        images['2']!,
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
                        images: images,
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
                      image: NetworkImage(
                        images['1']!,
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
                        images: images,
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
                      image: NetworkImage(
                        images['3']!,
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
