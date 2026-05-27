import 'tweet.dart';

<<<<<<< HEAD
/// Model for the paginated response from the tweets API endpoint
class TweetResponse {
  final List<Tweet> content;

  TweetResponse({
    required this.content,
  });

  /// Convert JSON to TweetResponse object
  factory TweetResponse.fromJson(Map<String, dynamic> json) {
    final contentList = json['content'] as List<dynamic>? ?? [];
    return TweetResponse(
      content: contentList
          .map((tweet) {
            final tweetMap = Map<String, dynamic>.from(tweet as Map);
            return Tweet.fromJson(tweetMap);
          })
          .toList(),
    );
  }

  @override
  String toString() =>
      'TweetResponse(content: ${content.length}, totalElements)';
=======
class TweetResponse {
  final List<Tweet> content;

  TweetResponse({required this.content});

  factory TweetResponse.fromJson(Map<String, dynamic> json) {
    final contentList = json['content'] as List<dynamic>? ?? [];
    return TweetResponse(
      content: contentList.map((tweet) => Tweet.fromJson(tweet)).toList(),
    );
  }
>>>>>>> 9ba01315fa07469fe69784858ebfc85f7a5d1467
}
