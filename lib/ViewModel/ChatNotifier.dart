import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/Model/Message.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Repository/MessageRepository.dart';
import 'package:twitter_clone/Repository/UserRepository.dart';
import 'package:twitter_clone/Service/StorageService.dart';
import 'package:twitter_clone/State/ChatState.dart';

final chatNotifierProvider = StateNotifierProvider<ChatNotifier, ChatState>(
  (ref) => ChatNotifier(ref.read),
);

class ChatNotifier extends StateNotifier<ChatState> {
  final Reader _read;
  ChatNotifier(this._read) : super(const ChatState());

  final UserRepository _userRepository = UserRepository();
  final MessageRepository _messageRepository = MessageRepository();
  final StorageService _storageService = StorageService();

  Future<void> handleImage({
    required String type,
    required String convoId,
    required User peerUser,
  }) async {
    try {
      if (type == 'camera') {
        final imageFile =
            await ImagePicker().pickImage(source: ImageSource.camera);
        if (imageFile != null) {
          final File _image;
          _image = File(imageFile.path);
          final newList = [...state.chatImageList, _image];
          state = state.copyWith(chatImageList: newList);
        }
      } else if (type == 'gallery') {
        final imageFileList = await ImagePicker().pickMultiImage();
        if (imageFileList != null) {
          for (var image in imageFileList) {
            final File _image;
            _image = File(image.path);
            final newList = [...state.chatImageList, _image];
            state = state.copyWith(chatImageList: newList);
          }
        }
      }

      Map<String, String> _imagesUrl = {};
      Map<String, String> _imagesPath = {};
      bool _hasImage = false;

      /*画像がある場合*/
      if (state.chatImageList.length != 0) {
        // _imagesUrl = await _uploadImage();
        Map<String, Map<String, String>> data = await _uploadImage();
        _imagesUrl = data['urlData']!;
        _imagesPath = data['pathData']!;
        /* _uploadImage()メソッドは下にある↓ */
        _hasImage = true;
      }

      /*画像がない場合*/
      /*上記で宣言した「_images = {}, hasImage = false」がFirestoreに保存される*/

      final String? currentUserId = _read(currentUserIdProvider);

      DocumentSnapshot userProfileDoc =
          await _userRepository.getUserProfile(userId: currentUserId!);
      User user = User.fromDoc(userProfileDoc);

      Message message = Message(
        convoId: convoId,
        content: null,
        imagesUrl: _imagesUrl,
        imagesPath: _imagesPath,
        hasImage: _hasImage,
        userFrom: user.name,
        userTo: peerUser.name,
        idFrom: currentUserId,
        idTo: peerUser.userId,
        timestamp: Timestamp.fromDate(DateTime.now()),
        read: false,
      );
      _messageRepository.sendMessage(
        currentUser: user,
        peerUser: peerUser,
        message: message,
      );
      /*chatImageListを初期化*/
      final List<File> resetList = [];
      state = state.copyWith(chatImageList: resetList);
    } catch (e) {
      print('ImagePickerエラー');
      print('chatImageの送信に失敗しました...');
    }
  }

  Future<Map<String, Map<String, String>>> _uploadImage() async {
    Map<String, String> _imagesUrl = {}; /*Storage格納後に返却されるURLを格納*/
    Map<String, String> _imagesPath = {}; /*Storage格納後に返却されるPathを格納*/
    Map<String, Map<String, String>> _imagesData = {};
    Map<int, File> _pickedImages = state.chatImageList.asMap();
    if (_pickedImages.isNotEmpty) {
      for (var _pickedImage in _pickedImages.entries) {
        final String? currentUserId = _read(currentUserIdProvider);
        // String _chatImageUrl = await Storage().uploadChatImage(
        //     userId: currentUserId!, imageFile: _pickedImage.value);
        // /* Mapの「key = value」の型 */
        // _images[_pickedImage.key.toString()] = _chatImageUrl;
        Map<String, String> data = await _storageService.uploadChatImage(
            userId: currentUserId!, imageFile: _pickedImage.value);
        String _chatImageUrl = data['url']!;
        String _chatImagePath = data['path']!;
        _imagesUrl[_pickedImage.key.toString()] = _chatImageUrl;
        _imagesPath[_pickedImage.key.toString()] = _chatImagePath;

        _imagesData = {
          'urlData': _imagesUrl,
          'pathData': _imagesPath,
        };
      }
    }
    return _imagesData;
  }

  Future<void> onSendMessage({
    required String content,
    required String convoId,
    required User peerUser,
  }) async {
    if (content.trim() != '') {
      content = content.trim();

      Map<String, String> _imagesUrl = {};
      Map<String, String> _imagesPath = {};
      bool _hasImage = false;

      final String? currentUserId = _read(currentUserIdProvider);

      /*ユーザー自身のプロフィール*/
      DocumentSnapshot userProfileDoc =
          await _userRepository.getUserProfile(userId: currentUserId!);
      User user = User.fromDoc(userProfileDoc);

      Message message = Message(
        convoId: convoId,
        content: content,
        imagesUrl: _imagesUrl,
        imagesPath: _imagesPath,
        hasImage: _hasImage,
        userFrom: user.name,
        userTo: peerUser.name,
        idFrom: currentUserId,
        idTo: peerUser.userId,
        timestamp: Timestamp.fromDate(DateTime.now()),
        read: false,
      );
      _messageRepository.sendMessage(
        currentUser: user,
        peerUser: peerUser,
        message: message,
      );
    }
  }
}
