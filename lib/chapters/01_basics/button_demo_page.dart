import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// Button 演示页面
/// 展示 Flutter 中各种按钮类型及其交互
class ButtonDemoPage extends StatefulWidget {
  const ButtonDemoPage({super.key});

  @override
  State<ButtonDemoPage> createState() => _ButtonDemoPageState();
}

class _ButtonDemoPageState extends State<ButtonDemoPage> {
  /// 各按钮的点击计数
  int _elevatedCount = 0;
  int _outlinedCount = 0;
  int _textCount = 0;
  int _iconCount = 0;

  /// 是否显示 FAB 的提示
  bool _fabPressed = false;

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Button 按钮',
      subtitle: '展示各种按钮类型、样式自定义和交互反馈',
      conceptItems: const [
        'ElevatedButton：带阴影的凸起按钮，用于主要操作',
        'OutlinedButton：带边框的按钮，用于次要操作',
        'TextButton：纯文本按钮，用于低优先级操作',
        'IconButton：图标按钮，常用于工具栏',
        'FloatingActionButton：浮动操作按钮，用于页面主要操作',
        'onPressed: null：设为 null 即为禁用状态',
      ],
      children: [
        const SectionTitle('ElevatedButton'),
        _buildCard(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () => setState(() => _elevatedCount++),
                child: Text('点击计数: $_elevatedCount'),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => setState(() => _elevatedCount++),
                icon: const Icon(Icons.add),
                label: const Text('带图标的按钮'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => setState(() => _elevatedCount++),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('自定义样式'),
              ),
            ],
          ),
        ),

        const SectionTitle('OutlinedButton'),
        _buildCard(
          child: Column(
            children: [
              OutlinedButton(
                onPressed: () => setState(() => _outlinedCount++),
                child: Text('点击计数: $_outlinedCount'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => setState(() => _outlinedCount++),
                icon: const Icon(Icons.bookmark_border),
                label: const Text('收藏'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => setState(() => _outlinedCount++),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.orange, width: 2),
                  foregroundColor: Colors.orange,
                ),
                child: const Text('橙色边框'),
              ),
            ],
          ),
        ),

        const SectionTitle('TextButton'),
        _buildCard(
          child: Column(
            children: [
              TextButton(
                onPressed: () => setState(() => _textCount++),
                child: Text('点击计数: $_textCount'),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => setState(() => _textCount++),
                icon: const Icon(Icons.link),
                label: const Text('了解更多'),
              ),
            ],
          ),
        ),

        const SectionTitle('IconButton'),
        _buildCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  IconButton(
                    onPressed: () => setState(() => _iconCount++),
                    icon: const Icon(Icons.thumb_up),
                    color: Colors.blue,
                    iconSize: 32,
                  ),
                  Text('$_iconCount', style: const TextStyle(fontSize: 12)),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share),
                color: Colors.green,
                iconSize: 32,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete),
                color: Colors.red,
                iconSize: 32,
              ),
              IconButton.filled(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                iconSize: 24,
              ),
            ],
          ),
        ),

        const SectionTitle('FloatingActionButton 样式'),
        _buildCard(
          child: Column(
            children: [
              if (_fabPressed)
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('FAB 被点击了！',
                      style: TextStyle(color: Colors.green)),
                ),
              Wrap(
                spacing: 16,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  FloatingActionButton.small(
                    heroTag: 'fab_small',
                    onPressed: () => setState(() => _fabPressed = !_fabPressed),
                    child: const Icon(Icons.add),
                  ),
                  FloatingActionButton(
                    heroTag: 'fab_normal',
                    onPressed: () => setState(() => _fabPressed = !_fabPressed),
                    child: const Icon(Icons.edit),
                  ),
                  FloatingActionButton.large(
                    heroTag: 'fab_large',
                    onPressed: () => setState(() => _fabPressed = !_fabPressed),
                    child: const Icon(Icons.navigation),
                  ),
                  FloatingActionButton.extended(
                    heroTag: 'fab_extended',
                    onPressed: () => setState(() => _fabPressed = !_fabPressed),
                    icon: const Icon(Icons.add),
                    label: const Text('新建'),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SectionTitle('禁用状态按钮'),
        _buildCard(
          child: const Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              ElevatedButton(onPressed: null, child: Text('禁用 Elevated')),
              OutlinedButton(onPressed: null, child: Text('禁用 Outlined')),
              TextButton(onPressed: null, child: Text('禁用 Text')),
              IconButton(onPressed: null, icon: Icon(Icons.block)),
            ],
          ),
        ),

        const SectionTitle('按钮组合 - 计数器'),
        _buildCard(
          child: _CounterWidget(),
        ),
      ],
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

/// 计数器组件，演示按钮组合交互
class _CounterWidget extends StatefulWidget {
  @override
  State<_CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<_CounterWidget> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$_count',
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _count > 0 ? () => setState(() => _count--) : null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
              child: const Icon(Icons.remove, color: Colors.white),
            ),
            const SizedBox(width: 16),
            OutlinedButton(
              onPressed: () => setState(() => _count = 0),
              child: const Text('重置'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () => setState(() => _count++),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[400]),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
