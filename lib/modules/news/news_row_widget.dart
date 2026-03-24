import 'package:flutter/material.dart';
import 'package:flutter_learn/core/models/news_article.dart';

class NewsRowWidget extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback? onTap;

  const NewsRowWidget({super.key, required this.article, this.onTap});

  static const _tagColors = [
    Colors.blue, Colors.green, Colors.orange, Colors.purple,
    Colors.red, Colors.teal, Colors.indigo, Colors.pink,
  ];

  @override
  Widget build(BuildContext context) {
    final tagColor = _tagColors[article.userId % _tagColors.length];
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(article.formattedTitle,
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 6),
                  Text(article.summary, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: tagColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(article.category,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: tagColor)),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.access_time, size: 12, color: Colors.grey[400]),
                      const SizedBox(width: 2),
                      Text(article.publishedAt, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                      const Spacer(),
                      Icon(Icons.visibility, size: 12, color: Colors.grey[400]),
                      const SizedBox(width: 2),
                      Text('${article.readCount}', style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // 占位图
            Container(
              width: 80,
              height: 70,
              decoration: BoxDecoration(
                color: tagColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.article, color: tagColor.withValues(alpha: 0.5)),
            ),
          ],
        ),
      ),
    );
  }
}

/// 新闻详情页
class NewsDetailPage extends StatefulWidget {
  final NewsArticle article;
  const NewsDetailPage({super.key, required this.article});

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  bool _isLiked = false;
  bool _isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    return Scaffold(
      appBar: AppBar(
        title: const Text('详情'),
        actions: [
          IconButton(
            icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border,
                color: _isLiked ? Colors.red : null),
            onPressed: () => setState(() => _isLiked = !_isLiked),
          ),
          IconButton(
            icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () => setState(() => _isBookmarked = !_isBookmarked),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(article.formattedTitle,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(label: Text(article.category, style: const TextStyle(fontSize: 11))),
                const SizedBox(width: 8),
                Icon(Icons.access_time, size: 14, color: Colors.grey[400]),
                const SizedBox(width: 4),
                Text(article.publishedAt, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                const Spacer(),
                Icon(Icons.visibility, size: 14, color: Colors.grey[400]),
                const SizedBox(width: 4),
                Text('${article.readCount}', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
            const Divider(height: 24),
            Text(article.body, style: const TextStyle(fontSize: 16, height: 1.8)),
            const SizedBox(height: 16),
            // 模拟长文章
            Text(article.body, style: const TextStyle(fontSize: 16, height: 1.8)),
            Text(article.body, style: const TextStyle(fontSize: 16, height: 1.8)),
          ],
        ),
      ),
    );
  }
}
