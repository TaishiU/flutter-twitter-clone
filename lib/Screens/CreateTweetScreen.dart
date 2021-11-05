import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Model/User.dart';
import 'package:twitter_clone/Provider/TweetProvider.dart';
import 'package:twitter_clone/Provider/UserProvider.dart';
import 'package:twitter_clone/ViewModel/CreateTweetNotifier.dart';

// class CreateTweetScreen extends StatefulWidget {
//   final String currentUserId;
//
//   CreateTweetScreen({Key? key, required this.currentUserId}) : super(key: key);
//
//   @override
//   _CreateTweetScreenState createState() => _CreateTweetScreenState();
// }
//
// class _CreateTweetScreenState extends State<CreateTweetScreen> {
//   late String _tweetText;
//   List<File> _tweetImageList = [];
//   bool _isLoading = false;
//   final _formKey = GlobalKey<FormState>();
//
//   handleImageFromGallery() async {
//     try {
//       final imageFile =
//           await ImagePicker().pickImage(source: ImageSource.gallery);
//       if (imageFile != null) {
//         setState(() {
//           _tweetImageList.add(File(imageFile.path));
//         });
//       }
//     } catch (e) {
//       print('ImagePickerエラー');
//     }
//   }
//
//   removeImageFromList({required File image}) {
//     _tweetImageList.removeWhere((removeImage) => removeImage == image);
//     /*_tweetImageListの画像の中から削除ボタンを押された画像を削除*/
//     setState(() {
//       _tweetImageList = _tweetImageList;
//       /*削除されていない画像が_tweetImageListに再びセットされる*/
//     });
//   }
//
//   handleTweet() async {
//     _formKey.currentState!.save();
//     if (_formKey.currentState!.validate() && !_isLoading) {
//       setState(() {
//         _isLoading = true;
//       });
//       Map<String, String> _images = {};
//       bool hasImage = false;
//
//       /*画像がある場合*/
//       if (_tweetImageList.length != 0) {
//         _images = await _uploadImage();
//         /* _uploadImage()メソッドは下にある↓ */
//         hasImage = true;
//       }
//
//       /*画像がない場合*/
//       /*上記で宣言した「_images = {}, hasImage = false」がFirestoreに保存される*/
//
//       DocumentSnapshot userProfileDoc =
//           await Firestore().getUserProfile(userId: widget.currentUserId);
//       User user = User.fromDoc(userProfileDoc);
//
//       Tweet tweet = Tweet(
//         authorName: user.name,
//         authorId: user.userId,
//         authorBio: user.bio,
//         authorProfileImage: user.profileImage,
//         text: _tweetText,
//         images: _images,
//         hasImage: hasImage,
//         timestamp: Timestamp.fromDate(DateTime.now()),
//         likes: 0,
//         reTweets: 0,
//       );
//       Firestore().createTweet(tweet: tweet);
//       Navigator.of(context).pop();
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<Map<String, String>> _uploadImage() async {
//     Map<String, String> _images = {}; /*Storage格納後に返却されるURLを格納*/
//     Map<int, File> _pickedImages = _tweetImageList.asMap();
//     if (_pickedImages.isNotEmpty) {
//       for (var _pickedImage in _pickedImages.entries) {
//         String _tweetImageUrl = await Storage().uploadTweetImage(
//             userId: widget.currentUserId, imageFile: _pickedImage.value);
//         /* Mapの「key = value」の型 */
//         _images[_pickedImage.key.toString()] = _tweetImageUrl;
//       }
//     }
//     return _images;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: true,
//         elevation: 0.5,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: Icon(
//             Icons.clear,
//             size: 28,
//             color: Colors.black,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         actions: [
//           Container(
//             margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//             child: ElevatedButton(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 child: Text(
//                   'Tweet',
//                   style: TextStyle(
//                     fontSize: 17,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 primary: TwitterColor,
//                 onPrimary: Colors.black,
//                 shape: StadiumBorder(),
//               ),
//               onPressed: () {
//                 handleTweet();
//               },
//             ),
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         /*キーボード表示時のRenderFlexOverFlowedエラーの解消用にSingleChildScrollViewを使う*/
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               SizedBox(height: 20),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Column(
//                       children: [
//                         SizedBox(height: 5),
//                         StreamBuilder(
//                           stream:
//                               usersRef.doc(widget.currentUserId).snapshots(),
//                           builder:
//                               (BuildContext context, AsyncSnapshot snapshot) {
//                             if (!snapshot.hasData) {
//                               return CircleAvatar(
//                                 radius: 20,
//                                 backgroundColor: TwitterColor,
//                               );
//                             }
//                             User user = User.fromDoc(snapshot.data);
//                             return CircleAvatar(
//                               radius: 20,
//                               backgroundColor: TwitterColor,
//                               backgroundImage: user.profileImage.isEmpty
//                                   ? null
//                                   : NetworkImage(user.profileImage),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                     Container(
//                       width: MediaQuery.of(context).size.width * 0.8,
//                       child: TextFormField(
//                         autofocus: true,
//                         keyboardType: TextInputType.multiline,
//                         maxLines: null,
//                         /* keyboardTypeとmaxLinesを上記のように指定することでテキスト折り返しが可能になる */
//                         maxLength: 140,
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           hintText: 'What\'s happening? ',
//                         ),
//                         validator: (input) => input!.trim().length < 1
//                             ? 'Please enter your Tweet'
//                             : null,
//                         onChanged: (value) {
//                           _tweetText = value;
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 10),
//               _tweetImageList.length > 3
//                   ? SizedBox.shrink()
//                   : GestureDetector(
//                       onTap: () {
//                         handleImageFromGallery();
//                       },
//                       child: Container(
//                         height: 70,
//                         width: 70,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: Colors.white,
//                           border: Border.all(
//                             color: TwitterColor,
//                             width: 2,
//                           ),
//                         ),
//                         child: Icon(
//                           Icons.camera_alt,
//                           size: 50,
//                           color: TwitterColor,
//                         ),
//                       ),
//                     ),
//               SizedBox(height: 20),
//               _tweetImageList.length == 0
//                   ? SizedBox.shrink()
//                   : Container(
//                       height: 200,
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         scrollDirection: Axis.horizontal,
//                         itemCount: _tweetImageList.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           return Stack(
//                             children: [
//                               Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 4),
//                                 width: MediaQuery.of(context).size.width * 0.8,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(20),
//                                   image: DecorationImage(
//                                     image: FileImage(_tweetImageList[index]),
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 top: 10,
//                                 right: 15,
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     removeImageFromList(
//                                         image: _tweetImageList[index]);
//                                   },
//                                   child: Container(
//                                     width: 35,
//                                     height: 35,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Colors.black45,
//                                     ),
//                                     child: Icon(
//                                       Icons.clear_rounded,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//               SizedBox(height: 50),
//               _isLoading ? CircularProgressIndicator() : SizedBox.shrink(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class CreateTweetScreen extends HookWidget {
  CreateTweetScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String? currentUserId = useProvider(currentUserIdProvider);
    final _tweetText = useProvider(tweetTextProvider).state;
    final createTweetState = useProvider(createTweetProvider);
    final _tweetImageList = createTweetState.tweetImageList;
    final _isLoading = createTweetState.isLoading;

    // List<File> _tweetImageList = [];
    // bool _isLoading = false;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            size: 28,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: textEditingController.text.length >= 1
                ? ElevatedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Tweet',
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
                    onPressed: () async {
                      final isFalse = await context
                          .read(createTweetProvider.notifier)
                          .handleTweet(
                            currentUserId: currentUserId,
                            tweetText: _tweetText,
                          );

                      //Navigator.of(context).pop();

                      /*falseが帰ってきたら前のページに戻る*/
                      if (isFalse == false) {
                        Navigator.of(context).pop();
                        //TODO ボトムシートを出す

                      } else {
                        print('create tweet error...');
                        print('isFalse: $isFalse');
                      }
                    },
                  )
                : ElevatedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Tweet',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlue.shade200,
                      onPrimary: Colors.black,
                      shape: StadiumBorder(),
                    ),
                    onPressed: () {
                      print('テキストが入力されていません...');
                    },
                  ),
          )
        ],
      ),
      body: SingleChildScrollView(
        /*キーボード表示時のRenderFlexOverFlowedエラーの解消用にSingleChildScrollViewを使う*/
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 5),
                        StreamBuilder(
                          stream: usersRef.doc(currentUserId).snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return CircleAvatar(
                                radius: 20,
                                backgroundColor: TwitterColor,
                              );
                            }
                            User user = User.fromDoc(snapshot.data);
                            return CircleAvatar(
                              radius: 20,
                              backgroundColor: TwitterColor,
                              backgroundImage: user.profileImage.isEmpty
                                  ? null
                                  : NetworkImage(user.profileImage),
                            );
                          },
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        autofocus: true,
                        controller: textEditingController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        /* keyboardTypeとmaxLinesを上記のように指定することでテキスト折り返しが可能になる */
                        maxLength: 140,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'What\'s happening? ',
                        ),
                        validator: (input) => input!.trim().length < 1
                            ? 'Please enter your Tweet'
                            : null,
                        onChanged: (value) {
                          context.read(tweetTextProvider).state = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              _tweetImageList.length > 3
                  ? SizedBox.shrink()
                  : GestureDetector(
                      onTap: () {
                        context
                            .read(createTweetProvider.notifier)
                            .handleImageFromGallery();
                      },
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(
                            color: TwitterColor,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 50,
                          color: TwitterColor,
                        ),
                      ),
                    ),
              SizedBox(height: 20),
              _tweetImageList.length == 0
                  ? SizedBox.shrink()
                  : Container(
                      height: 200,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: _tweetImageList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                width: MediaQuery.of(context).size.width * 0.8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: FileImage(_tweetImageList[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 15,
                                child: GestureDetector(
                                  onTap: () {
                                    context
                                        .read(createTweetProvider.notifier)
                                        .removeImageFromList(
                                            removeImage:
                                                _tweetImageList[index]);
                                  },
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black45,
                                    ),
                                    child: Icon(
                                      Icons.clear_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
              SizedBox(height: 50),
              Container(
                height: 100,
                width: 200,
                child: ElevatedButton(
                  child: Text(
                    _isLoading == true ? 'ture' : 'false',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: _isLoading == true ? Colors.red : TwitterColor,
                    onPrimary: Colors.black,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {},
                ),
              ),
              SizedBox(height: 20),
              _isLoading ? CircularProgressIndicator() : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
