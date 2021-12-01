import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/LastMessage.dart';
import 'package:twitter_clone/Provider/ChatProvider.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Screens/SelectChatUserScreen.dart';
import 'package:twitter_clone/Widget/DrawerContainer.dart';
import 'package:twitter_clone/Widget/MessageUserTile.dart';

class MessageScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final String? currentUserId = useProvider(currentUserIdProvider);
    final asyncLastMessages = useProvider(lastMessagesStreamProvider);
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
                builder: (context) => SelectChatUserScreen(
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
                'Search account',
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
      body: asyncLastMessages.when(
        loading: () => Center(child: const CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (List<LastMessage> lastMessagesList) {
          if (lastMessagesList.length == 0) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Send or receive messages',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'You can send a message directly to Twitter users.\nSince you select the recipient and send it, it will not be published on the timeline.',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Write a message',
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
                            builder: (context) => SelectChatUserScreen(
                              currentUserId: currentUserId!,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: lastMessagesList.map((lastMessage) {
              return MessageUserTile(lastMessage: lastMessage);
            }).toList(),
          );
        },
      ),
      drawer: DrawerContainer(),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.mail_outline,
          size: 25,
        ),
        backgroundColor: TwitterColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectChatUserScreen(
                currentUserId: currentUserId!,
              ),
            ),
          );
        },
      ),
    );
  }
}
