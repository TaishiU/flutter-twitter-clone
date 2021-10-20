import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Screens/ProfileScreen.dart';

class SearchUserScreen extends StatefulWidget {
  final String currentUserId;

  const SearchUserScreen({Key? key, required this.currentUserId})
      : super(key: key);

  @override
  _SearchUserScreenState createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  String _searchName = '';
  TextEditingController _searchController = TextEditingController();
  Future<List<AlgoliaObjectSnapshot>>? _algoliaResult;

  Future<List<AlgoliaObjectSnapshot>> searchUser({required String name}) async {
    final Algolia algolia = Algolia.init(
      applicationId: dotenv.env['APPLICATIONID'] as String,
      apiKey: dotenv.env['SEARCHAPIKEY'] as String,
    );
    AlgoliaQuery algoliaQuery = algolia.instance
        .index(dotenv.env['ALGOLIAINDEXNAME'] as String)
        .query(name);
    AlgoliaQuerySnapshot algoliaQuerySnapshot = await algoliaQuery.getObjects();
    List<AlgoliaObjectSnapshot> _algoliaList = algoliaQuerySnapshot.hits;
    return _algoliaList;
  }

  Widget buildUserTile({required User user}) {
    return ListTile(
      leading: CircleAvatar(
        radius: 23,
        backgroundColor: TwitterColor,
        backgroundImage:
            user.profileImage.isEmpty ? null : NetworkImage(user.profileImage),
      ),
      title: Text(user.name),
      subtitle: Text('@${user.bio}'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              currentUserId: widget.currentUserId,
              visitedUserId: user.userId,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
        title: Container(
          height: 40,
          width: MediaQuery.of(context).size.width * 0.7,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextFormField(
            autofocus: true,
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.black,
                ),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _algoliaResult = null;
                  });
                },
              ),
            ),
            onChanged: (name) {
              if (name.isNotEmpty) {
                setState(() {
                  _searchName = name;
                  _algoliaResult = searchUser(name: name);
                });
              }
            },
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
      body: _algoliaResult == null
          ? StreamBuilder<QuerySnapshot>(
              stream: usersRef.limit(5).snapshots(),
              /*リミットは5件*/
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<DocumentSnapshot> userListSnap = snapshot.data!.docs;
                /*ユーザー自身のアバターは削除*/
                userListSnap.removeWhere((snapshot) =>
                    snapshot.get('userId') == widget.currentUserId);
                return ListView(
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  children: userListSnap.map((userSnap) {
                    User user = User.fromDoc(userSnap);
                    return buildUserTile(user: user);
                  }).toList(),
                );
              },
            )
          : FutureBuilder(
              future: _algoliaResult,
              builder: (BuildContext context,
                  AsyncSnapshot<List<AlgoliaObjectSnapshot>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data!.length == 0) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'There are no search results for "$_searchName".',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'There are no search results for the word you entered. You may have entered the wrong word, or your search settings may not display what you think is sensitive.',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                List<AlgoliaObjectSnapshot> _result = snapshot.data!;
                return ListView(
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  children: _result.map((snap) {
                    Map<String, dynamic> data = snap.data;
                    User user = User.fromAlgolia(data);
                    return buildUserTile(user: user);
                  }).toList(),
                );
              },
            ),
    );
  }
}
