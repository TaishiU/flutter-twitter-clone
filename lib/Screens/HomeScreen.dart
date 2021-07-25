import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Auth.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Screens/CreateTweetScreen.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserId;

  HomeScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('HomeScreen'),
        actions: [
          IconButton(
            onPressed: () {
              Auth().logout();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: Container(
        child: StreamBuilder(
          stream: usersRef.doc(widget.currentUserId).snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return SizedBox.shrink();
            }
            User user = User.fromDoc(snapshot.data);
            return FloatingActionButton(
              backgroundColor: TwitterColor,
              child: Image.asset(
                'assets/images/TweetLogo.png',
                fit: BoxFit.cover,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateTweetScreen(
                      currentUserId: widget.currentUserId,
                      user: user,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
