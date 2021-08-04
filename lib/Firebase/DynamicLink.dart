import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLink {
  Future<Uri> createDynamicLink({
    required String tweetId,
    required String tweetAuthorId,
    required String tweetText,
    required String imageUrl,
  }) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://fluttertwitterclone.page.link',
      link: Uri.parse(
          'https://fluttertwitterclone.page.link.com/?tweetId=$tweetId&tweetAuthorId=$tweetAuthorId'),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Twitter_clone',
        description: tweetText,
        imageUrl: Uri.parse(
          imageUrl,
        ),
      ),
      androidParameters: AndroidParameters(
        packageName: 'com.example.twitter_clone',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.example.twitterClone',
        minimumVersion: '1',
        appStoreId: '123456789',
      ),
    );

    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri shortUri = shortDynamicLink.shortUrl;
    return shortUri;
  }
}
