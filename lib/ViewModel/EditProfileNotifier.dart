import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Firebase/Storage.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/State/EditProfileState.dart';

final editProfileProvider =
    StateNotifierProvider<EditProfileNotifier, EditProfileState>(
  (ref) => EditProfileNotifier(),
);

class EditProfileNotifier extends StateNotifier<EditProfileState> {
  EditProfileNotifier() : super(const EditProfileState());

  Future<void> handleImageFromGallery({
    required String type,
  }) async {
    try {
      final imageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        if (type == 'cover') {
          final File _coverImage;
          _coverImage = File(imageFile.path);
          state = state.copyWith(coverImage: _coverImage);
        } else if (type == 'profile') {
          final File _profileImage;
          _profileImage = File(imageFile.path);
          state = state.copyWith(profileImage: _profileImage);
        }
      }
    } catch (e) {
      print('image_pickerエラー');
      print('error message: $e');
    }
  }

  Future<bool> saveProfile({
    required User user,
    required String name,
    required String bio,
  }) async {
    state = state.copyWith(isLoading: true);
    String profileImageUrl = '';
    String coverImageUrl = '';
    if (state.profileImage == null) {
      profileImageUrl = user.profileImage;
    } else {
      profileImageUrl = await Storage().uploadProfileImage(
          userId: user.userId, imageFile: state.profileImage!);
    }
    if (state.coverImage == null) {
      coverImageUrl = user.coverImage;
    } else {
      coverImageUrl = await Storage()
          .uploadCoverImage(userId: user.userId, imageFile: state.coverImage!);
    }

    User userData = User(
      userId: user.userId,
      name: name,
      email: user.email,
      bio: bio,
      profileImage: profileImageUrl,
      coverImage: coverImageUrl,
      fcmToken: user.fcmToken,
    );
    await Firestore().updateUserData(user: userData);
    print('プロフィール情報を保存しました！');

    state = state.copyWith(isLoading: false);
    //isLoading: falseを返す
    return state.isLoading;
  }
}
