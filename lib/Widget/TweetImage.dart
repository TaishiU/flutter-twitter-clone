import 'package:flutter/material.dart';

class TweetImage extends StatelessWidget {
  final Map<String, String> images;
  TweetImage({Key? key, required this.images}) : super(key: key);

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
    return Container(
      height: 180,
      width: MediaQuery.of(context).size.width * 0.76,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(
            images['0']!,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _image2({required BuildContext context}) {
    return Container(
      height: 180,
      width: MediaQuery.of(context).size.width * 0.76,
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.374,
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
          SizedBox(width: 4),
          Container(
            width: MediaQuery.of(context).size.width * 0.374,
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
        ],
      ),
    );
  }

  Widget _image3({required BuildContext context}) {
    return Container(
      height: 180,
      width: MediaQuery.of(context).size.width * 0.76,
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.374,
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
          SizedBox(width: 4),
          Column(
            children: [
              Container(
                height: 88,
                width: MediaQuery.of(context).size.width * 0.374,
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
              SizedBox(height: 4),
              Container(
                height: 88,
                width: MediaQuery.of(context).size.width * 0.374,
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _image4({required BuildContext context}) {
    return Container(
      height: 180,
      width: MediaQuery.of(context).size.width * 0.76,
      child: Row(
        children: [
          Column(
            children: [
              Container(
                height: 88,
                width: MediaQuery.of(context).size.width * 0.374,
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
              SizedBox(height: 4),
              Container(
                height: 88,
                width: MediaQuery.of(context).size.width * 0.374,
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
            ],
          ),
          SizedBox(width: 4),
          Column(
            children: [
              Container(
                height: 88,
                width: MediaQuery.of(context).size.width * 0.374,
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
              SizedBox(height: 4),
              Container(
                height: 88,
                width: MediaQuery.of(context).size.width * 0.374,
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
            ],
          ),
        ],
      ),
    );
  }
}
