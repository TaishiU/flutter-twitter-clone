import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/src/provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/ViewModel/EditProfileNotifier.dart';

class EditProfileScreen extends HookWidget {
  final User user;
  EditProfileScreen({required this.user});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var _name = useProvider(profileNameProvider).state;
    var _bio = useProvider(profileBioProvider).state;
    final editProfileState = useProvider(editProfileProvider);
    final _profileImage = editProfileState.profileImage;
    final _coverImage = editProfileState.coverImage;
    final _isLoading = editProfileState.isLoading;
    final editProfileNotifier = context.read(editProfileProvider.notifier);
    // final TextEditingController nameController =
    //     TextEditingController(text: _name);
    // final TextEditingController bioController =
    //     TextEditingController(text: _bio);

    //仮説
    // TODO textEditingControllerのtext.lengthが0であればuser.name、１文字でもあれば_nameを渡す

    useEffect(() {
      _name = user.name;
      //context.read(profileNameProvider).state = user.name;
      print('初期化したname: $_name');
      _bio = user.bio;
      print('初期化したbio: $_bio');
    }, []);

    displayCoverImage() {
      if (_coverImage == null) {
        if (user.coverImage.isNotEmpty) {
          return NetworkImage(user.coverImage);
        }
      } else {
        return FileImage(_coverImage);
      }
    }

    displayProfileImage() {
      if (_profileImage == null) {
        if (user.profileImage.isNotEmpty) {
          return NetworkImage(user.profileImage);
        }
      } else {
        return FileImage(_profileImage);
      }
    }

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
            onPressed: () async {
              print('ボタンをクリック, _name: $_name');
              print('ボタンをクリック, _bio: $_bio');
              if (_isLoading == false) {
                final isFalse = await editProfileNotifier.saveProfile(
                  user: user,
                  name: _name,
                  bio: _bio,
                  // name: nameController.text.length > 0 ? _name : user.name,
                  // bio: bioController.text.length > 0 ? _bio : user.bio,
                );
                /*falseが帰ってきたら前のページに戻る*/
                if (isFalse == false) {
                  Navigator.of(context).pop();
                } else {
                  print('edit Profile error...');
                  print('isFalse: $isFalse');
                }
              } else {
                print('プロフィールを保存中なのでボタンをクリックしても無効です');
                print('保存中の_isLoading: $_isLoading');
              }
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
              editProfileNotifier.handleImageFromGallery(type: 'cover');
            },
            child: Stack(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: TwitterColor,
                    image: user.coverImage.isEmpty && _coverImage == null
                        ? null
                        : DecorationImage(
                            image: displayCoverImage() as ImageProvider,
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
                        editProfileNotifier.handleImageFromGallery(
                            type: 'profile');
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
                            backgroundImage: user.profileImage.isEmpty &&
                                    _profileImage == null
                                ? null
                                : displayProfileImage() as ImageProvider,
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
                        initialValue: user.name,
                        //controller: TextEditingController(text: _name),
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(color: TwitterColor),
                        ),
                        validator: (input) => input!.trim().length < 2
                            ? 'please enter valid name'
                            : null,
                        onChanged: (String? value) {
                          context.read(profileNameProvider).state = value!;
                        },
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        initialValue: user.bio,
                        //controller: bioController,
                        decoration: InputDecoration(
                          labelText: 'Bio',
                          labelStyle: TextStyle(color: TwitterColor),
                        ),
                        validator: (input) => input!.trim().length < 2
                            ? 'please enter valid bio'
                            : null,
                        onChanged: (String? value) {
                          context.read(profileBioProvider).state = value!;
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
