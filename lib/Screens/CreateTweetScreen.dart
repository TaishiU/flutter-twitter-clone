import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/Constants/Constants.dart';

class CreateTweetScreen extends StatefulWidget {
  final String currentUserId;

  CreateTweetScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _CreateTweetScreenState createState() => _CreateTweetScreenState();
}

class _CreateTweetScreenState extends State<CreateTweetScreen> {
  //late String _tweetText;
  List<File> _tweetImageList = [];
  //bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  handleImageFromGallery() async {
    try {
      PickedFile? imageFile =
          await ImagePicker().getImage(source: ImageSource.gallery);
      if (imageFile != null) {
        setState(() {
          _tweetImageList.add(File(imageFile.path));
        });
      }
    } catch (e) {
      print('image_pickerエラー');
    }
  }

  removeImageFromList({required File image}) {
    _tweetImageList.removeWhere((removeImage) => removeImage == image);
    /*_tweetImageListの画像の中から削除ボタンを押された画像を削除*/
    setState(() {
      _tweetImageList = _tweetImageList;
      /*削除されていない画像が_tweetImageListに再びセットされる*/
    });
  }

  // handleTweet() async {
  //   _formKey.currentState!.save();
  //   if (_formKey.currentState!.validate() && !_isLoading) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     String tweetImageUrl;
  //     bool hasImage;
  //     if (_tweetImage == null) {
  //       tweetImageUrl = '';
  //       hasImage = false;
  //     } else {
  //       tweetImageUrl = await Storage().uploadTweetImage(
  //           userId: widget.currentUserId, imageFile: _tweetImage!);
  //       hasImage = true;
  //     }
  //
  //     DocumentSnapshot userProfileDoc =
  //         await Firestore().getUserProfile(userId: widget.currentUserId);
  //     User user = User.fromDoc(userProfileDoc);
  //
  //     Tweet tweet = Tweet(
  //       authorName: user.name,
  //       authorId: user.userId,
  //       authorProfileImage: user.profileImage,
  //       text: _tweetText,
  //       image: tweetImageUrl,
  //       hasImage: hasImage,
  //       timestamp: Timestamp.fromDate(DateTime.now()),
  //       likes: 0,
  //       reTweets: 0,
  //     );
  //     Firestore().createTweet(tweet: tweet);
  //     Navigator.of(context).pop();
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: Text(
          'Tweet',
          style: TextStyle(
            color: TwitterColor,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        /*キーボード表示時のRenderFlexOverFlowedエラーの解消用にSingleChildScrollViewを使う*/
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  /* keyboardTypeとmaxLinesを上記のように指定することでテキスト折り返しが可能になる */
                  maxLength: 140,
                  decoration: InputDecoration(
                    hintText: 'Enter your Tweet',
                  ),
                  validator: (input) => input!.trim().length < 1
                      ? 'Please enter your Tweet'
                      : null,
                  onChanged: (value) {
                    // _tweetText = value;
                  },
                ),
              ),
              // _tweetImage == null
              //     ? SizedBox.shrink()
              //     : Column(
              //         children: [
              //           Container(
              //             height: 200,
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(20),
              //               color: TwitterColor,
              //               image: DecorationImage(
              //                 image: FileImage(_tweetImage!),
              //                 fit: BoxFit.cover,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  handleImageFromGallery();
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
              Container(
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
                              removeImageFromList(
                                  image: _tweetImageList[index]);
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
              // SizedBox(height: 20),
              // RoundedButton(
              //   btnText: 'Tweet',
              //   onBtnPressed: () {
              //     handleTweet();
              //   },
              // ),
              // SizedBox(height: 5),
              // _isLoading ? CircularProgressIndicator() : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
