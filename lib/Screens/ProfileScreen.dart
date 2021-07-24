import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String currentUserId;
  final String visitedUserUserId;

  const ProfileScreen(
      {Key? key, required this.currentUserId, required this.visitedUserUserId})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('ProfileScreen'),
      ),
    );
  }
}
