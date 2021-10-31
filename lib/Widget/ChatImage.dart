import 'package:flutter/material.dart';
import 'package:twitter_clone/Model/Message.dart';

class ChatImage extends StatelessWidget {
  final String currentUserId;
  final Message message;
  final double containerHeight;
  final double containerWith;
  final double imageHeight;
  final double imageWith;

  ChatImage({
    Key? key,
    required this.currentUserId,
    required this.message,
    required this.containerHeight,
    required this.containerWith,
    required this.imageHeight,
    required this.imageWith,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message.images.isNotEmpty) {
      if (message.images.length == 1) {
        return _image1(context: context);
      } else if (message.images.length == 2) {
        return _image2(context: context);
      } else if (message.images.length == 3) {
        return _image3(context: context);
      } else if (message.images.length == 4) {
        return _image4(context: context);
      }
    }
    return SizedBox.shrink();
  }

  Widget _image1({required BuildContext context}) {
    return Container(
      height: containerHeight,
      width: containerWith,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(
            message.images['0']!,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _image2({required BuildContext context}) {
    return Container(
      height: containerHeight,
      width: containerWith,
      child: Column(
        children: [
          Container(
            height: imageHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              image: DecorationImage(
                image: NetworkImage(
                  message.images['0']!,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 4),
          Container(
            height: imageHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              image: DecorationImage(
                image: NetworkImage(
                  message.images['1']!,
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
      height: containerHeight,
      width: containerWith,
      child: Column(
        children: [
          Container(
            height: imageHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              image: DecorationImage(
                image: NetworkImage(
                  message.images['0']!,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Container(
                height: imageHeight,
                width: imageWith,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      message.images['1']!,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 4),
              Container(
                height: imageHeight,
                width: imageWith,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      message.images['2']!,
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
      height: containerHeight,
      width: containerWith,
      child: Row(
        children: [
          Column(
            children: [
              Container(
                height: imageHeight,
                width: imageWith,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      message.images['0']!,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 4),
              Container(
                height: imageHeight,
                width: imageWith,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      message.images['2']!,
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
                height: imageHeight,
                width: imageWith,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      message.images['1']!,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 4),
              Container(
                height: imageHeight,
                width: imageWith,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      message.images['3']!,
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
