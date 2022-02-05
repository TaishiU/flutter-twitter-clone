import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ProfileImageView extends StatelessWidget {
  final int tappedImageIndex;
  final String image;

  ProfileImageView({
    Key? key,
    required this.tappedImageIndex,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController(
      initialPage: tappedImageIndex,
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
        children: [
          profileImage(context: context),
        ],
      ),
    );
  }

  profileImage({required BuildContext context}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
              height: MediaQuery.of(context).size.height * 0.9,
              child: PhotoView(
                imageProvider: CachedNetworkImageProvider(
                  image,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
