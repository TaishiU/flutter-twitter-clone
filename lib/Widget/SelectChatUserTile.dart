import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/ChatProvider.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Repository/UserRepository.dart';
import 'package:twitter_clone/Screens/ChatScreen.dart';
import 'package:twitter_clone/Screens/Utils/HelperFunctions.dart';

class SelectChatUserTile extends HookWidget {
  final User peerUser;
  SelectChatUserTile({
    Key? key,
    required this.peerUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? currentUserId = useProvider(currentUserIdProvider);
    final UserRepository _userRepository = UserRepository();

    return ListTile(
      leading: CircleAvatar(
        radius: 23,
        backgroundColor: peerUser.profileImageUrl.isEmpty
            ? TwitterColor
            : Colors.transparent,
        backgroundImage: peerUser.profileImageUrl.isEmpty
            ? null
            : NetworkImage(peerUser.profileImageUrl),
      ),
      title: Text(peerUser.name),
      subtitle: Text('@${peerUser.bio}'),
      onTap: () async {
        /*ユーザー自身のプロフィール*/
        DocumentSnapshot userProfileDoc =
            await _userRepository.getUserProfile(userId: currentUserId!);
        User currentUser = User.fromDoc(userProfileDoc);
        /*会話Id（トークルームのId）を取得する*/
        String convoId = HelperFunctions.getConvoIDFromHash(
          currentUser: currentUser,
          peerUser: peerUser,
        );

        // convoId情報を更新
        context.read(convoIdProvider.notifier).update(convoId: convoId);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              peerUser: peerUser,
            ),
          ),
        );
      },
    );
  }
}
