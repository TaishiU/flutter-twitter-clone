import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Firebase/Storage.dart';
import 'package:twitter_clone/Model/Message.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Widget/ChatContainer.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String convoId;
  final User peerUser;

  const ChatScreen({
    Key? key,
    required this.currentUserId,
    required this.convoId,
    required this.peerUser,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String message;
  late String _imagePickedType;
  List<File>? _chatImageList = [];
  final TextEditingController textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  handleImage() async {
    try {
      if (_imagePickedType == 'camera') {
        final imageFile =
            await ImagePicker().pickImage(source: ImageSource.camera);
        if (imageFile != null) {
          _chatImageList!.add(File(imageFile.path));
        }
      } else if (_imagePickedType == 'gallery') {
        final imageFileList = await ImagePicker().pickMultiImage();
        if (imageFileList != null) {
          for (var image in imageFileList) {
            _chatImageList!.add(File(image.path));
          }
        }
      }

      Map<String, String> _images = {};
      bool _hasImage = false;

      /*画像がある場合*/
      if (_chatImageList!.length != 0) {
        _images = await _uploadImage();
        /* _uploadImage()メソッドは下にある↓ */
        _hasImage = true;
      }

      /*画像がない場合*/
      /*上記で宣言した「_images = {}, hasImage = false」がFirestoreに保存される*/

      DocumentSnapshot userProfileDoc =
          await Firestore().getUserProfile(userId: widget.currentUserId);
      User user = User.fromDoc(userProfileDoc);

      Message message = Message(
        convoId: widget.convoId,
        content: null,
        images: _images,
        hasImage: _hasImage,
        userFrom: user.name,
        userTo: widget.peerUser.name,
        idFrom: widget.currentUserId,
        idTo: widget.peerUser.userId,
        timestamp: Timestamp.fromDate(DateTime.now()),
        read: false,
      );
      Firestore().sendMessage(
        currentUser: user,
        peerUser: widget.peerUser,
        message: message,
      );
      /*リストを初期化*/
      _chatImageList = [];
    } catch (e) {
      print('ImagePickerエラー');
      print('chatImageの送信に失敗しました...');
    }
  }

  Future<Map<String, String>> _uploadImage() async {
    Map<String, String> _images = {}; /*Storage格納後に返却されるURLを格納*/
    Map<int, File> _pickedImages = _chatImageList!.asMap();
    if (_pickedImages.isNotEmpty) {
      for (var _pickedImage in _pickedImages.entries) {
        String _chatImageUrl = await Storage().uploadChatImage(
            userId: widget.currentUserId, imageFile: _pickedImage.value);
        /* Mapの「key = value」の型 */
        _images[_pickedImage.key.toString()] = _chatImageUrl;
      }
    }
    return _images;
  }

  void onSendMessage({required String content}) async {
    if (content.trim() != '') {
      content = content.trim();

      Map<String, String> _images = {};
      bool _hasImage = false;

      /*ユーザー自身のプロフィール*/
      DocumentSnapshot userProfileDoc =
          await Firestore().getUserProfile(userId: widget.currentUserId);
      User user = User.fromDoc(userProfileDoc);

      Message message = Message(
        convoId: widget.convoId,
        content: content,
        images: _images,
        hasImage: _hasImage,
        userFrom: user.name,
        userTo: widget.peerUser.name,
        idFrom: widget.currentUserId,
        idTo: widget.peerUser.userId,
        timestamp: Timestamp.fromDate(DateTime.now()),
        read: false,
      );
      Firestore().sendMessage(
        currentUser: user,
        peerUser: widget.peerUser,
        message: message,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: BackButton(color: Colors.black),
        title: Column(
          children: [
            Text(
              widget.peerUser.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            Text(
              '@${widget.peerUser.bio}',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: messagesRef
                  .doc(widget.convoId)
                  .collection('allMessages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<DocumentSnapshot> listMessageSnap = snapshot.data!.docs;
                return Column(
                  children: [
                    Container(
                      height: 5,
                      color: Colors.transparent,
                    ),
                    ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      //reverse: true,
                      children: listMessageSnap.map((listMessage) {
                        Message message = Message.fromDoc(listMessage);
                        return ChatContainer(
                          currentUserId: widget.currentUserId,
                          peerUserId: widget.peerUser.userId,
                          peerUserProfileImage: widget.peerUser.profileImage,
                          message: message,
                        );
                      }).toList(),
                    ),
                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   physics: NeverScrollableScrollPhysics(),
                    //   //reverse: true,
                    //   itemCount: listMessageSnap.length,
                    //   itemBuilder: (BuildContext context, int index) {
                    //     Message message =
                    //         Message.fromDoc(listMessageSnap[index]);
                    //     return ChatContainer(
                    //       currentUserId: widget.currentUserId,
                    //       peerUserId: widget.peerUser.userId,
                    //       peerUserProfileImage: widget.peerUser.profileImage,
                    //       message: message,
                    //     );
                    //   },
                    // ),
                    Container(
                      height: 70,
                      color: Colors.transparent,
                    ),
                  ],
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _imagePickedType = 'camera';
                        handleImage();
                      },
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.blue,
                        size: 27,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _imagePickedType = 'gallery';
                        handleImage();
                      },
                      child: Icon(
                        Icons.image_outlined,
                        color: Colors.blue,
                        size: 27,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.55,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                        controller: textEditingController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 12, bottom: 11),
                          border: InputBorder.none,
                        ),
                        onChanged: (input) {
                          setState(() {
                            message = input;
                          });
                        },
                        focusNode: _focusNode,
                      ),
                    ),
                    textEditingController.text.length > 0
                        ? GestureDetector(
                            onTap: () {
                              onSendMessage(content: message);
                              textEditingController.clear();
                              _focusNode.unfocus();
                            },
                            child: Icon(
                              Icons.send_rounded,
                              color: Colors.blue,
                            ),
                          )
                        : Icon(
                            Icons.send_rounded,
                            color: Colors.grey,
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
