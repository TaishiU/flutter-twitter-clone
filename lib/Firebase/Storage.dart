import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class Storage {
  Future<String> uploadProfileImage(
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

    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child('images/users/$userId/userProfile_$uniqueImageId.jpeg')
        .putFile(compressedProfileImage!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadProfileImageUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadProfileImageUrl;
  }

  Future<String> uploadCoverImage(
      {required String userId, required File imageFile}) async {
    String uniqueImageId = Uuid().v4();
    final tempDirection = await getTemporaryDirectory();
    final path = tempDirection.path;
    File? compressedCoverImage = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      '$path/img_$uniqueImageId.jpeg',
      quality: 70,
    );

    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child('images/users/$userId/userCover_$uniqueImageId.jpeg')
        .putFile(compressedCoverImage!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadCoverImageUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadCoverImageUrl;
  }

  Future<String> uploadTweetImage(
      {required String userId, required File imageFile}) async {
    String uniqueId = Uuid().v4();
    final tempDirection = await getTemporaryDirectory();
    final path = tempDirection.path;
    final compressedTweetImage = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      '$path/img_$uniqueId.jpeg',
      quality: 70,
    );

    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child('images/tweets/$userId/tweetImage_$uniqueId.jpeg')
        .putFile(compressedTweetImage!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadTweetImageUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadTweetImageUrl;
  }

  Future<String> uploadChatImage(
      {required String userId, required File imageFile}) async {
    String uniqueId = Uuid().v4();
    final tempDirection = await getTemporaryDirectory();
    final path = tempDirection.path;
    final compressedChatImage = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      '$path/img_$uniqueId.jpeg',
      quality: 70,
    );

    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child('images/chats/$userId/chatImage_$uniqueId.jpeg')
        .putFile(compressedChatImage!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadChatImageUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadChatImageUrl;
  }
}
