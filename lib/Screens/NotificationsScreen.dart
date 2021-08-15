import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Firestore.dart';
import 'package:twitter_clone/Model/Activity.dart';
import 'package:twitter_clone/Model/User.dart';

class NotificationsScreen extends StatefulWidget {
  final String currentUserId;

  NotificationsScreen({Key? key, required this.currentUserId})
      : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Activity> _activities = [];

  setupActivities() async {
    List<Activity> activities =
        await Firestore().getActivity(currentUserid: widget.currentUserId);
    if (mounted) {
      setState(() {
        _activities = activities;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setupActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: TwitterColor,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return setupActivities();
        },
        child: Column(
          children: [
            Container(
              color: Colors.transparent,
              height: 7,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: _activities.length,
              itemBuilder: (BuildContext context, int index) {
                Activity activity = _activities[index];
                return FutureBuilder(
                  future: usersRef.doc(activity.fromUserId).get(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return SizedBox.shrink();
                    }
                    User user = User.fromDoc(snapshot.data);
                    return Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              activity.follow == true
                                  ? Icon(
                                      Icons.person,
                                      color: TwitterColor,
                                    )
                                  : Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: TwitterColor,
                                    backgroundImage: user.profileImage.isEmpty
                                        ? null
                                        : NetworkImage(user.profileImage),
                                  ),
                                  SizedBox(height: 5),
                                  activity.follow == true
                                      ? Row(
                                          children: [
                                            Text(
                                              '${user.name}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(' follows you.'),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Text(
                                              '${user.name}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(' likes your tweet!'),
                                          ],
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // ListTile(
                        //   leading: CircleAvatar(
                        //     backgroundColor: TwitterColor,
                        //     backgroundImage: user.profileImage.isEmpty
                        //         ? null
                        //         : NetworkImage(user.profileImage),
                        //   ),
                        //   title: activity.follow == true
                        //       ? Text('${user.name} follows you')
                        //       : Text('${user.name} likes your tweet!'),
                        // ),
                        Divider(),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        //child: ,
      ),
    );
  }
}
