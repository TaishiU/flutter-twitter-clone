import 'package:flutter/material.dart';
import 'package:twitter_clone/Firebase/Auth.dart';

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
    );
  }
}
