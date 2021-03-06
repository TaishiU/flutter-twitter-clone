import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';

class SearchUserTile extends HookWidget {
  final User user;
  SearchUserTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _visitedUserIdNotifier = context.read(visitedUserIdProvider.notifier);

    return ListTile(
      leading: CircleAvatar(
        radius: 23,
        backgroundColor:
            user.profileImageUrl.isEmpty ? TwitterColor : Colors.transparent,
        backgroundImage: user.profileImageUrl.isEmpty
            ? null
            : CachedNetworkImageProvider(user.profileImageUrl),
      ),
      title: Text(user.name),
      subtitle: Text('@${user.bio}'),
      onTap: () {
        /*visitedUserId情報を更新*/
        _visitedUserIdNotifier.update(userId: user.userId);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(),
          ),
        );
      },
    );
  }
}
