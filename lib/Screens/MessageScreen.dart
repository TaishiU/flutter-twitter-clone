import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Model/Message.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Widget/MessageContainer.dart';

class MessageScreen extends StatefulWidget {
  final String currentUserId;
  final String convoId;
  final User peerUser;

  const MessageScreen({
    Key? key,
    required this.currentUserId,
    required this.convoId,
    required this.peerUser,
  }) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late String message;
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  void onSendMessage({required String content}) async {
    if (content.trim() != '') {
      textEditingController.clear();
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
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue,
              backgroundImage: widget.peerUser.profileImage.isEmpty
                  ? null
                  : NetworkImage(widget.peerUser.profileImage),
            ),
            SizedBox(width: 10),
            Text(
              widget.peerUser.name,
              style: TextStyle(
                fontSize: 18,
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
                    message: message,
                    currentUserId: widget.currentUserId,
                    peerUserId: widget.peerUser.userId,
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
                    EdgeInsets.only(right: 20, left: 20, top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.75,
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
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.send_rounded,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        onSendMessage(content: message);
                      },
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
