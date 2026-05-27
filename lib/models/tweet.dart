class Tweet {
  final int id;
  final String tweet;

<<<<<<< HEAD
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
=======
  Tweet({required this.id, required this.tweet});

  // Convierte el JSON de la base de datos a un objeto de Flutter
  factory Tweet.fromJson(Map<String, dynamic> json) {
    return Tweet(
      id: json['id'],
      tweet: json['tweet'] ?? '',
    );
  }
>>>>>>> 9ba01315fa07469fe69784858ebfc85f7a5d1467
}
