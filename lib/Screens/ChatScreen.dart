import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Model/Message.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/ChatProvider.dart';
import 'package:twitter_clone/ViewModel/ChatNotifier.dart';
import 'package:twitter_clone/Widget/ChatContainer.dart';

class ChatScreen extends HookWidget {
  final User peerUser;

  ChatScreen({
    Key? key,
    required this.peerUser,
  }) : super(key: key);

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _message = useProvider(messageTextProvider).state;
    final convoId = useProvider(convoIdProvider);
    final asyncUserMessages = useProvider(userMessagesStreamProvider);
    FocusNode _focusNode = FocusNode();

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
              peerUser.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            Text(
              '@${peerUser.bio}',
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
            child: asyncUserMessages.when(
              loading: () => Center(child: const CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
              data: (query) {
                List<DocumentSnapshot> userMessagesList = query.docs;
                return Column(
                  children: [
                    Container(
                      height: 5,
                      color: Colors.transparent,
                    ),
                    ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: userMessagesList.map((userMessage) {
                        Message message = Message.fromDoc(userMessage);
                        return ChatContainer(
                          peerUserId: peerUser.userId,
                          peerUserProfileImage: peerUser.profileImageUrl,
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
                        context.read(chatNotifierProvider.notifier).handleImage(
                              type: 'camera',
                              convoId: convoId,
                              peerUser: peerUser,
                            );
                      },
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.blue,
                        size: 27,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read(chatNotifierProvider.notifier).handleImage(
                              type: 'gallery',
                              convoId: convoId,
                              peerUser: peerUser,
                            );
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
                          context.read(messageTextProvider).state = input;
                        },
                        focusNode: _focusNode,
                      ),
                    ),
                    textEditingController.text.length > 0
                        ? GestureDetector(
                            onTap: () {
                              context
                                  .read(chatNotifierProvider.notifier)
                                  .onSendMessage(
                                    content: _message,
                                    convoId: convoId,
                                    peerUser: peerUser,
                                  );
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
