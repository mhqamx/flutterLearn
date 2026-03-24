class NewsArticle {
  final int id;
  final int userId;
  final String title;
  final String body;

  NewsArticle({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  static List<NewsArticle> fromJsonList(dynamic json) {
    return (json as List).map((e) => NewsArticle.fromJson(e)).toList();
  }

  String get formattedTitle {
    if (title.isEmpty) return title;
    return title[0].toUpperCase() + title.substring(1);
  }

  String get summary => body.length > 80 ? '${body.substring(0, 80)}...' : body;

  static const _categories = [
    '时政', '科技', '教育', '财经', '社会',
    '文化', '健康', '体育', '娱乐', '国际',
  ];

  String get category => _categories[userId % _categories.length];

  String get publishedAt => '${(id * 3 + userId * 7) % 24}小时前';

  int get readCount => (id * 83 + userId * 47) % 10000;
}
