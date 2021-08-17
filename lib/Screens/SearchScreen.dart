import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          SvgPicture.asset(
            'assets/images/SettingLogo.svg',
            width: 23,
            height: 23,
          ),
          Container(
            width: 15,
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
              /* ユーザー自身のツイート画像は表示リストから削除 → removeWhere */
              allImageTweets.removeWhere(
                  (imageTweet) => imageTweet.get('authorId') == user.userId);

              if (allImageTweets.length == 0) {
                return Container();
              }
              return StaggeredGridView.countBuilder(
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemCount: allImageTweets.length,
                itemBuilder: (context, index) {
                  Tweet tweet = Tweet.fromDoc(allImageTweets[index]);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TweetDetailScreen(
                            currentUserId: widget.currentUserId,
                            tweet: tweet,
                            //user: user,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            tweet.image,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
                staggeredTileBuilder: (index) => StaggeredTile.count(
                    /*横の比率が2:1, 縦の比率が2:1*/
                    (index % 7 == 0) ? 2 : 1,
                    (index % 7 == 0) ? 2 : 1),
              );
            },
          );
        },
      ),
    );
  }
}
