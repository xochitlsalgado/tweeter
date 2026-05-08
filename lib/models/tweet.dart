class Tweet {
  final int id;
  final String tweet;

  Tweet({required this.id, required this.tweet});

  // Convierte el JSON de la base de datos a un objeto de Flutter
  factory Tweet.fromJson(Map<String, dynamic> json) {
    return Tweet(
      id: json['id'],
      tweet: json['tweet'] ?? '',
    );
  }
}
