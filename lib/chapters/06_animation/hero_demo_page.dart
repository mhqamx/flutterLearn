import 'package:flutter/material.dart';

/// Hero 共享元素动画 Demo
/// 演示 Hero tag 基础用法、图片列表点击放大、卡片展开详情、自定义动画曲线
/// 注意：Hero 动画需要 Navigator.push 触发，因此使用自定义 Scaffold
class HeroDemoPage extends StatelessWidget {
  const HeroDemoPage({super.key});

  // 示例数据
  static final List<Map<String, dynamic>> _items = [
    {'title': 'Flutter', 'color': Colors.blue, 'icon': Icons.phone_android, 'desc': '谷歌的跨平台 UI 框架'},
    {'title': 'Dart', 'color': Colors.teal, 'icon': Icons.code, 'desc': '高效的编程语言'},
    {'title': 'Material', 'color': Colors.deepPurple, 'icon': Icons.palette, 'desc': 'Google 设计系统'},
    {'title': 'Cupertino', 'color': Colors.orange, 'icon': Icons.phone_iphone, 'desc': 'Apple 风格组件'},
    {'title': 'Animation', 'color': Colors.red, 'icon': Icons.animation, 'desc': '强大的动画系统'},
    {'title': 'Widget', 'color': Colors.green, 'icon': Icons.widgets, 'desc': '一切皆 Widget'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hero 共享元素动画')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 说明
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hero 共享元素动画',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('点击卡片查看 Hero 动画效果，元素会平滑地从列表过渡到详情页',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 图标网格列表
            Text('1. 图标列表点击放大',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => _HeroDetailPage(item: item, index: index),
                      ),
                    );
                  },
                  child: Hero(
                    // Hero 的唯一标识
                    tag: 'hero_icon_$index',
                    child: Container(
                      decoration: BoxDecoration(
                        color: (item['color'] as Color).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item['icon'] as IconData, size: 36, color: item['color'] as Color),
                          const SizedBox(height: 4),
                          Text(
                            item['title'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: item['color'] as Color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // 卡片展开详情
            Text('2. 卡片展开详情',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ...List.generate(_items.length, (index) {
              final item = _items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      // 自定义 Hero 动画曲线
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (context, animation, secondaryAnimation) => _HeroCardDetailPage(item: item, index: index),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'hero_card_$index',
                    // 自定义 flightShuttleBuilder 可以定制飞行中的外观
                    child: Material(
                      borderRadius: BorderRadius.circular(12),
                      elevation: 2,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: (item['color'] as Color).withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: item['color'] as Color,
                              child: Icon(item['icon'] as IconData, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['title'] as String,
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text(item['desc'] as String,
                                      style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 16),
            // 知识点
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lightbulb, color: Colors.amber, size: 18),
                      const SizedBox(width: 6),
                      Text('核心知识点',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _knowledgeItem('Hero tag', '在源页面和目标页面设置相同 tag，Flutter 自动计算过渡动画'),
                  _knowledgeItem('Navigator.push', 'Hero 动画在路由跳转时触发，需要 push/pop 操作'),
                  _knowledgeItem('PageRouteBuilder', '可自定义路由过渡动画，配合 Hero 使用效果更好'),
                  _knowledgeItem('flightShuttleBuilder', '自定义 Hero 飞行过程中的 Widget 外观'),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _knowledgeItem(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$title：',
              style: TextStyle(fontFamily: 'monospace', color: Colors.orange[700], fontSize: 13, fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text: desc,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

/// Hero 图标详情页
class _HeroDetailPage extends StatelessWidget {
  final Map<String, dynamic> item;
  final int index;

  const _HeroDetailPage({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['title'] as String),
        backgroundColor: (item['color'] as Color).withValues(alpha: 0.1),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'hero_icon_$index',
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: (item['color'] as Color).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item['icon'] as IconData, size: 80, color: item['color'] as Color),
                    const SizedBox(height: 8),
                    Text(
                      item['title'] as String,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: item['color'] as Color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(item['desc'] as String, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('返回（触发反向 Hero 动画）'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Hero 卡片详情页
class _HeroCardDetailPage extends StatelessWidget {
  final Map<String, dynamic> item;
  final int index;

  const _HeroCardDetailPage({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item['title'] as String)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: 'hero_card_$index',
              child: Material(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withValues(alpha: 0.1),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: item['color'] as Color,
                        child: Icon(item['icon'] as IconData, color: Colors.white, size: 40),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        item['title'] as String,
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['desc'] as String,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('详细信息', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(
                    '这是 ${item['title']} 的详情页面。Hero 动画让卡片从列表中平滑展开到详情页，'
                    '创造了视觉上的连续感。\n\n'
                    '点击返回按钮可以看到反向的 Hero 动画，卡片会平滑地缩回到列表中的位置。',
                    style: const TextStyle(fontSize: 14, height: 1.6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
