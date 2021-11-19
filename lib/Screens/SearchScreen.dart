import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Provider/TweetProvider.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Screens/CreateTweetScreen.dart';
import 'package:twitter_clone/Screens/SearchUserScreen.dart';
import 'package:twitter_clone/Screens/TweetDetailScreen.dart';
import 'package:twitter_clone/Widget/DrawerContainer.dart';

class SearchScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final String? currentUserId = useProvider(currentUserIdProvider);
    final asyncAllImageTweets = useProvider(allImageTweetsStreamProvider);
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchUserScreen(
                  currentUserId: currentUserId!,
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
                'Search keyword',
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
      body: asyncAllImageTweets.when(
        loading: () => Center(child: const CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (query) {
          List<DocumentSnapshot> allImageTweets = query.docs;
          /* ユーザー自身のツイート画像は表示リストから削除 → removeWhere */
          allImageTweets.removeWhere(
              (imageTweet) => imageTweet.get('authorId') == currentUserId);

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
                        tweet: tweet,
                      ),
                    ),
                  );
                },
                child: tweet.imagesUrl.length == 1
                    ? Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              tweet.imagesUrl['0']!,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  tweet.imagesUrl['0']!,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Icon(
                              Icons.add_to_photos,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              );
            },
            staggeredTileBuilder: (index) => StaggeredTile.count(
                /*横の比率が2:1, 縦の比率が2:1*/
                (index % 7 == 0) ? 2 : 1,
                (index % 7 == 0) ? 2 : 1),
          );
        },
      ),
      drawer: DrawerContainer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: TwitterColor,
        child: Image.asset(
          'assets/images/TweetLogo.png',
          fit: BoxFit.cover,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTweetScreen(),
            ),
          );
        },
      ),
    );
  }
}
