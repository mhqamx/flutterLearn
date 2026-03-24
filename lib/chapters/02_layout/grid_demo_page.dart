import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// GridView 演示页面
/// 展示各种网格布局方式
class GridDemoPage extends StatefulWidget {
  const GridDemoPage({super.key});

  @override
  State<GridDemoPage> createState() => _GridDemoPageState();
}

class _GridDemoPageState extends State<GridDemoPage> {
  /// 可调节的列数
  int _crossAxisCount = 3;

  /// 示例书籍数据
  static final List<_BookItem> _books = [
    _BookItem('Flutter 实战', Icons.flutter_dash, Colors.blue),
    _BookItem('Dart 编程', Icons.code, Colors.teal),
    _BookItem('设计模式', Icons.architecture, Colors.orange),
    _BookItem('数据结构', Icons.account_tree, Colors.green),
    _BookItem('网络编程', Icons.wifi, Colors.purple),
    _BookItem('数据库', Icons.storage, Colors.red),
    _BookItem('算法导论', Icons.functions, Colors.indigo),
    _BookItem('操作系统', Icons.computer, Colors.brown),
    _BookItem('编译原理', Icons.build, Colors.pink),
    _BookItem('人工智能', Icons.psychology, Colors.cyan),
    _BookItem('机器学习', Icons.auto_graph, Colors.amber),
    _BookItem('深度学习', Icons.layers, Colors.deepPurple),
  ];

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'GridView 网格',
      subtitle: '展示 GridView 的各种构建方式和自适应列宽',
      conceptItems: const [
        'GridView.count：指定固定列数的网格',
        'GridView.builder：动态构建网格项，适合大数据量',
        'crossAxisCount：网格的列数',
        'childAspectRatio：子项的宽高比',
        'SliverGridDelegate：控制网格布局的委托',
      ],
      children: [
        const SectionTitle('GridView.count 固定列数'),
        _buildCard(
          child: SizedBox(
            height: 220,
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
              children: _books.take(6).map((book) {
                return _buildBookTile(book);
              }).toList(),
            ),
          ),
        ),

        const SectionTitle('GridView.builder 动态构建'),
        _buildCard(
          child: SizedBox(
            height: 300,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 2.5,
              ),
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];
                return Container(
                  decoration: BoxDecoration(
                    color: book.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: book.color.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      Icon(book.icon, color: book.color, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(book.title,
                            style: TextStyle(
                                fontSize: 13,
                                color: book.color,
                                fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),

        const SectionTitle('自适应列数（Slider 控制）'),
        _buildCard(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('列数: $_crossAxisCount',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('共 ${_books.length} 本书',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                ],
              ),
              Slider(
                value: _crossAxisCount.toDouble(),
                min: 2,
                max: 5,
                divisions: 3,
                label: '$_crossAxisCount 列',
                onChanged: (v) =>
                    setState(() => _crossAxisCount = v.toInt()),
              ),
              SizedBox(
                height: 320,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _crossAxisCount,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: _books.length,
                  itemBuilder: (context, index) {
                    return _buildBookTile(_books[index]);
                  },
                ),
              ),
            ],
          ),
        ),

        const SectionTitle('maxCrossAxisExtent 自适应列宽'),
        _buildCard(
          child: SizedBox(
            height: 240,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.85,
              ),
              itemCount: _books.length,
              itemBuilder: (context, index) {
                return _buildBookTile(_books[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  /// 构建书籍网格项
  Widget _buildBookTile(_BookItem book) {
    return Container(
      decoration: BoxDecoration(
        color: book.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: book.color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(book.icon, color: book.color, size: 32),
          const SizedBox(height: 6),
          Text(book.title,
              style: TextStyle(
                  fontSize: 12,
                  color: book.color,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  static Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(width: double.infinity, child: child),
      ),
    );
  }
}

/// 书籍数据模型
class _BookItem {
  final String title;
  final IconData icon;
  final Color color;

  const _BookItem(this.title, this.icon, this.color);
}
