import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// 基础动画 Demo
/// 演示 AnimatedContainer、AnimatedOpacity、AnimatedAlign、AnimatedRotation、TweenAnimationBuilder
class BasicAnimationDemoPage extends StatefulWidget {
  const BasicAnimationDemoPage({super.key});

  @override
  State<BasicAnimationDemoPage> createState() => _BasicAnimationDemoPageState();
}

class _BasicAnimationDemoPageState extends State<BasicAnimationDemoPage> {
  // AnimatedContainer 状态
  bool _expanded = false;

  // AnimatedOpacity 状态
  bool _visible = true;

  // AnimatedAlign 状态
  Alignment _alignment = Alignment.centerLeft;

  // AnimatedRotation 状态
  double _rotation = 0;

  // TweenAnimationBuilder 状态
  double _targetValue = 0;

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: '基础动画',
      subtitle: '演示 Flutter 隐式动画组件，无需手动管理 AnimationController',
      conceptItems: const [
        'AnimatedContainer：自动对大小、颜色、边距等属性变化做动画',
        'AnimatedOpacity：自动对透明度变化做淡入淡出动画',
        'AnimatedAlign：自动对对齐位置变化做动画',
        'AnimatedRotation：自动对旋转角度变化做动画（单位为圈数）',
        'TweenAnimationBuilder：自定义 Tween 动画，灵活度更高',
        'duration：所有隐式动画都需要指定动画时长',
        'curve：指定动画曲线（如 Curves.easeInOut）',
      ],
      children: [
        const SectionTitle('1. AnimatedContainer（大小/颜色/圆角）'),
        _buildAnimatedContainerDemo(),
        const SizedBox(height: 16),

        const SectionTitle('2. AnimatedOpacity 淡入淡出'),
        _buildAnimatedOpacityDemo(),
        const SizedBox(height: 16),

        const SectionTitle('3. AnimatedAlign 位置变化'),
        _buildAnimatedAlignDemo(),
        const SizedBox(height: 16),

        const SectionTitle('4. AnimatedRotation 旋转'),
        _buildAnimatedRotationDemo(),
        const SizedBox(height: 16),

        const SectionTitle('5. TweenAnimationBuilder 自定义'),
        _buildTweenAnimationDemo(),
      ],
    );
  }

  /// AnimatedContainer 示例
  Widget _buildAnimatedContainerDemo() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutBack,
            width: _expanded ? 280 : 150,
            height: _expanded ? 150 : 80,
            decoration: BoxDecoration(
              color: _expanded ? Colors.deepPurple : Colors.blue,
              borderRadius: BorderRadius.circular(_expanded ? 24 : 8),
              boxShadow: [
                BoxShadow(
                  color: (_expanded ? Colors.deepPurple : Colors.blue).withValues(alpha: 0.4),
                  blurRadius: _expanded ? 20 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _expanded ? '点击缩小' : '点击放大',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('大小、颜色、圆角同时变化', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  /// AnimatedOpacity 示例
  Widget _buildAnimatedOpacityDemo() {
    return Column(
      children: [
        AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: Container(
            width: 200,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('我会淡入淡出', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () => setState(() => _visible = !_visible),
          icon: Icon(_visible ? Icons.visibility_off : Icons.visibility),
          label: Text(_visible ? '隐藏' : '显示'),
        ),
      ],
    );
  }

  /// AnimatedAlign 示例
  Widget _buildAnimatedAlignDemo() {
    return Column(
      children: [
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: AnimatedAlign(
            alignment: _alignment,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.star, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _alignButton('左', Alignment.centerLeft),
            _alignButton('中', Alignment.center),
            _alignButton('右', Alignment.centerRight),
          ],
        ),
      ],
    );
  }

  Widget _alignButton(String label, Alignment alignment) {
    final isSelected = _alignment == alignment;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _alignment = alignment),
    );
  }

  /// AnimatedRotation 示例
  Widget _buildAnimatedRotationDemo() {
    return Column(
      children: [
        AnimatedRotation(
          turns: _rotation,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.refresh, color: Colors.white, size: 40),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => setState(() => _rotation -= 0.25),
              child: const Text('逆时针 90'),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () => setState(() => _rotation += 0.25),
              child: const Text('顺时针 90'),
            ),
          ],
        ),
      ],
    );
  }

  /// TweenAnimationBuilder 示例
  Widget _buildTweenAnimationDemo() {
    return Column(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: _targetValue),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Column(
              children: [
                // 进度条
                Container(
                  width: double.infinity,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: value.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Colors.blue, Colors.purple]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(value * 100).toInt()}%',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(onPressed: () => setState(() => _targetValue = 0), child: const Text('0%')),
            OutlinedButton(onPressed: () => setState(() => _targetValue = 0.25), child: const Text('25%')),
            OutlinedButton(onPressed: () => setState(() => _targetValue = 0.5), child: const Text('50%')),
            OutlinedButton(onPressed: () => setState(() => _targetValue = 0.75), child: const Text('75%')),
            OutlinedButton(onPressed: () => setState(() => _targetValue = 1.0), child: const Text('100%')),
          ],
        ),
      ],
    );
  }
}
