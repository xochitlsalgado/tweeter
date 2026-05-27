class Painting {
  final int id;
  final String title;
  final String year;
  final String description;
  final String imageUrl;
  final String username; // Quién la subió

  Painting({
    required this.id, 
    required this.title, 
    required this.year, 
    required this.description, 
    required this.imageUrl,
    required this.username,
  });

  factory Painting.fromJson(Map<String, dynamic> json) {
    return Painting(
      id: json['id'],
      title: json['title'] ?? '',
      year: json['year'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      // Accedemos al objeto user que mandó Java para sacar el nombre
      username: json['user'] != null ? json['user']['username'] : 'Anónimo',
    );
  }
}
