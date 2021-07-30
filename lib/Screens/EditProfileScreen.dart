import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Firebase/Storage.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Widget/RoundedButton.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late String _name;
  late String _bio;
  File? _profileImage;
  File? _coverImage;
  late String _imagePickedType;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  initState() {
    super.initState();
    _name = widget.user.name;
    _bio = widget.user.bio;
  }

  displayCoverImage() {
    if (_coverImage == null) {
      if (widget.user.coverImage.isNotEmpty) {
        return NetworkImage(widget.user.coverImage);
      }
    } else {
      return FileImage(_coverImage!);
    }
  }

  displayProfileImage() {
    if (_profileImage == null) {
      if (widget.user.profileImage.isNotEmpty) {
        return NetworkImage(widget.user.profileImage);
      }
    } else {
      return FileImage(_profileImage!);
    }
  }

  handleImageFromGallery() async {
    try {
      PickedFile? imageFile =
          await ImagePicker().getImage(source: ImageSource.gallery);
      if (imageFile != null) {
        if (_imagePickedType == 'cover') {
          setState(() {
            _coverImage = File(imageFile.path);
          });
        } else if (_imagePickedType == 'profile') {
          setState(() {
            _profileImage = File(imageFile.path);
          });
        }
      }
    } catch (e) {
      print('image_pickerエラー');
    }
  }

  saveProfile() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate() && !_isLoading) {
      setState(() {
        _isLoading = true;
      });
      String profileImageUrl = '';
      String coverImageUrl = '';
      if (_profileImage == null) {
        profileImageUrl = widget.user.profileImage;
      } else {
        profileImageUrl = await Storage().uploadProfileImage(
            userId: widget.user.userId, imageFile: _profileImage!);
      }
      if (_coverImage == null) {
        coverImageUrl = widget.user.coverImage;
      } else {
        coverImageUrl = await Storage().uploadCoverImage(
            userId: widget.user.userId, imageFile: _coverImage!);
      }

      User user = User(
        userId: widget.user.userId,
        name: _name,
        email: widget.user.email,
        bio: _bio,
        profileImage: profileImageUrl,
        coverImage: coverImageUrl,
      );
      await Firestore().updateUserData(user: user);
      setState(() {
        _isLoading = true;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: BackButton(
          color: TwitterColor,
        ),
        title: Text(
          widget.user.name,
          style: TextStyle(
            color: TwitterColor,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: [
          GestureDetector(
            onTap: () {
              _imagePickedType = 'cover';
              handleImageFromGallery();
            },
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: TwitterColor,
                    image: widget.user.coverImage.isEmpty && _coverImage == null
                        ? null
                        : DecorationImage(
                            image: displayCoverImage(),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.photo_camera,
                    size: 30,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    _imagePickedType = 'cover';
                    handleImageFromGallery();
                  },
                ),
              ],
            ),
          ),
          Container(
            transform: Matrix4.translationValues(0, -45, 0),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _imagePickedType = 'profile';
                        handleImageFromGallery();
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.white,
                          ),
                          CircleAvatar(
                            radius: 42,
                            backgroundColor: TwitterColor,
                            backgroundImage: widget.user.profileImage.isEmpty &&
                                    _profileImage == null
                                ? null
                                : displayProfileImage(),
                            //backgroundColor: TwitterColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _name,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(color: TwitterColor),
                        ),
                        validator: (input) => input!.trim().length < 2
                            ? 'please enter valid name'
                            : null,
                        onSaved: (value) {
                          _name = value!;
                        },
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        initialValue: _bio,
                        decoration: InputDecoration(
                          labelText: 'Bio',
                          labelStyle: TextStyle(color: TwitterColor),
                        ),
                        validator: (input) => input!.trim().length < 2
                            ? 'please enter valid bio'
                            : null,
                        onSaved: (value) {
                          _bio = value!;
                        },
                      ),
                      _isLoading
                          ? CircularProgressIndicator()
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Center(
                  child: RoundedButton(
                    btnText: 'Save',
                    onBtnPressed: () {
                      saveProfile();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
