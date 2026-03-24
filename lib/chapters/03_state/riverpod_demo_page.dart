import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// ValueNotifier + ValueListenableBuilder 演示页面
/// 展示轻量级状态管理方式和 InheritedWidget 基础
class RiverpodDemoPage extends StatefulWidget {
  const RiverpodDemoPage({super.key});

  @override
  State<RiverpodDemoPage> createState() => _RiverpodDemoPageState();
}

class _RiverpodDemoPageState extends State<RiverpodDemoPage> {
  /// ValueNotifier - 计数器
  final _counter = ValueNotifier<int>(0);

  /// ValueNotifier - 颜色
  final _color = ValueNotifier<Color>(Colors.blue);

  /// ValueNotifier - 文本
  final _text = ValueNotifier<String>('');

  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      _text.value = _textController.text;
    });
  }

  @override
  void dispose() {
    _counter.dispose();
    _color.dispose();
    _text.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ThemeInherited(
      themeColor: Colors.indigo,
      child: DemoScaffold(
        title: 'ValueNotifier 与 InheritedWidget',
        subtitle: '轻量级状态管理方式，不依赖第三方包',
        conceptItems: const [
          'ValueNotifier<T>：持有单个值的 ChangeNotifier 子类',
          'ValueListenableBuilder：监听 ValueNotifier 并自动重建',
          'InheritedWidget：Flutter 内置的跨组件数据传递机制',
          'Provider 底层就是基于 InheritedWidget 实现的',
          '对比：setState 适合局部，ValueNotifier 适合单值，ChangeNotifier 适合复杂对象',
        ],
        children: [
          const SectionTitle('ValueNotifier 基础用法'),
          _buildCard(
            child: Column(
              children: [
                const Text('ValueNotifier<int> 计数器',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                // ValueListenableBuilder 自动监听并重建
                ValueListenableBuilder<int>(
                  valueListenable: _counter,
                  builder: (context, value, child) {
                    return Column(
                      children: [
                        Text('$value',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        // child 参数不会因值变化而重建
                        child!,
                      ],
                    );
                  },
                  // 这个 child 不依赖 value，只构建一次
                  child: const Text('child 参数只构建一次，性能更好',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_counter.value > 0) _counter.value--;
                      },
                      child: const Icon(Icons.remove),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton(
                      onPressed: () => _counter.value = 0,
                      child: const Text('重置'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => _counter.value++,
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SectionTitle('ValueNotifier 颜色选择'),
          _buildCard(
            child: Column(
              children: [
                ValueListenableBuilder<Color>(
                  valueListenable: _color,
                  builder: (context, color, _) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.4),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.palette, color: Colors.white, size: 36),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    Colors.blue, Colors.red, Colors.green,
                    Colors.purple, Colors.orange, Colors.teal,
                  ].map((c) {
                    return GestureDetector(
                      onTap: () => _color.value = c,
                      child: ValueListenableBuilder<Color>(
                        valueListenable: _color,
                        builder: (context, selected, _) {
                          return Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: selected == c
                                  ? Border.all(color: Colors.black, width: 3)
                                  : null,
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SectionTitle('ValueListenableBuilder 实时输入'),
          _buildCard(
            child: Column(
              children: [
                TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    labelText: '输入文本',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder<String>(
                  valueListenable: _text,
                  builder: (context, text, _) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(text.isEmpty ? '（实时显示输入内容）' : text),
                          const SizedBox(height: 4),
                          Text('字符数: ${text.length}',
                              style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SectionTitle('InheritedWidget 简单示例'),
          _buildCard(
            child: Builder(
              builder: (context) {
                // 通过 InheritedWidget 获取数据
                final themeColor = _ThemeInherited.of(context);
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: themeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: themeColor.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.color_lens, color: themeColor, size: 36),
                          const SizedBox(height: 8),
                          Text('通过 InheritedWidget 获取的主题色',
                              style: TextStyle(color: themeColor)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'InheritedWidget 是 Flutter 内置的跨组件数据传递机制。\n'
                        'Provider、Riverpod 等状态管理库底层都使用了 InheritedWidget。\n'
                        '它通过 context.dependOnInheritedWidgetOfExactType 来获取祖先组件提供的数据。',
                        style: TextStyle(fontSize: 13, height: 1.5),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const SectionTitle('状态管理方式对比'),
          _buildCard(
            child: Table(
              border: TableBorder.all(color: Colors.grey[300]!),
              columnWidths: const {
                0: FlexColumnWidth(1.2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1.5),
              },
              children: const [
                TableRow(
                  decoration: BoxDecoration(color: Color(0xFFE3F2FD)),
                  children: [
                    _TableCell('方式', isHeader: true),
                    _TableCell('适用场景', isHeader: true),
                    _TableCell('特点', isHeader: true),
                  ],
                ),
                TableRow(children: [
                  _TableCell('setState'),
                  _TableCell('局部状态'),
                  _TableCell('最简单，只影响当前组件'),
                ]),
                TableRow(children: [
                  _TableCell('ValueNotifier'),
                  _TableCell('单值监听'),
                  _TableCell('轻量，适合简单值'),
                ]),
                TableRow(children: [
                  _TableCell('ChangeNotifier'),
                  _TableCell('复杂对象'),
                  _TableCell('灵活，适合业务逻辑'),
                ]),
                TableRow(children: [
                  _TableCell('Provider'),
                  _TableCell('跨组件共享'),
                  _TableCell('官方推荐，基于 InheritedWidget'),
                ]),
              ],
            ),
          ),
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

// ==================== InheritedWidget 示例 ====================

/// 自定义 InheritedWidget，提供主题颜色
class _ThemeInherited extends InheritedWidget {
  final Color themeColor;

  const _ThemeInherited({
    required this.themeColor,
    required super.child,
  });

  /// 便捷方法获取最近的 _ThemeInherited
  static Color of(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<_ThemeInherited>();
    return widget?.themeColor ?? Colors.blue;
  }

  @override
  bool updateShouldNotify(_ThemeInherited oldWidget) {
    return themeColor != oldWidget.themeColor;
  }
}

/// 表格单元格
class _TableCell extends StatelessWidget {
  final String text;
  final bool isHeader;

  const _TableCell(this.text, {this.isHeader = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
