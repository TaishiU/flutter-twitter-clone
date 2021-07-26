import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

const Color TwitterColor = Color(0xff00acee);
final _firestore = FirebaseFirestore.instance;
final usersRef = _firestore.collection('users');
final tweetRef = _firestore.collection('tweets');
final allTweetsRef = _firestore.collection('allTweets');
