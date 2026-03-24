import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// ListView 基础 Demo
/// 演示 ListView、ListView.builder、ListView.separated、ListTile
class ListBasicsDemoPage extends StatelessWidget {
  const ListBasicsDemoPage({super.key});

  // 示例书籍数据
  static final List<Map<String, dynamic>> _books = [
    {'title': 'Flutter 实战', 'author': '杜文', 'rating': 4.8, 'icon': Icons.phone_android},
    {'title': 'Dart 编程语言', 'author': '张三', 'rating': 4.5, 'icon': Icons.code},
    {'title': '移动端架构设计', 'author': '李四', 'rating': 4.6, 'icon': Icons.architecture},
    {'title': '深入理解 Widget', 'author': '王五', 'rating': 4.3, 'icon': Icons.widgets},
    {'title': '状态管理实践', 'author': '赵六', 'rating': 4.7, 'icon': Icons.sync},
    {'title': 'UI 动画进阶', 'author': '钱七', 'rating': 4.4, 'icon': Icons.animation},
    {'title': '网络编程指南', 'author': '孙八', 'rating': 4.2, 'icon': Icons.wifi},
    {'title': '测试驱动开发', 'author': '周九', 'rating': 4.1, 'icon': Icons.bug_report},
  ];

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'ListView 基础',
      subtitle: '演示 ListView 的多种构建方式和 ListTile 的常见用法',
      conceptItems: const [
        'ListView：直接传入 children 列表，适合少量固定子组件',
        'ListView.builder：按需构建子组件，适合大量数据，性能更优',
        'ListView.separated：在每个子组件间插入分隔线',
        'ListTile：Material 规范的列表行组件，包含 leading/title/subtitle/trailing',
        'shrinkWrap：设为 true 让 ListView 根据内容自适应高度（嵌套时使用）',
      ],
      children: [
        const SectionTitle('1. ListView 直接子组件'),
        _buildDirectListView(),
        const SizedBox(height: 16),

        const SectionTitle('2. ListView.builder 动态构建'),
        _buildBuilderListView(),
        const SizedBox(height: 16),

        const SectionTitle('3. ListView.separated 带分隔线'),
        _buildSeparatedListView(),
        const SizedBox(height: 16),

        const SectionTitle('4. ListTile 丰富用法'),
        _buildListTileShowcase(),
      ],
    );
  }

  /// 直接子组件列表
  Widget _buildDirectListView() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView(
        children: const [
          ListTile(leading: Icon(Icons.star, color: Colors.amber), title: Text('精选推荐')),
          ListTile(leading: Icon(Icons.new_releases, color: Colors.red), title: Text('新书上架')),
          ListTile(leading: Icon(Icons.trending_up, color: Colors.green), title: Text('热门排行')),
          ListTile(leading: Icon(Icons.history, color: Colors.blue), title: Text('阅读历史')),
        ],
      ),
    );
  }

  /// ListView.builder 动态构建
  Widget _buildBuilderListView() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        itemCount: _books.length,
        itemBuilder: (context, index) {
          final book = _books[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.primaries[index % Colors.primaries.length],
              child: Icon(book['icon'] as IconData, color: Colors.white, size: 20),
            ),
            title: Text(book['title'] as String),
            subtitle: Text('作者: ${book['author']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                Text(' ${book['rating']}'),
              ],
            ),
          );
        },
      ),
    );
  }

  /// ListView.separated 带分隔线
  Widget _buildSeparatedListView() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.separated(
        itemCount: _books.length,
        // 分隔线构建器
        separatorBuilder: (context, index) => const Divider(height: 1, indent: 72),
        itemBuilder: (context, index) {
          final book = _books[index];
          return ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.primaries[index % Colors.primaries.length].withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.primaries[index % Colors.primaries.length],
                  ),
                ),
              ),
            ),
            title: Text(book['title'] as String),
            subtitle: Text(book['author'] as String),
          );
        },
      ),
    );
  }

  /// ListTile 多种用法展示
  Widget _buildListTileShowcase() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // 标准 ListTile
          const ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text('标准 ListTile'),
            subtitle: Text('leading + title + subtitle + trailing'),
            trailing: Icon(Icons.chevron_right),
          ),
          const Divider(height: 1),
          // 三行 ListTile
          const ListTile(
            isThreeLine: true,
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.book, color: Colors.white),
            ),
            title: Text('三行模式'),
            subtitle: Text('isThreeLine: true\n可以显示更多副标题内容'),
            trailing: Icon(Icons.more_vert),
          ),
          const Divider(height: 1),
          // 带开关的 ListTile
          StatefulBuilder(
            builder: (context, setState) {
              bool value = false;
              return SwitchListTile(
                title: const Text('SwitchListTile'),
                subtitle: const Text('自带开关的列表项'),
                value: value,
                onChanged: (v) => setState(() => value = v),
                secondary: const Icon(Icons.settings),
              );
            },
          ),
          const Divider(height: 1),
          // 带勾选的 ListTile
          StatefulBuilder(
            builder: (context, setState) {
              bool checked = true;
              return CheckboxListTile(
                title: const Text('CheckboxListTile'),
                subtitle: const Text('自带勾选框的列表项'),
                value: checked,
                onChanged: (v) => setState(() => checked = v ?? false),
                secondary: const Icon(Icons.check_circle),
              );
            },
          ),
        ],
      ),
    );
  }
}
