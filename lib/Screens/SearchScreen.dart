import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Screens/SearchUserScreen.dart';
import 'package:twitter_clone/Screens/TweetDetailScreen.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchUserScreen(
                  currentUserId: widget.currentUserId,
                ),
              ),
            );
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width * 0.7,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Text(
                'Search...',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
            ),
            onPressed: () {},
          ),
          Container(
            width: 5,
          ),
        ],
      ),
      body: StreamBuilder(
        stream: usersRef.doc(widget.currentUserId).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          User user = User.fromDoc(snapshot.data);
          return StreamBuilder(
            stream: allTweetsRef
                .where('hasImage', isEqualTo: true) /*画像があるツイートを取得*/
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<DocumentSnapshot> allImageTweets = snapshot.data!.docs;
              if (allImageTweets.length == 0) {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      Text(
                        'There is no media...',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: allImageTweets.map((imageTweet) {
                  Tweet tweet = Tweet.fromDoc(imageTweet);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TweetDetailScreen(
                            currentUserId: widget.currentUserId,
                            tweet: tweet,
                            user: user,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        //borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage(
                            tweet.image,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
