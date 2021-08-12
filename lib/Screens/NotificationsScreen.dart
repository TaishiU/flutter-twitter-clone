import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  final String currentUserId;

  NotificationsScreen({Key? key, required this.currentUserId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('NotificationsScreen1'),
      ),
    );
  }
}
