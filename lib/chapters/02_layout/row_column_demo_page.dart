import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// Row / Column / Stack 演示页面
/// 对应 SwiftUI 的 HStack / VStack / ZStack
class RowColumnDemoPage extends StatefulWidget {
  const RowColumnDemoPage({super.key});

  @override
  State<RowColumnDemoPage> createState() => _RowColumnDemoPageState();
}

class _RowColumnDemoPageState extends State<RowColumnDemoPage> {
  /// 当前选中的 MainAxisAlignment
  MainAxisAlignment _mainAxis = MainAxisAlignment.start;

  /// 当前选中的 CrossAxisAlignment
  CrossAxisAlignment _crossAxis = CrossAxisAlignment.center;

  /// 是否为 Row 模式（false 则为 Column）
  bool _isRow = true;

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Row / Column / Stack',
      subtitle: '对应 SwiftUI 的 HStack / VStack / ZStack，Flutter 的核心布局组件',
      conceptItems: const [
        'Row：水平排列子组件，对应 SwiftUI 的 HStack',
        'Column：垂直排列子组件，对应 SwiftUI 的 VStack',
        'Stack：层叠排列子组件，对应 SwiftUI 的 ZStack',
        'MainAxisAlignment：主轴对齐方式（Row 水平方向，Column 垂直方向）',
        'CrossAxisAlignment：交叉轴对齐方式',
        'Positioned：在 Stack 中精确定位子组件',
      ],
      children: [
        const SectionTitle('Column 垂直排列'),
        _buildCard(
          child: Column(
            children: [
              _colorBox('第一个', Colors.red),
              const SizedBox(height: 8),
              _colorBox('第二个', Colors.green),
              const SizedBox(height: 8),
              _colorBox('第三个', Colors.blue),
            ],
          ),
        ),

        const SectionTitle('Row 水平排列'),
        _buildCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _colorBox('A', Colors.red, width: 60),
              _colorBox('B', Colors.green, width: 60),
              _colorBox('C', Colors.blue, width: 60),
            ],
          ),
        ),

        const SectionTitle('对齐方式（可交互）'),
        _buildCard(
          child: Column(
            children: [
              // 模式切换
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text('Row'),
                    selected: _isRow,
                    onSelected: (_) => setState(() => _isRow = true),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Column'),
                    selected: !_isRow,
                    onSelected: (_) => setState(() => _isRow = false),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // MainAxisAlignment 选择
              const Text('MainAxisAlignment:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: MainAxisAlignment.values.map((align) {
                  return ChoiceChip(
                    label: Text(align.name, style: const TextStyle(fontSize: 11)),
                    selected: _mainAxis == align,
                    onSelected: (_) => setState(() => _mainAxis = align),
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),

              // CrossAxisAlignment 选择
              const Text('CrossAxisAlignment:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  CrossAxisAlignment.start,
                  CrossAxisAlignment.center,
                  CrossAxisAlignment.end,
                  CrossAxisAlignment.stretch,
                ].map((align) {
                  return ChoiceChip(
                    label: Text(align.name, style: const TextStyle(fontSize: 11)),
                    selected: _crossAxis == align,
                    onSelected: (_) => setState(() => _crossAxis = align),
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // 预览区域
              Container(
                width: double.infinity,
                height: _isRow ? 100 : 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[50],
                ),
                child: _isRow
                    ? Row(
                        mainAxisAlignment: _mainAxis,
                        crossAxisAlignment: _crossAxis,
                        children: [
                          _colorBox('A', Colors.red, width: 50, height: 30),
                          _colorBox('B', Colors.green, width: 50, height: 50),
                          _colorBox('C', Colors.blue, width: 50, height: 40),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: _mainAxis,
                        crossAxisAlignment: _crossAxis,
                        children: [
                          _colorBox('A', Colors.red, width: 80, height: 30),
                          _colorBox('B', Colors.green, width: 60, height: 30),
                          _colorBox('C', Colors.blue, width: 100, height: 30),
                        ],
                      ),
              ),
            ],
          ),
        ),

        const SectionTitle('Stack 层叠布局'),
        _buildCard(
          child: SizedBox(
            height: 200,
            child: Stack(
              children: [
                // 背景层
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[100]!, Colors.purple[100]!],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                // 居中内容
                const Center(
                  child: FlutterLogo(size: 80),
                ),
                // 左上角标签
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('NEW',
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
                // 右下角按钮
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: FloatingActionButton.small(
                    heroTag: 'stack_fab',
                    onPressed: () {},
                    child: const Icon(Icons.add),
                  ),
                ),
                // 底部文字
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Text('Stack 层叠示例',
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),

        const SectionTitle('嵌套组合'),
        _buildCard(
          child: Row(
            children: [
              // 左侧图片区域
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: FlutterLogo(size: 50)),
              ),
              const SizedBox(width: 12),
              // 右侧文字列
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Flutter 入门教程',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('学习 Flutter 布局系统的基础知识',
                        style: TextStyle(
                            color: Colors.grey[600], fontSize: 13)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber[600]),
                        const SizedBox(width: 4),
                        const Text('4.8',
                            style: TextStyle(fontSize: 13)),
                        const SizedBox(width: 16),
                        Icon(Icons.access_time,
                            size: 16, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text('30分钟',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 创建带颜色的方块
  Widget _colorBox(String label, Color color,
      {double? width, double? height}) {
    return Container(
      width: width,
      height: height ?? 40,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
