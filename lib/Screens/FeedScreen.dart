import 'package:flutter/material.dart';
import 'package:twitter_clone/Firebase/Auth.dart';
import 'package:twitter_clone/Screens/Intro/WelcomeScreen.dart';

class FeedScreen extends StatefulWidget {
  final String currentUserId;
  FeedScreen({required this.currentUserId});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('FeedScreen'),
        actions: [
          ElevatedButton(
            child: Icon(Icons.logout),
            onPressed: () async {
              await Auth().logout;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.currentUserId),
          ],
        ),
      ),
    );
  }
}
