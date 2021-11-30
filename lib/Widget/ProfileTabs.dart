import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/Tweet.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/TweetProvider.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Screens/CreateTweetScreen.dart';
import 'package:twitter_clone/Widget/TweetContainer.dart';

class ProfileTabs extends HookWidget {
  final User user;
  ProfileTabs({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? currentUserId = useProvider(currentUserIdProvider);
    final int _profileIndex = useProvider(profileIndexProvider);
    final _profileTweet = useProvider(profileTweetProvider(user));
    final _profileImageTweet = useProvider(profileImageTweetProvider(user));
    final _profileFavoriteTweet =
        useProvider(profileFavoriteTweetProvider(user));

    switch (_profileIndex) {
      case 0:
        return _profileTweet.when(
          loading: () => Center(child: const CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (List<Tweet> profileTweetList) {
            if (profileTweetList.length == 0) {
              return currentUserId == user.userId
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 30),
                            Text(
                              'You have\'t tweeted yet',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'If you tweet, it will be displayed here.',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 15),
                            ElevatedButton(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'Create Tweet',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: TwitterColor,
                                onPrimary: Colors.black,
                                shape: StadiumBorder(),
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
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 30),
                            Text(
                              'There are no tweets.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
            }
            return ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: profileTweetList.map((tweet) {
                return TweetContainer(
                  currentUserId: currentUserId!,
                  tweet: tweet,
                );
              }).toList(),
            );
          },
        );
        break;
      case 1:
        return _profileImageTweet.when(
          loading: () => Center(child: const CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (List<Tweet> profileImageTweetList) {
            if (profileImageTweetList.length == 0) {
              return currentUserId == user.userId
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 30),
                            Text(
                              'You haven\'t tweeted with an image yet',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'If you tweet with an image, it will be displayed here.',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 15),
                            ElevatedButton(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'Create Tweet',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: TwitterColor,
                                onPrimary: Colors.black,
                                shape: StadiumBorder(),
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
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 30),
                            Text(
                              'There are no tweets with an image.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
            }
            return ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: profileImageTweetList.map((tweet) {
                return TweetContainer(
                  currentUserId: currentUserId!,
                  tweet: tweet,
                );
              }).toList(),
            );
          },
        );
        break;
      case 2:
        return _profileFavoriteTweet.when(
          loading: () => Center(child: const CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (List<Tweet> profileFavoriteTweetList) {
            if (profileFavoriteTweetList.length == 0) {
              return currentUserId == user.userId
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 30),
                            Text(
                              'There are no tweets you\'ve liked yet.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'If you tap the heart of a tweet you like,\nit will be displayed here.',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 30),
                            Text(
                              'There are no tweets that\n${user.name} have liked yet.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
            }
            return ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: profileFavoriteTweetList.map((tweet) {
                return TweetContainer(
                  currentUserId: currentUserId!,
                  tweet: tweet,
                );
              }).toList(),
            );
          },
        );
        break;
      default:
        return Center(
          child: Text(
            'user profile tweets wrong',
            style: TextStyle(fontSize: 25),
          ),
        );
        break;
    }
  }
}
