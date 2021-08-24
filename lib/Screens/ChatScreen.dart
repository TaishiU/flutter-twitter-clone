import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Screens/SelectChatUser.dart';

class ChatScreen extends StatelessWidget {
  final String currentUserId;
  ChatScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          'Chat',
          style: TextStyle(
            color: TwitterColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SelectChatUser(currentUserId: currentUserId),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
