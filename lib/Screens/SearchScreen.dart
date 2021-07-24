import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final String currentUserId;

  SearchScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('SearchScreen'),
      ),
    );
  }
}
