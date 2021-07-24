import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class Storage {
  Future<String> uploadProfileImage(String userId, File imageFile) async {
    String uniqueImageId = Uuid().v4();
    final tempDirection = await getTemporaryDirectory();
    final path = tempDirection.path;
    File? compressedProfileImage =
        await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      '$path/img_$uniqueImageId.jpg',
      quality: 70,
    );
    print('プロフィール画像アップロード開始');
    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child('images/users/$userId/userProfile_$uniqueImageId.jpeg')
        .putFile(compressedProfileImage!);
    print('プロフィール画像アップロード完了');
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadProfileImageUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadProfileImageUrl;
  }

  Future<String> uploadCoverImage(String userId, File imageFile) async {
    String uniqueImageId = Uuid().v4();
    final tempDirection = await getTemporaryDirectory();
    final path = tempDirection.path;
    File? compressedCoverImage = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      '$path/img_$uniqueImageId.jpeg',
      quality: 70,
    );
    print('カバー画像アップロード開始');
    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child('images/users/$userId/userCover_$uniqueImageId.jpeg')
        .putFile(compressedCoverImage!);
    print('カバー画像アップロード完了');
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadCoverImageUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadCoverImageUrl;
  }
}
