import 'package:flutter/material.dart';

class ProfileImageView extends StatefulWidget {
  final int tappedImageIndex;
  final String image;

  ProfileImageView({
    Key? key,
    required this.tappedImageIndex,
    required this.image,
  }) : super(key: key);

  @override
  _ProfileImageViewState createState() => _ProfileImageViewState();
}

class _ProfileImageViewState extends State<ProfileImageView> {
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
        children: [
          profileImage(),
        ],
      ),
    );
  }

  profileImage() {
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
              child: Image.network(
                widget.image,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
