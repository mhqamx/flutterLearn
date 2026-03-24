import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_learn/core/models/news_article.dart';

class HomeBannerWidget extends StatefulWidget {
  final List<NewsArticle> items;
  const HomeBannerWidget({super.key, required this.items});

  @override
  State<HomeBannerWidget> createState() => _HomeBannerWidgetState();
}

class _HomeBannerWidgetState extends State<HomeBannerWidget> {
  late final PageController _controller;
  int _currentIndex = 0;
  Timer? _timer;

  static const _colors = [
    Color(0xFF6366F1), Color(0xFFEC4899), Color(0xFF14B8A6),
    Color(0xFFF59E0B), Color(0xFF8B5CF6),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    if (widget.items.isEmpty) return;
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      final next = (_currentIndex + 1) % widget.items.length;
      _controller.animateToPage(next, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 180,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: widget.items.length,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _colors[index % _colors.length],
                        _colors[index % _colors.length].withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        item.formattedTitle,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
            // 指示器
            Positioned(
              bottom: 12,
              right: 12,
              child: Row(
                children: List.generate(widget.items.length, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentIndex == i ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _currentIndex == i ? Colors.white : Colors.white54,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
