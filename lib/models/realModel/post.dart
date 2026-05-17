class Post {
  final int id;
  final String title;
  final String image;
  final String description;
  final int likes;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.likes,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'] ?? '',
      image: json['image'],
      description: json['description'],
      likes: json['likes'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'description': description,
      'likes': likes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
