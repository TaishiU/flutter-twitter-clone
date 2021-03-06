import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/Widget/SelectChatUserTile.dart';

class SelectChatUserScreen extends StatefulWidget {
  final String currentUserId;
  const SelectChatUserScreen({
    Key? key,
    required this.currentUserId,
  }) : super(key: key);

  @override
  _SelectChatUserScreenState createState() => _SelectChatUserScreenState();
}

class _SelectChatUserScreenState extends State<SelectChatUserScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
        leading: BackButton(color: Colors.black),
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
            onChanged: (String name) {
              if (name.isNotEmpty) {
                setState(() {
                  _searchName = name;
                  _algoliaResult = searchUser(name: name);
                });
              }
            },
          ),
        ),
      ),
      body: _algoliaResult == null
          ? Consumer(builder: (context, watch, child) {
              final asyncSearchUsers = watch(searchUsersStreamProvider);
              return asyncSearchUsers.when(
                loading: () => Center(child: const CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
                data: (List<User> userList) {
                  /*??????????????????????????????????????????*/
                  userList.removeWhere(
                      (user) => user.userId == widget.currentUserId);

                  return ListView(
                    physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    children: userList.map((peerUser) {
                      return SelectChatUserTile(peerUser: peerUser);
                    }).toList(),
                  );
                },
              );
            })
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
                    User peerUser = User.fromAlgolia(data);
                    return SelectChatUserTile(peerUser: peerUser);
                  }).toList(),
                );
              },
            ),
    );
  }
}
