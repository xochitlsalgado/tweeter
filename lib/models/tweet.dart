class Tweet {
  final int id;
  final String tweet;

  Tweet({
    required this.id,
    required this.tweet,
  });

  /// Convert JSON to Tweet object
  factory Tweet.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final tweetContent = json['tweet'];
    
    return Tweet(
      id: id is int ? id : (id is String ? int.tryParse(id) ?? 0 : 0),
      tweet: tweetContent is String ? tweetContent : tweetContent?.toString() ?? '',
    );
  }

  /// Convert Tweet object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tweet': tweet,
    };
  }

  @override
  String toString() => 'Tweet(id: $id, tweet: $tweet)';
}
