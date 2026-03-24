class Product {
  final int id;
  final int albumId;
  final String title;
  final String url;
  final String thumbnailUrl;

  Product({
    required this.id,
    required this.albumId,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      albumId: json['albumId'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }

  static List<Product> fromJsonList(dynamic json) {
    return (json as List).map((e) => Product.fromJson(e)).toList();
  }

  double get price => ((id * 17 + albumId * 13) % 1000) + 9.9;
  String get priceText => '¥${price.toStringAsFixed(2)}';
  int get salesCount => (id * 83 + albumId * 47) % 5000;
  double get rating => 4.0 + ((id + albumId) % 20) / 100.0 * 5.0;

  String get shortTitle => title.length > 20 ? '${title.substring(0, 20)}...' : title;

  static const _categories = ['数码', '服饰', '美妆', '食品', '家居', '运动', '图书', '母婴'];
  String get category => _categories[(id + albumId) % _categories.length];
}
