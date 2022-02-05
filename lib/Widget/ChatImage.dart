import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:twitter_clone/Model/Message.dart';

class ChatImage extends HookWidget {
  final Message message;
  final double containerHeight;
  final double containerWith;
  final double imageHeight;
  final double imageWith;

  ChatImage({
    Key? key,
    required this.message,
    required this.containerHeight,
    required this.containerWith,
    required this.imageHeight,
    required this.imageWith,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message.imagesUrl.isNotEmpty) {
      if (message.imagesUrl.length == 1) {
        return _image1(context: context);
      } else if (message.imagesUrl.length == 2) {
        return _image2(context: context);
      } else if (message.imagesUrl.length == 3) {
        return _image3(context: context);
      } else if (message.imagesUrl.length == 4) {
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
          image: CachedNetworkImageProvider(
            message.imagesUrl['0']!,
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
                image: CachedNetworkImageProvider(
                  message.imagesUrl['0']!,
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
                image: CachedNetworkImageProvider(
                  message.imagesUrl['1']!,
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
                image: CachedNetworkImageProvider(
                  message.imagesUrl['0']!,
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
                    image: CachedNetworkImageProvider(
                      message.imagesUrl['1']!,
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
                    image: CachedNetworkImageProvider(
                      message.imagesUrl['2']!,
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
                    image: CachedNetworkImageProvider(
                      message.imagesUrl['0']!,
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
                    image: CachedNetworkImageProvider(
                      message.imagesUrl['2']!,
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
                    image: CachedNetworkImageProvider(
                      message.imagesUrl['1']!,
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
                    image: CachedNetworkImageProvider(
                      message.imagesUrl['3']!,
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
