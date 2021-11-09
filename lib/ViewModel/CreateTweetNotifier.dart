import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Firebase/Storage.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/State/CreateTweetState.dart';

final createTweetProvider =
    StateNotifierProvider<CreateTweetNotifier, CreateTweetState>(
  (ref) => CreateTweetNotifier(ref.read),
);

class CreateTweetNotifier extends StateNotifier<CreateTweetState> {
  final Reader _read;
  CreateTweetNotifier(this._read) : super(const CreateTweetState());

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

    Map<String, String> _images = {};
    bool hasImage = false;

    final String? currentUserId = _read(currentUserIdProvider);

    /*画像がある場合*/
    if (state.tweetImageList.length != 0) {
      _images = await _uploadImage(currentUserId: currentUserId!);
      /* _uploadImage()メソッド↓ */
      hasImage = true;
    }

    /*画像がない場合*/
    /*上記で宣言した「_images = {}, hasImage = false」がFirestoreに保存される*/

    DocumentSnapshot userProfileDoc =
        await Firestore().getUserProfile(userId: currentUserId!);
    User user = User.fromDoc(userProfileDoc);

    Tweet tweet = Tweet(
      authorName: user.name,
      authorId: user.userId,
      authorBio: user.bio,
      authorProfileImage: user.profileImage,
      text: tweetText,
      images: _images,
      hasImage: hasImage,
      timestamp: Timestamp.fromDate(DateTime.now()),
      likes: 0,
      reTweets: 0,
    );

    Firestore().createTweet(tweet: tweet);

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

  Future<Map<String, String>> _uploadImage({
    required String? currentUserId,
  }) async {
    /*Storage格納後に返却されるURLを格納*/
    Map<String, String> _images = {};
    Map<int, File> _pickedImages = state.tweetImageList.asMap();
    if (_pickedImages.isNotEmpty) {
      for (var _pickedImage in _pickedImages.entries) {
        String _tweetImageUrl = await Storage().uploadTweetImage(
            userId: currentUserId!, imageFile: _pickedImage.value);
        /* Mapの「key = value」の型 */
        _images[_pickedImage.key.toString()] = _tweetImageUrl;
      }
    }
    return _images;
  }
}
