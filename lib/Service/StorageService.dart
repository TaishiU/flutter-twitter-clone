import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final _storage = FirebaseStorage.instance;

  Future<Map<String, String>> uploadProfileImage(
      {required String userId, required File imageFile}) async {
    String uniqueImageId = Uuid().v4();
    final tempDirection = await getTemporaryDirectory();
    final path = tempDirection.path;
    File? compressedProfileImage =
        await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      '$path/img_$uniqueImageId.jpg',
      quality: 70,
    );

    UploadTask uploadTask = _storage
        .ref()
        .child('images/users/$userId/userProfile_$uniqueImageId.jpeg')
        .putFile(compressedProfileImage!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadProfileImageUrl = await taskSnapshot.ref.getDownloadURL();
    String downloadProfileImagePath = taskSnapshot.ref.fullPath;

    final Map<String, String> data = {
      'url': downloadProfileImageUrl,
      'path': downloadProfileImagePath,
    };
    return data;
  }

  Future<Map<String, String>> uploadCoverImage(
      {required String userId, required File imageFile}) async {
    String uniqueImageId = Uuid().v4();
    final tempDirection = await getTemporaryDirectory();
    final path = tempDirection.path;
    File? compressedCoverImage = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      '$path/img_$uniqueImageId.jpeg',
      quality: 70,
    );

    UploadTask uploadTask = _storage
        .ref()
        .child('images/users/$userId/userCover_$uniqueImageId.jpeg')
        .putFile(compressedCoverImage!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadCoverImageUrl = await taskSnapshot.ref.getDownloadURL();
    String downloadCoverImagePath = taskSnapshot.ref.fullPath;

    final Map<String, String> data = {
      'url': downloadCoverImageUrl,
      'path': downloadCoverImagePath,
    };
    return data;
  }

  Future<Map<String, String>> uploadTweetImage(
      {required String userId, required File imageFile}) async {
    String uniqueId = Uuid().v4();
    final tempDirection = await getTemporaryDirectory();
    final path = tempDirection.path;
    final compressedTweetImage = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      '$path/img_$uniqueId.jpeg',
      quality: 70,
    );

    UploadTask uploadTask = _storage
        .ref()
        .child('images/tweets/$userId/tweetImage_$uniqueId.jpeg')
        .putFile(compressedTweetImage!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadTweetImageUrl = await taskSnapshot.ref.getDownloadURL();
    String downloadTweetImagePath = taskSnapshot.ref.fullPath;

    final Map<String, String> data = {
      'url': downloadTweetImageUrl,
      'path': downloadTweetImagePath,
    };
    return data;
  }

  Future<Map<String, String>> uploadChatImage(
      {required String userId, required File imageFile}) async {
    String uniqueId = Uuid().v4();
    final tempDirection = await getTemporaryDirectory();
    final path = tempDirection.path;
    final compressedChatImage = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      '$path/img_$uniqueId.jpeg',
      quality: 70,
    );

    UploadTask uploadTask = _storage
        .ref()
        .child('images/chats/$userId/chatImage_$uniqueId.jpeg')
        .putFile(compressedChatImage!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadChatImageUrl = await taskSnapshot.ref.getDownloadURL();
    String downloadChatImagePath = taskSnapshot.ref.fullPath;

    final Map<String, String> data = {
      'url': downloadChatImageUrl,
      'path': downloadChatImagePath,
    };
    return data;
  }

  Future<void> deleteTweetImage({
    required Map<String, String> imagesPath,
  }) async {
    /*拡張for文でvalueの値を取得*/
    /*message.imagesPath → Map<String, String>*/
    for (var path in imagesPath.values) {
      await _storage.ref().child(path).delete();
    }
  }

  Future<void> deleteMessageForImage({
    required Map<String, String> imagesPath,
  }) async {
    /*拡張for文でvalueの値を取得*/
    /*message.imagesPath → Map<String, String>*/
    for (var path in imagesPath.values) {
      await _storage.ref().child(path).delete();
    }
  }
}
