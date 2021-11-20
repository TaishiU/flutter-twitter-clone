import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Repository/UserRepository.dart';
import 'package:twitter_clone/Service/StorageService.dart';

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
  bool _isLoading = false;
  late String _imagePickedType;
  final _formKey = GlobalKey<FormState>();
  final UserRepository _userRepository = UserRepository();
  final StorageService _storageService = StorageService();

  @override
  initState() {
    super.initState();
    _name = widget.user.name;
    _bio = widget.user.bio;
  }

  displayCoverImage() {
    if (_coverImage == null) {
      if (widget.user.coverImageUrl.isNotEmpty) {
        return NetworkImage(widget.user.coverImageUrl);
      }
    } else {
      return FileImage(_coverImage!);
    }
  }

  displayProfileImage() {
    if (_profileImage == null) {
      if (widget.user.profileImageUrl.isNotEmpty) {
        return NetworkImage(widget.user.profileImageUrl);
      }
    } else {
      return FileImage(_profileImage!);
    }
  }

  handleImageFromGallery() async {
    try {
      final imageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
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
      String _profileImageUrl = '';
      String _profileImagePath = '';
      String _coverImageUrl = '';
      String _coverImagePath = '';
      if (_profileImage == null) {
        _profileImageUrl = widget.user.profileImageUrl;
        _profileImagePath = widget.user.profileImagePath;
      } else {
        Map<String, String> profileData =
            await _storageService.uploadProfileImage(
                userId: widget.user.userId, imageFile: _profileImage!);
        _profileImageUrl = profileData['url']!;
        _profileImagePath = profileData['path']!;
      }
      if (_coverImage == null) {
        _coverImageUrl = widget.user.coverImageUrl;
        _coverImagePath = widget.user.coverImagePath;
      } else {
        Map<String, String> coverData = await _storageService.uploadCoverImage(
            userId: widget.user.userId, imageFile: _coverImage!);
        _coverImageUrl = coverData['url']!;
        _coverImagePath = coverData['path']!;
      }

      User user = User(
        userId: widget.user.userId,
        name: _name,
        email: widget.user.email,
        bio: _bio,
        profileImageUrl: _profileImageUrl,
        profileImagePath: _profileImagePath,
        coverImageUrl: _coverImageUrl,
        coverImagePath: _coverImagePath,
        fcmToken: widget.user.fcmToken,
      );
      await _userRepository.updateUserData(user: user);
      setState(() {
        _isLoading = false;
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
        centerTitle: false,
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            onPressed: () {
              saveProfile();
            },
          ),
        ],
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
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color:
                        widget.user.coverImageUrl.isEmpty && _coverImage == null
                            ? TwitterColor
                            : Colors.transparent,
                    image:
                        widget.user.coverImageUrl.isEmpty && _coverImage == null
                            ? null
                            : DecorationImage(
                                image: displayCoverImage(),
                                fit: BoxFit.cover,
                              ),
                  ),
                ),
                Container(
                  height: 150,
                  color: Colors.black54,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        size: 50,
                        color: Colors.white,
                      ),
                    ],
                  ),
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
                            backgroundColor:
                                widget.user.profileImageUrl.isEmpty &&
                                        _profileImage == null
                                    ? TwitterColor
                                    : Colors.transparent,
                            backgroundImage:
                                widget.user.profileImageUrl.isEmpty &&
                                        _profileImage == null
                                    ? null
                                    : displayProfileImage(),
                          ),
                          CircleAvatar(
                            radius: 42,
                            backgroundColor: Colors.black54,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          )
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
                      SizedBox(height: 30),
                      _isLoading
                          ? CircularProgressIndicator()
                          : SizedBox.shrink(),
                    ],
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
