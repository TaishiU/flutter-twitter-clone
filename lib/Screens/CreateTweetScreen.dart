import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/TweetProvider.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/ViewModel/CreateTweetNotifier.dart';

class CreateTweetScreen extends HookWidget {
  CreateTweetScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final String? currentUserId = useProvider(currentUserIdProvider);
    final _tweetText = useProvider(tweetTextProvider).state;
    final createTweetState = useProvider(createTweetProvider);
    final _tweetImageList = createTweetState.tweetImageList;
    final _isLoading = createTweetState.isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            size: 28,
            color: Colors.black,
          ),
          onPressed: () {
            context.read(createTweetProvider.notifier).resetImageList();
            Navigator.pop(context);
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: _tweetText.length >= 1
                ? ElevatedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Tweet',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: _isLoading == true
                          ? Colors.lightBlue.shade200
                          : TwitterColor,
                      onPrimary: Colors.black,
                      shape: StadiumBorder(),
                    ),
                    onPressed: () async {
                      if (_isLoading == false) {
                        final isFalse = await context
                            .read(createTweetProvider.notifier)
                            .handleTweet(
                              tweetText: _tweetText,
                            );

                        /*falseが帰ってきたら前のページに戻る*/
                        if (isFalse == false) {
                          final snackBar = SnackBar(
                            backgroundColor: TwitterColor,
                            content: Text(
                              'You sent a tweet, successfully🎉',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          Navigator.of(context).pop();
                        } else {
                          print('create tweet error...');
                          print('isFalse: $isFalse');
                        }
                      } else {
                        print('投稿中なのでボタンをクリックしても無効です');
                        print('投稿中の_isLoading: $_isLoading');
                      }
                    },
                  )
                : ElevatedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Tweet',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlue.shade200,
                      onPrimary: Colors.black,
                      shape: StadiumBorder(),
                    ),
                    onPressed: () {
                      print('テキストが入力されていません...');
                    },
                  ),
          )
        ],
      ),
      body: SingleChildScrollView(
        /*キーボード表示時のRenderFlexOverFlowedエラーの解消用にSingleChildScrollViewを使う*/
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 5),
                        StreamBuilder(
                          stream: usersRef.doc(currentUserId).snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return CircleAvatar(
                                radius: 20,
                                backgroundColor: TwitterColor,
                              );
                            }
                            User user = User.fromDoc(snapshot.data);
                            return CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.transparent,
                              backgroundImage: user.profileImageUrl.isEmpty
                                  ? null
                                  : CachedNetworkImageProvider(
                                      user.profileImageUrl),
                            );
                          },
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        autofocus: true,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        /* keyboardTypeとmaxLinesを上記のように指定することでテキスト折り返しが可能になる */
                        maxLength: 140,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'What\'s happening? ',
                        ),
                        validator: (input) => input!.trim().length < 1
                            ? 'Please enter your Tweet'
                            : null,
                        onChanged: (value) {
                          context.read(tweetTextProvider).state = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              _tweetImageList.length > 3
                  ? SizedBox.shrink()
                  : GestureDetector(
                      onTap: () {
                        context
                            .read(createTweetProvider.notifier)
                            .handleImageFromGallery();
                      },
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(
                            color: TwitterColor,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 50,
                          color: TwitterColor,
                        ),
                      ),
                    ),
              SizedBox(height: 20),
              _tweetImageList.length == 0
                  ? SizedBox.shrink()
                  : Container(
                      height: 200,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: _tweetImageList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                width: MediaQuery.of(context).size.width * 0.8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: FileImage(_tweetImageList[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 15,
                                child: GestureDetector(
                                  onTap: () {
                                    context
                                        .read(createTweetProvider.notifier)
                                        .removeImageFromList(
                                            removeImage:
                                                _tweetImageList[index]);
                                  },
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black45,
                                    ),
                                    child: Icon(
                                      Icons.clear_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
              SizedBox(height: 50),
              _isLoading ? CircularProgressIndicator() : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
