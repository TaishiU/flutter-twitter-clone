import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Repository/TweetRepository.dart';
import 'package:twitter_clone/Repository/UserRepository.dart';
import 'package:twitter_clone/Service/StorageService.dart';
import 'package:twitter_clone/State/CreateTweetState.dart';

final createTweetProvider =
    StateNotifierProvider<CreateTweetNotifier, CreateTweetState>(
  (ref) => CreateTweetNotifier(ref.read),
);

class CreateTweetNotifier extends StateNotifier<CreateTweetState> {
  final Reader _read;
  CreateTweetNotifier(this._read) : super(const CreateTweetState());

  final UserRepository _userRepository = UserRepository();
  final TweetRepository _tweetRepository = TweetRepository();
  final StorageService _storageService = StorageService();

  void handleImageFromGallery() async {
    try {
      final imageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        final File _image;
        _image = File(imageFile.path);
        final newList = [...state.tweetImageList, _image];
        state = state.copyWith(tweetImageList: newList);
        print('投稿前の_tweetImageList.length: ${state.tweetImageList.length}');
        print('投稿前の_tweetImageList: ${state.tweetImageList}');
      }
    } catch (e) {
      print('ImagePickerエラー');
    }
  }

  void removeImageFromList({required File removeImage}) {
    /*tweetImageListの中からremoveImageでないimageを再リスト化*/
    final newList =
        state.tweetImageList.where((image) => image != removeImage).toList();
    state = state.copyWith(tweetImageList: newList);
  }

  void resetImageList() {
    final List<File> resetList = [];
    state = state.copyWith(tweetImageList: resetList);
    print('前のページに戻ったので、tweetImageListを初期化しました！');
    print('state.tweetImageList: ${state.tweetImageList}');
  }

  Future<bool> handleTweet({
    required String tweetText,
  }) async {
    state = state.copyWith(isLoading: true);
    print('投稿開始、isLoading: ${state.isLoading}');

    Map<String, String> _imagesUrl = {};
    Map<String, String> _imagesPath = {};
    bool hasImage = false;

    final String? currentUserId = _read(currentUserIdProvider);

    /*画像がある場合*/
    if (state.tweetImageList.length != 0) {
      Map<String, Map<String, String>> data =
          await _uploadImage(currentUserId: currentUserId!);
      _imagesUrl = data['urlData']!;
      _imagesPath = data['pathData']!;
      /* _uploadImage()メソッド↓ */
      hasImage = true;
    }

    /*画像がない場合*/
    /*上記で宣言した「_images = {}, hasImage = false」がFirestoreに保存される*/

    DocumentSnapshot userProfileDoc =
        await _userRepository.getUserProfile(userId: currentUserId!);
    User user = User.fromDoc(userProfileDoc);

    Tweet tweet = Tweet(
      authorName: user.name,
      authorId: user.userId,
      authorBio: user.bio,
      authorProfileImage: user.profileImageUrl,
      text: tweetText,
      imagesUrl: _imagesUrl,
      imagesPath: _imagesPath,
      hasImage: hasImage,
      timestamp: Timestamp.fromDate(DateTime.now()),
      likes: 0,
      reTweets: 0,
    );

    _tweetRepository.createTweet(tweet: tweet);

    //state.tweetImageListを初期化
    final List<File> resetList = [];
    state = state.copyWith(tweetImageList: resetList);
    print('投稿が終了し、tweetImageListを初期化しました！');
    print('state.tweetImageList: ${state.tweetImageList}');

    state = state.copyWith(isLoading: false);
    print('投稿終了、isLoading: ${state.isLoading}');
    //isLoading: falseを返す
    return state.isLoading;
  }

  Future<Map<String, Map<String, String>>> _uploadImage({
    required String? currentUserId,
  }) async {
    Map<String, String> _imagesUrl = {}; /*Storage格納後に返却されるURLを格納*/
    Map<String, String> _imagesPath = {}; /*Storage格納後に返却されるPathを格納*/
    Map<String, Map<String, String>> _imagesData = {};
    Map<int, File> _pickedImages = state.tweetImageList.asMap();
    if (_pickedImages.isNotEmpty) {
      for (var _pickedImage in _pickedImages.entries) {
        Map<String, String> data = await _storageService.uploadTweetImage(
            userId: currentUserId!, imageFile: _pickedImage.value);
        String _tweetImageUrl = data['url']!;
        String _tweetImagePath = data['path']!;
        _imagesUrl[_pickedImage.key.toString()] = _tweetImageUrl;
        _imagesPath[_pickedImage.key.toString()] = _tweetImagePath;

        _imagesData = {
          'urlData': _imagesUrl,
          'pathData': _imagesPath,
        };
      }
    }
    return _imagesData;
  }
}
