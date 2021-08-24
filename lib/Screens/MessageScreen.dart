import 'package:flutter/material.dart';
import 'package:twitter_clone/Model/User.dart';

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
    );
  }
}
