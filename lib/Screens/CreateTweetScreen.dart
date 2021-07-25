import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Widget/RoundedButton.dart';

class CreateTweetScreen extends StatefulWidget {
  final String currentUserId;

  CreateTweetScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _CreateTweetScreenState createState() => _CreateTweetScreenState();
}

class _CreateTweetScreenState extends State<CreateTweetScreen> {
  late String _tweetText;
  File? _tweetImage;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  handleImageFromGallery() async {
    try {
      PickedFile? imageFile =
          await ImagePicker().getImage(source: ImageSource.gallery);
      if (imageFile != null) {
        setState(() {
          _tweetImage = File(imageFile.path);
        });
      }
    } catch (e) {
      print('image_pickerエラー： ${e}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TwitterColor,
        title: Text(
          'Tweet',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          /*キーボード表示時のRenderFlexOverFlowedエラーの解消用にSingleChildScrollViewを使う*/
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                TextFormField(
                  maxLength: 140,
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText: 'Enter your Tweet',
                  ),
                  validator: (input) => input!.trim().length < 1
                      ? 'Please enter your Tweet'
                      : null,
                  onChanged: (value) {
                    _tweetText = value;
                  },
                ),
                SizedBox(height: 10),
                _tweetImage == null
                    ? SizedBox.shrink()
                    : Column(
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: TwitterColor,
                              image: DecorationImage(
                                image: FileImage(_tweetImage!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                RoundedButton(
                  btnText: 'Tweet',
                  onBtnPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
