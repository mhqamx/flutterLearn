import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// Padding / SizedBox / Expanded / Spacer / Flexible 演示页面
/// 对应 SwiftUI 的 padding modifier 和 Spacer
class PaddingDemoPage extends StatefulWidget {
  const PaddingDemoPage({super.key});

  @override
  State<PaddingDemoPage> createState() => _PaddingDemoPageState();
}

class _PaddingDemoPageState extends State<PaddingDemoPage> {
  /// Padding 值
  double _paddingValue = 16;

  /// Flexible flex 比例
  int _flex1 = 1;
  int _flex2 = 2;
  int _flex3 = 1;

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Padding / Spacing',
      subtitle: '对应 SwiftUI 的 .padding 和 Spacer，控制组件间距和弹性布局',
      conceptItems: const [
        'Padding：为子组件添加内边距',
        'SizedBox：固定大小的盒子，也常用于占位间距',
        'Expanded：在 Row/Column 中按比例分配剩余空间',
        'Spacer：占据 Row/Column 中的剩余空间',
        'Flexible：类似 Expanded 但子组件可以不填满分配的空间',
      ],
      children: [
        const SectionTitle('Padding 各方向（可调节）'),
        _buildCard(
          child: Column(
            children: [
              Text('Padding: ${_paddingValue.toInt()}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Slider(
                value: _paddingValue,
                min: 0,
                max: 40,
                divisions: 8,
                label: '${_paddingValue.toInt()}',
                onChanged: (v) => setState(() => _paddingValue = v),
              ),
              Container(
                color: Colors.blue[100],
                child: Padding(
                  padding: EdgeInsets.all(_paddingValue),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Colors.blue,
                    child: const Text('内容区域',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text('浅蓝色区域是 Padding 的可视化效果',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
        ),

        const SectionTitle('Padding 不同方向'),
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _paddingExample('EdgeInsets.all(16)', Colors.red,
                  const EdgeInsets.all(16)),
              const SizedBox(height: 8),
              _paddingExample('EdgeInsets.symmetric(h:24, v:8)', Colors.green,
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 8)),
              const SizedBox(height: 8),
              _paddingExample('EdgeInsets.only(left:32)', Colors.orange,
                  const EdgeInsets.only(left: 32)),
            ],
          ),
        ),

        const SectionTitle('SizedBox 固定间距'),
        _buildCard(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _colorBox('A', Colors.red),
                  const SizedBox(width: 8),
                  _colorBox('B', Colors.green),
                  const SizedBox(width: 24),
                  _colorBox('C', Colors.blue),
                ],
              ),
              const SizedBox(height: 8),
              Text('A-B 间距 8px，B-C 间距 24px',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              const SizedBox(height: 16),
              // SizedBox 作为固定大小容器
              SizedBox(
                width: 200,
                height: 50,
                child: Container(
                  color: Colors.purple[100],
                  child: const Center(child: Text('SizedBox(200x50)')),
                ),
              ),
            ],
          ),
        ),

        const SectionTitle('Expanded 等比分配'),
        _buildCard(
          child: Column(
            children: [
              const Text('三个 Expanded 各占 1/3 空间：',
                  style: TextStyle(fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _colorBox('1', Colors.red)),
                  const SizedBox(width: 4),
                  Expanded(child: _colorBox('2', Colors.green)),
                  const SizedBox(width: 4),
                  Expanded(child: _colorBox('3', Colors.blue)),
                ],
              ),
              const SizedBox(height: 16),
              const Text('flex: 1 : 2 : 1 的比例：',
                  style: TextStyle(fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(flex: 1, child: _colorBox('1', Colors.red)),
                  const SizedBox(width: 4),
                  Expanded(flex: 2, child: _colorBox('2', Colors.green)),
                  const SizedBox(width: 4),
                  Expanded(flex: 1, child: _colorBox('3', Colors.blue)),
                ],
              ),
            ],
          ),
        ),

        const SectionTitle('Spacer 弹性空间'),
        _buildCard(
          child: Column(
            children: [
              const Text('Spacer 将剩余空间均匀分配：',
                  style: TextStyle(fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _colorBox('左', Colors.red, width: 50),
                  const Spacer(),
                  _colorBox('右', Colors.blue, width: 50),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Spacer(flex:2) 和 Spacer(flex:1)：',
                  style: TextStyle(fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _colorBox('A', Colors.red, width: 40),
                  const Spacer(flex: 2),
                  _colorBox('B', Colors.green, width: 40),
                  const Spacer(flex: 1),
                  _colorBox('C', Colors.blue, width: 40),
                ],
              ),
            ],
          ),
        ),

        const SectionTitle('Flexible flex 分配（可交互）'),
        _buildCard(
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(flex: _flex1, child: _colorBox('$_flex1', Colors.red)),
                  const SizedBox(width: 4),
                  Flexible(flex: _flex2, child: _colorBox('$_flex2', Colors.green)),
                  const SizedBox(width: 4),
                  Flexible(flex: _flex3, child: _colorBox('$_flex3', Colors.blue)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text('红 flex: $_flex1', style: const TextStyle(fontSize: 12)),
                        Slider(
                          value: _flex1.toDouble(),
                          min: 1, max: 5, divisions: 4,
                          onChanged: (v) => setState(() => _flex1 = v.toInt()),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text('绿 flex: $_flex2', style: const TextStyle(fontSize: 12)),
                        Slider(
                          value: _flex2.toDouble(),
                          min: 1, max: 5, divisions: 4,
                          onChanged: (v) => setState(() => _flex2 = v.toInt()),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text('蓝 flex: $_flex3', style: const TextStyle(fontSize: 12)),
                        Slider(
                          value: _flex3.toDouble(),
                          min: 1, max: 5, divisions: 4,
                          onChanged: (v) => setState(() => _flex3 = v.toInt()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Padding 示例行
  Widget _paddingExample(String label, Color color, EdgeInsets padding) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontFamily: 'monospace')),
        const SizedBox(height: 4),
        Container(
          color: color.withValues(alpha: 0.2),
          child: Padding(
            padding: padding,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: color,
              child: const Text('内容', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _colorBox(String label, Color color, {double? width}) {
    return Container(
      width: width,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
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
