import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/ListUser.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';

class ListUserContainer extends StatelessWidget {
  final String title;
  final String currentUserId;
  final List<DocumentSnapshot> listUserDocumentSnap;

  ListUserContainer({
    Key? key,
    required this.title,
    required this.currentUserId,
    required this.listUserDocumentSnap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
            color: TwitterColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            height: 7,
          ),
          ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: listUserDocumentSnap.map((listUserSnap) {
              ListUser listUser = ListUser.fromDoc(listUserSnap);
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        currentUserId: currentUserId,
                        visitedUserUserId: listUser.userId!,
                      ),
                    ),
                  );
                },
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 23,
                              backgroundColor: TwitterColor,
                              backgroundImage: listUser.profileImage.isEmpty
                                  ? null
                                  : NetworkImage(listUser.profileImage),
                            ),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  listUser.name,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '@${listUser.bio}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
