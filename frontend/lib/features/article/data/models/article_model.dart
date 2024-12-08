class Article {
  final int id;
  final String title;
  final String content;
  final int userId;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      userId: json['userId'],
    );
  }
}
