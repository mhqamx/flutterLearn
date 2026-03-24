import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// 滚动视图演示页面
/// 展示各种滚动视图的用法
class ScrollViewDemoPage extends StatefulWidget {
  const ScrollViewDemoPage({super.key});

  @override
  State<ScrollViewDemoPage> createState() => _ScrollViewDemoPageState();
}

class _ScrollViewDemoPageState extends State<ScrollViewDemoPage> {
  /// 当前展示的滚动视图类型
  int _selectedIndex = 0;

  final List<String> _types = [
    'SingleChildScrollView',
    'ListView',
    '水平 ListView',
    'CustomScrollView',
  ];

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'ScrollView 滚动视图',
      subtitle: '展示各种滚动视图：ListView、CustomScrollView 等',
      conceptItems: const [
        'SingleChildScrollView：单个子组件的滚动视图',
        'ListView：最常用的滚动列表，支持垂直和水平',
        'ListView.builder：按需构建列表项，适合大数据量',
        'CustomScrollView：使用 Sliver 构建的自定义滚动视图',
        'SliverAppBar：可折叠的应用栏',
        'SliverList：Sliver 版本的列表',
      ],
      children: [
        // 类型切换
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _types.asMap().entries.map((entry) {
            return ChoiceChip(
              label: Text(entry.value, style: const TextStyle(fontSize: 12)),
              selected: _selectedIndex == entry.key,
              onSelected: (_) => setState(() => _selectedIndex = entry.key),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),

        // 展示区域
        _buildCard(
          child: SizedBox(
            height: 400,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildScrollView(),
            ),
          ),
        ),
      ],
    );
  }

  /// 根据选择构建不同的滚动视图
  Widget _buildScrollView() {
    switch (_selectedIndex) {
      case 0:
        return _buildSingleChildScrollView();
      case 1:
        return _buildListView();
      case 2:
        return _buildHorizontalListView();
      case 3:
        return _buildCustomScrollView();
      default:
        return const SizedBox();
    }
  }

  /// SingleChildScrollView 示例
  Widget _buildSingleChildScrollView() {
    return Container(
      color: Colors.grey[50],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('SingleChildScrollView',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            const Text(
              'SingleChildScrollView 适用于内容不多但可能超出屏幕的情况。'
              '它会将整个子组件一次性渲染，因此不适合用于大量数据。\n\n'
              '如果你的内容是一个很长的 Column，可以用 SingleChildScrollView 包裹它，'
              '使其在内容超出屏幕时可以滚动。\n\n'
              '对于大量数据，推荐使用 ListView.builder，它会按需构建列表项，性能更好。',
              style: TextStyle(fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 16),
            ...List.generate(10, (index) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.primaries[index % Colors.primaries.length]
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('内容块 ${index + 1}',
                    style: const TextStyle(fontSize: 14)),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// ListView 示例
  Widget _buildListView() {
    return ListView.builder(
      itemCount: 30,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor:
                Colors.primaries[index % Colors.primaries.length],
            child: Text('${index + 1}',
                style: const TextStyle(color: Colors.white)),
          ),
          title: Text('列表项 ${index + 1}'),
          subtitle: Text('这是 ListView.builder 动态构建的第 ${index + 1} 项'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('点击了第 ${index + 1} 项'),
                duration: const Duration(milliseconds: 800),
              ),
            );
          },
        );
      },
    );
  }

  /// 水平 ListView 示例
  Widget _buildHorizontalListView() {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('水平滚动列表',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('向左右滑动浏览内容',
              style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 15,
              itemBuilder: (context, index) {
                return Container(
                  width: 130,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.primaries[index % Colors.primaries.length],
                        Colors.primaries[(index + 3) % Colors.primaries.length],
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.book, color: Colors.white, size: 36),
                        const SizedBox(height: 8),
                        Text('Card ${index + 1}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          const Text('水平分隔列表',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return Container(
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.primaries[index % Colors.primaries.length]
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.star,
                      color: Colors.primaries[index % Colors.primaries.length],
                      size: 32,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// CustomScrollView + SliverAppBar + SliverList 示例
  Widget _buildCustomScrollView() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 150,
          floating: false,
          pinned: true,
          automaticallyImplyLeading: false,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('CustomScrollView',
                style: TextStyle(fontSize: 14)),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue[400]!, Colors.purple[400]!],
                ),
              ),
              child: const Center(
                child: Icon(Icons.expand_less, color: Colors.white54, size: 40),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('向上滚动查看 SliverAppBar 折叠效果',
                style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.primaries[index % Colors.primaries.length]
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: Icon(Icons.article,
                      color: Colors.primaries[index % Colors.primaries.length]),
                  title: Text('Sliver 列表项 ${index + 1}'),
                  subtitle: const Text('SliverList 中的内容'),
                ),
              );
            },
            childCount: 20,
          ),
        ),
      ],
    );
  }

  static Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(width: double.infinity, child: child),
      ),
    );
  }
}
