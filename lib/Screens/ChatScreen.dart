import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Model/Message.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Widget/MessageContainer.dart';

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
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  FocusNode _focusNode = FocusNode();

  void onSendMessage({required String content}) async {
    if (content.trim() != '') {
      content = content.trim();

      /*ユーザー自身のプロフィール*/
      DocumentSnapshot userProfileDoc =
          await Firestore().getUserProfile(userId: widget.currentUserId);
      User user = User.fromDoc(userProfileDoc);

      Message message = Message(
        convoId: widget.convoId,
        content: content,
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

      listScrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
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
          StreamBuilder<QuerySnapshot>(
            stream: messagesRef
                .doc(widget.convoId)
                .collection('allMessages')
                .orderBy('timestamp', descending: false)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<DocumentSnapshot> listMessageSnap = snapshot.data!.docs;
              return ListView(
                physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                children: listMessageSnap.map((listMessage) {
                  Message message = Message.fromDoc(listMessage);
                  return MessageContainer(
                    currentUserId: widget.currentUserId,
                    peerUserId: widget.peerUser.userId,
                    peerUserProfileImage: widget.peerUser.profileImage,
                    message: message,
                  );
                }).toList(),
              );
            },
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
                padding:
                    EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.blue,
                    ),
                    Icon(
                      Icons.image_outlined,
                      color: Colors.blue,
                    ),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                        //autofocus: true,
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
                    GestureDetector(
                      onTap: () {
                        onSendMessage(content: message);
                        textEditingController.clear();
                        _focusNode.unfocus();
                      },
                      child: Icon(
                        Icons.send_rounded,
                        color: Colors.blue,
                      ),
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
