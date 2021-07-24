import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  final String currentUserId;

  NotificationsScreen({Key? key, required this.currentUserId})
      : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('NotificationsScreen'),
      ),
    );
  }
}
