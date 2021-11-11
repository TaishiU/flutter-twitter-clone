import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Repository/UserRepository.dart';
import 'package:twitter_clone/Service/StorageService.dart';
import 'package:twitter_clone/State/EditProfileState.dart';

final editProfileProvider =
    StateNotifierProvider<EditProfileNotifier, EditProfileState>(
  (ref) => EditProfileNotifier(),
);

class EditProfileNotifier extends StateNotifier<EditProfileState> {
  EditProfileNotifier() : super(const EditProfileState());

  final UserRepository _userRepository = UserRepository();
  final StorageService _storageService = StorageService();

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
    String _profileImageUrl = '';
    String _profileImagePath = '';
    String _coverImageUrl = '';
    String _coverImagePath = '';
    if (state.profileImage == null) {
      _profileImageUrl = user.profileImageUrl;
      _profileImagePath = user.profileImagePath;
    } else {
      Map<String, String> profileData =
          await _storageService.uploadProfileImage(
              userId: user.userId, imageFile: state.profileImage!);
      _profileImageUrl = profileData['url']!;
      _profileImagePath = profileData['path']!;
    }
    if (state.coverImage == null) {
      _coverImageUrl = user.coverImageUrl;
      _coverImagePath = user.coverImagePath;
    } else {
      Map<String, String> coverData = await _storageService.uploadCoverImage(
          userId: user.userId, imageFile: state.coverImage!);
      _coverImageUrl = coverData['url']!;
      _coverImagePath = coverData['path']!;
    }

    User userData = User(
      userId: user.userId,
      name: name,
      email: user.email,
      bio: bio,
      profileImageUrl: _profileImageUrl,
      profileImagePath: _profileImagePath,
      coverImageUrl: _coverImageUrl,
      coverImagePath: _coverImagePath,
      fcmToken: user.fcmToken,
    );
    await _userRepository.updateUserData(user: userData);
    print('プロフィール情報を保存しました！');

    state = state.copyWith(isLoading: false);
    //isLoading: falseを返す
    return state.isLoading;
  }
}
