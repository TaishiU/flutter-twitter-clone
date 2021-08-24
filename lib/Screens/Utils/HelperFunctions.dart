import 'package:twitter_clone/Model/User.dart';

class HelperFunctions {
  static String getConvoIDFromHash({
    required User currentUser,
    required User peerUser,
  }) {
    return currentUser.userId.hashCode <= peerUser.userId.hashCode
        ? currentUser.name + '_' + peerUser.name
        : peerUser.name + '_' + currentUser.name;
  }
}
