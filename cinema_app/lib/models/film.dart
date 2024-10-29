class Film {
  final int id;
  final String title;
  final String description;
  final String type;
  final String director;
  final String imageUrl;
  final int likes;

  Film({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.director,
    required this.imageUrl,
    required this.likes,
  });

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      director: json['director'],
      imageUrl: json['imageUrl'],
      likes: json['likes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'director': director,
      'imageUrl': imageUrl,
      'likes': likes,
    };
  }
}
