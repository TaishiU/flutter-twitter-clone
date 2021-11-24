# Hello world👋   ![Twitter URL](https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Ftwitter.com%2Fthealphamerc)

Welcome to the Twitter Clone project with Flutter, Firebase and algolia.<br>

![4FA73133-96C0-47A7-85BB-451D2658C326_1_201_a](https://user-images.githubusercontent.com/73986840/142754894-a635457f-8cc9-4d24-839c-1870c714fa8e.jpeg)

## 💥 Features
- Registration and Login
- Update user profile
- Follow and Unfollow user
- View following and followers
- Direct Message
- Create tweet with text and images (up to 4)
- Likes tweet
- Comment on tweet
- Share tweet
- Tweet detail
- Notification (follow, likes and comment)
- Chat with other users
- Send some images as chat (up to 4)
- etc.

## Architecture (Update 2021/11/19)
- Riverpod
- Flutter Hooks
- StateNotifier
- freezed

![A0DA5EE3-E9B4-4EE3-A4EC-B06EBCD42639_1_105_c](https://user-images.githubusercontent.com/73986840/142591192-835202f0-edac-4fd4-8564-f889b643c386.jpeg)

Reference: https://github.com/wasabeef/flutter-architecture-blueprints

## 📙 Directory Structure (Update 2021/11/19)

![2DDB9E04-75C9-4944-B3C6-6318720EEEAA_1_105_c](https://user-images.githubusercontent.com/73986840/142754183-56c84175-3082-44de-8e9c-4665386a7aef.jpeg)

<details>
     <summary> [Detail] Click to expand </summary>

```
|-- lib
|   |-- Constants
|   |   '-- Constants.dart
|   |-- Model
|   |   |-- Activity.dart
|   |   |-- Comment.dart
|   |   |-- LastMessage.dart
|   |   |-- Likes.dart
|   |   |-- ListUser.dart
|   |   |-- Message.dart
|   |   |-- Tweet.dart
|   |   '-- User.dart
|   |-- Provider
|   |   |-- ActivityProvider.dart
|   |   |-- AuthProvider.dart
|   |   |-- ChatProvider.dart
|   |   |-- TweetProvider.dart
|   |   '-- UserProvider.dart
|   |-- Repository
|   |   |-- ActivityRepository.dart
|   |   |-- MessageRepository.dart
|   |   |-- TweetRepository.dart
|   |   '-- UserRepository.dart
|   |-- Screens
|   |   |-- Intro
|   |   |   |-- ForgetPasswordScreen.dart
|   |   |   |-- LoginScreen.dart
|   |   |   |-- RegistrationScreen.dart
|   |   |   '-- WelcomeScreen.dart
|   |   |-- Utils
|   |   |   '-- HelperFunctions.dart
|   |   |-- ChatScreen.dart
|   |   |-- CreateTweetScreen.dart
|   |   |-- EditProfileScreen.dart
|   |   |-- FeedScreen.dart
|   |   |-- HomeScreen.dart
|   |   |-- MessageScreen.dart
|   |   |-- NotificationsScreen.dart
|   |   |-- ProfileScreen.dart
|   |   |-- SearchScreen.dart
|   |   |-- SearchUserScreen.dart
|   |   |-- SelectChatUserScreen.dart
|   |   '-- TweetDetailScreen.dart
|   |-- Service
|   |   |-- AuthService.dart
|   |   |-- DynamicLinkService.dart
|   |   '-- StorageService.dart
|   |-- State
|   |   |-- ChatState.dart
|   |   |-- ChatState.freezed.dart
|   |   |-- CreateTweetState.dart
|   |   |-- CreateTweetState.freezed.dart
|   |   |-- EditProfileState.dart
|   |   |-- EditProfileState.freezed.dart
|   |   |-- FavoriteState.dart
|   |   |-- FavoriteState.freezed.dart
|   |   |-- FcmTokenState.dart
|   |   |-- FcmTokenState.freezed.dart
|   |   |-- IsFollowingState.dart
|   |   |-- IsFollowingState.freezed.dart
|   |   |-- IsLikedState.dart
|   |   |-- IsLikedState.freezed.dart
|   |-- ViewModel
|   |   |-- ChatNotifier.dart
|   |   |-- CreateTweetNotifier.dart
|   |   '-- EditProfileNotifier.dart
|   |   |-- FavoriteNotifier.dart
|   |   |-- FcmTokenNotifier.dart
|   |   |-- IsFollowingNotifier.dart
|   |   |-- IsLikedNotifier.dart
|   |   |-- TweetCommentNotifier.dart
|   |-- Widget
|   |   |-- ChatContainer.dart
|   |   |-- ChatImage.dart
|   |   |-- CommentContainer.dart
|   |   |-- CommentUserContainer.dart
|   |   |-- DrawerContainer.dart
|   |   |-- LikesUserContainer.dart
|   |   |-- ListUserContainer.dart
|   |   |-- MessageUserTile.dart
|   |   |-- ProfileImageView.dart
|   |   |-- ProfileTabs.dart
|   |   |-- RoundedButton.dart
|   |   |-- SearchUserTile.dart
|   |   |-- SelectChatUserTile.dart
|   |   |-- TweetContainer.dart
|   |   |-- TweetImage.dart
|   |   '-- TweetImageView.dart
|   |-- main.dart

```

</details>


## 📸 All Screens

Welcome | Registration | Login | Forget Password
:---:|:---:|:---:|:---:
![CCA0DB18-A3CD-4B0C-BE51-BBC7F6EB545D](https://user-images.githubusercontent.com/73986840/133958559-afe92cae-1f38-45fb-87bf-b9743dedc04d.png) | ![C6DC9E72-4F86-46BE-BFC8-C2928F0E9BD7](https://user-images.githubusercontent.com/73986840/133958922-debee22c-eaf7-422d-b31d-530f5632c0ab.png) | ![F7AE119E-6064-474F-B9EA-446A6E724F22](https://user-images.githubusercontent.com/73986840/133958930-2745408e-f08c-48d4-b1b0-2cea757fc37e.png) | ![4E6F4133-92AD-4159-87D2-62EEF88FF8BF](https://user-images.githubusercontent.com/73986840/133958942-66fe771c-0eef-464a-898b-875df77820c1.png) |

Home | Drawer | Create Tweet | Tweet
:---:|:---:|:---:|:---:
![578C439C-8FF0-4392-A8F2-B2E16AD26E3D](https://user-images.githubusercontent.com/73986840/133961730-3d49c2ac-8527-421b-b574-5355b95a3b17.png) | ![E9D6E53D-4A3F-4923-9DB6-A7811CF1B81C](https://user-images.githubusercontent.com/73986840/133961763-31a972dc-5cac-49b0-a362-febc2ad80571.png) | ![66E25EDA-1D77-44E0-A245-E8EE1006252E](https://user-images.githubusercontent.com/73986840/133961782-24cbbee9-c149-444e-998e-51c0145c97de.png) | ![0CE0E8E4-2B30-4C70-9E18-33540984927C](https://user-images.githubusercontent.com/73986840/133961827-dbaa6c21-8e2b-4214-83f6-4422f1c13beb.png) |

Tweet Detail | Liked by | Commented by | Comment for Tweet
:---:|:---:|:---:|:---:
![E49EFF62-E935-4263-AE13-BB342F5D63E8](https://user-images.githubusercontent.com/73986840/133962439-bfe20f36-6e8c-4d3c-8848-1985781ad80f.png) | ![5E371DB2-85E6-49F9-8E27-5C610DC0F5B6](https://user-images.githubusercontent.com/73986840/133962871-6a1a38ab-3ce3-4b6a-9cdd-1414b523fd48.png) | ![21B001D6-AA6A-42DD-BC40-B7A831261457_1_105_c](https://user-images.githubusercontent.com/73986840/133963067-011e6b45-e4c0-4adf-82fa-99b578c2e6d4.jpeg) | ![448E6E00-790F-4D80-9E7E-90D1658CBFB4](https://user-images.githubusercontent.com/73986840/133962482-87b86541-a0df-4d3e-bfd3-be880705a9b3.png) |

Profile | Profile | Profile | DM
:---:|:---:|:---:|:---:
![C703DC08-BA31-4FEF-BDB6-ECCE800E67E9_1_105_c](https://user-images.githubusercontent.com/73986840/133965810-989ac3c2-318a-43ed-b541-4726544490de.jpeg) | ![A5F8F59B-0671-4244-8217-6E7C9D56B24E](https://user-images.githubusercontent.com/73986840/133965933-046f2ae0-db14-4be9-9c59-9db1d7030b6e.png) | ![FDD0B3B3-32D4-44FD-A710-4DCCC2047965](https://user-images.githubusercontent.com/73986840/133965980-393983de-69ff-4609-82a1-a0edb70b8ca9.png) | ![A522B746-6385-404D-9239-4EC2E1ADBA78_1_105_c](https://user-images.githubusercontent.com/73986840/133966081-1bce7136-8dc8-48c9-9b1f-26602e26c6e2.jpeg) |

Options | Following | Followers | Edit Profile
:---:|:---:|:---:|:---:
![DEE90F64-32FD-4E65-82A2-29133FCE32F9_1_105_c](https://user-images.githubusercontent.com/73986840/133966896-5052a7a9-84ad-4abf-88a3-4497baf748a7.jpeg) | ![FCD6AEC7-5161-4A07-BFDF-83F8C07C0686_1_105_c](https://user-images.githubusercontent.com/73986840/133967022-cee50e9d-2fef-438d-a38f-e6ef460d1984.jpeg) | ![05BCC938-45A5-4949-8D2A-179F1AE3AFDA](https://user-images.githubusercontent.com/73986840/133967278-6d5c8217-ff82-4dee-b751-105d409e0db0.png) | ![295A7E57-D1D8-478E-9024-41DB76D0A7EF_1_105_c](https://user-images.githubusercontent.com/73986840/133967355-ddbf9ffa-c7dc-4c20-a9ea-7812d68a9757.jpeg) |

Tweet | Media | Likes | Create Tweet
:---:|:---:|:---:|:---:
![69770E34-6F6A-4EE5-B74F-3C0A04B978DD_1_105_c](https://user-images.githubusercontent.com/73986840/133968322-fb88bd95-9f81-4a9a-9e8c-8f2650edd2cb.jpeg) | ![4FC7A931-1F2B-44DB-89B9-EB6EDC9A77A3](https://user-images.githubusercontent.com/73986840/133968360-98fbd462-2143-4977-8551-2c5f9eb6e8af.png) |![A72F03F8-DD6F-446C-9D16-6EDA35C8097D_1_105_c](https://user-images.githubusercontent.com/73986840/133968483-c37975c2-6f52-452a-8a5f-94c5f67b5e7a.jpeg)| ![66E25EDA-1D77-44E0-A245-E8EE1006252E](https://user-images.githubusercontent.com/73986840/133961782-24cbbee9-c149-444e-998e-51c0145c97de.png) |

Search | To Detail | Search User | To Profile
:---:|:---:|:---:|:---:
![8A595E8F-A569-4310-8C67-27F4BD786B6E_1_105_c](https://user-images.githubusercontent.com/73986840/133972616-ebcb46f7-8eae-45af-bdac-7e2154677a59.jpeg) | ![B1E38929-9B4F-431E-BFD3-DF353083FD50](https://user-images.githubusercontent.com/73986840/133972694-1b230f67-bf81-4307-a7a2-9bfc10ee5fd1.png) | ![5C3ED4C5-9162-4AC0-B98A-3488B67B0D7D](https://user-images.githubusercontent.com/73986840/133972740-db7d1fdb-869c-4a00-85e9-ec16b5050539.png) | ![43B35F75-FBFE-4A6A-84A5-F6B1D3C537A9_1_105_c](https://user-images.githubusercontent.com/73986840/134099367-9c09b77a-48e3-4b68-a88a-cea5894d0a13.jpeg) |

Notification | To Detail | Drawer | Create Tweet
:---:|:---:|:---:|:---:
![F349E373-718D-4B7C-B07B-6EF52CEE3C0B_1_105_c](https://user-images.githubusercontent.com/73986840/133974011-6b20ae51-a98a-4d55-82fe-6e5ea9228b4f.jpeg) | ![82982B53-9F4A-4C7E-9A61-FD2F70FEF3BD](https://user-images.githubusercontent.com/73986840/133974249-2dc5ef79-878c-44b2-ba42-922abb425319.png) | ![01293CFE-E678-432E-812E-C9B9C689E8D2](https://user-images.githubusercontent.com/73986840/134100694-ab7e61ad-3d00-4290-bbaf-ee3d0a15b012.png) | ![1CFDE9C4-887E-4A9A-BCD0-2DE3630479E7_1_105_c](https://user-images.githubusercontent.com/73986840/134100746-fb5a358b-22aa-4dc9-900a-7fe4018c1afd.jpeg) |

Message | Select Chat User | Chat | Delete Message
:---:|:---:|:---:|:---:
![21648FBE-B657-4455-9EFA-2946F8E9F215](https://user-images.githubusercontent.com/73986840/143163056-aff38749-c732-4cdc-bb0f-60cfc8766582.png) | ![5C3ED4C5-9162-4AC0-B98A-3488B67B0D7D](https://user-images.githubusercontent.com/73986840/133972740-db7d1fdb-869c-4a00-85e9-ec16b5050539.png) | ![9902C158-7DC3-440E-8A5F-D47C0C2A9CDB_1_105_c](https://user-images.githubusercontent.com/73986840/142754244-2000fcac-d29d-4e44-8d7b-20df29dc0bb0.jpeg) | ![BB917B77-B2DC-4115-AA0F-A76609E566A5](https://user-images.githubusercontent.com/73986840/142753366-f16d4ea1-561e-4a61-ba69-8885dee4ba04.png) |


## 🔥 Firebase products
- Authentication
- Cloud Firestore
- Storage
- Functions
- Dynamic Links
- Messaging (Update 2021/11/19)




## ☘️ Dependencies
- Firebase
   - [firebase_core](https://pub.dev/packages/firebase_core)
   - [firebase_auth](https://pub.dev/packages/firebase_auth)
   - [cloud_firestore](https://pub.dev/packages/cloud_firestore)
   - [firebase_storage](https://pub.dev/packages/firebase_storage)
   - [cloud_functions](https://pub.dev/packages/cloud_functions)
   - [firebase_dynamic_links](https://pub.dev/packages/firebase_dynamic_links)
   - [firebase_messaging](https://pub.dev/packages/firebase_messaging)
   - [firebase_analytics](https://pub.dev/packages/firebase_analytics)
- Tweet related
   - [image_picker](https://pub.dev/packages/image_picker)
   - [flutter_image_compress](https://pub.dev/packages/flutter_image_compress)
   - [path_provider](https://pub.dev/packages/path_provider)
   - [uuid](https://pub.dev/packages/uuid)
   - [flutter_staggered_grid_view](https://pub.dev/packages/flutter_staggered_grid_view)
   - [photo_view](https://pub.dev/packages/photo_view)
- FCM related
   - [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- Algolia
   - [algolia](https://pub.dev/packages/algolia)
- Others
   - [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)
   - [flutter_native_splash](https://pub.dev/packages/flutter_native_splash)
   - [share](https://pub.dev/packages/share)
   - [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)
   - [flutter_svg](https://pub.dev/packages/flutter_svg)
   - [intl](https://pub.dev/packages/intl)
   - [adaptive_action_sheet](https://pub.dev/packages/adaptive_action_sheet)
- Provider related
   - [flutter_hooks](https://pub.dev/packages/flutter_hooks)
   - [hooks_riverpod](https://pub.dev/packages/hooks_riverpod)
   - [state_notifier](https://pub.dev/packages/state_notifier)
   - [flutter_state_notifier](https://pub.dev/packages/flutter_state_notifier)
   - [freezed_annotation](https://pub.dev/packages/freezed_annotation)

## 🚀 Coming in the Future
- Create tweet with video
- Cloud Messaging (✅Done 2021/11/19)
- Enhanced Chat functionality
- Complete migration from StatefulWidget to HookWidget



