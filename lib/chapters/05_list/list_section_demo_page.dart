import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// 分组列表 Demo
/// 演示带 header 的分组列表、ExpansionTile、sticky header、自定义分组样式
class ListSectionDemoPage extends StatelessWidget {
  const ListSectionDemoPage({super.key});

  // 按类别分组的书籍数据
  static final Map<String, List<Map<String, String>>> _groupedBooks = {
    '技术': [
      {'title': 'Flutter 实战', 'author': '杜文'},
      {'title': 'Dart 编程语言', 'author': '张三'},
      {'title': '深入理解 Widget', 'author': '王五'},
    ],
    '文学': [
      {'title': '红楼梦', 'author': '曹雪芹'},
      {'title': '百年孤独', 'author': '马尔克斯'},
    ],
    '科学': [
      {'title': '时间简史', 'author': '霍金'},
      {'title': '宇宙的琴弦', 'author': '格林'},
      {'title': '自私的基因', 'author': '道金斯'},
    ],
    '历史': [
      {'title': '人类简史', 'author': '赫拉利'},
      {'title': '枪炮、病菌与钢铁', 'author': '戴蒙德'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: '分组列表',
      subtitle: '演示如何创建带分组头、可折叠、粘性头部的列表',
      conceptItems: const [
        'ExpansionTile：可折叠的列表分组，点击展开/收起子项',
        'SliverList + SliverPersistentHeader：实现 sticky header 粘性头部效果',
        'CustomScrollView：使用 Sliver 系列组件构建复杂滚动列表',
        'SliverPersistentHeaderDelegate：自定义粘性头部的外观和行为',
      ],
      children: [
        const SectionTitle('1. 带 Header 的分组列表'),
        _buildGroupedList(),
        const SizedBox(height: 16),

        const SectionTitle('2. ExpansionTile 可折叠分组'),
        _buildExpansionList(),
        const SizedBox(height: 16),

        const SectionTitle('3. Sticky Header（SliverList）'),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _StickyHeaderPage()),
            );
          },
          icon: const Icon(Icons.push_pin),
          label: const Text('查看 Sticky Header 示例'),
        ),
        const SizedBox(height: 16),

        const SectionTitle('4. 自定义分组样式'),
        _buildCustomGroupList(context),
      ],
    );
  }

  /// 带 Header 的分组列表
  Widget _buildGroupedList() {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView(
        children: _groupedBooks.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 分组头
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: Colors.grey.withValues(alpha: 0.1),
                child: Text(
                  '${entry.key} (${entry.value.length})',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              // 分组内容
              ...entry.value.map((book) => ListTile(
                    leading: const Icon(Icons.book),
                    title: Text(book['title']!),
                    subtitle: Text(book['author']!),
                  )),
            ],
          );
        }).toList(),
      ),
    );
  }

  /// ExpansionTile 可折叠
  Widget _buildExpansionList() {
    final icons = [Icons.computer, Icons.auto_stories, Icons.science, Icons.history_edu];
    final colors = [Colors.blue, Colors.red, Colors.teal, Colors.amber];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: List.generate(_groupedBooks.length, (groupIndex) {
          final entry = _groupedBooks.entries.elementAt(groupIndex);
          return ExpansionTile(
            // 初始展开第一个
            initiallyExpanded: groupIndex == 0,
            leading: Icon(icons[groupIndex], color: colors[groupIndex]),
            title: Text(entry.key),
            subtitle: Text('${entry.value.length} 本'),
            children: entry.value.map((book) {
              return ListTile(
                contentPadding: const EdgeInsets.only(left: 72, right: 16),
                title: Text(book['title']!),
                subtitle: Text(book['author']!),
                trailing: const Icon(Icons.chevron_right, size: 18),
              );
            }).toList(),
          );
        }),
      ),
    );
  }

  /// 自定义分组样式
  Widget _buildCustomGroupList(BuildContext context) {
    final categoryColors = {
      '技术': Colors.blue,
      '文学': Colors.red,
      '科学': Colors.teal,
      '历史': Colors.amber,
    };

    return Container(
      height: 400,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: _groupedBooks.entries.map((entry) {
          final color = categoryColors[entry.key] ?? Colors.grey;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 自定义分组头
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        entry.key,
                        style: TextStyle(fontWeight: FontWeight.bold, color: color),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // 卡片列表
                ...entry.value.map((book) => Card(
                      margin: const EdgeInsets.only(bottom: 4),
                      child: ListTile(
                        dense: true,
                        leading: Container(
                          width: 4,
                          height: 32,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        title: Text(book['title']!, style: const TextStyle(fontSize: 14)),
                        trailing: Text(book['author']!, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      ),
                    )),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Sticky Header 页面（需要全屏 CustomScrollView）
class _StickyHeaderPage extends StatelessWidget {
  const _StickyHeaderPage();

  @override
  Widget build(BuildContext context) {
    final groups = ListSectionDemoPage._groupedBooks;
    final categoryColors = {
      '技术': Colors.blue,
      '文学': Colors.red,
      '科学': Colors.teal,
      '历史': Colors.amber,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Sticky Header')),
      body: CustomScrollView(
        slivers: groups.entries.expand((entry) {
          final color = categoryColors[entry.key] ?? Colors.grey;
          return [
            // 粘性头部
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyHeaderDelegate(
                title: '${entry.key} (${entry.value.length})',
                color: color,
              ),
            ),
            // 列表内容
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final book = entry.value[index];
                  return ListTile(
                    leading: Icon(Icons.book, color: color),
                    title: Text(book['title']!),
                    subtitle: Text(book['author']!),
                  );
                },
                childCount: entry.value.length,
              ),
            ),
          ];
        }).toList(),
      ),
    );
  }
}

/// 粘性头部代理
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final Color color;

  const _StickyHeaderDelegate({required this.title, required this.color});

  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: color.withValues(alpha: 0.15),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return title != oldDelegate.title || color != oldDelegate.color;
  }
}
