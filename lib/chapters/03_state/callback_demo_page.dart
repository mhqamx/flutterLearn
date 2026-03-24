import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// 回调函数演示页面
/// 对应 SwiftUI 的 @Binding，展示父子组件通过回调传递状态
class CallbackDemoPage extends StatefulWidget {
  const CallbackDemoPage({super.key});

  @override
  State<CallbackDemoPage> createState() => _CallbackDemoPageState();
}

class _CallbackDemoPageState extends State<CallbackDemoPage> {
  /// 评分值（父组件持有状态）
  int _rating = 3;

  /// 选中的颜色
  Color _selectedColor = Colors.blue;

  /// 计数值
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: '回调函数传递状态',
      subtitle: '对应 SwiftUI 的 @Binding，父组件持有状态，子组件通过回调修改',
      conceptItems: const [
        'ValueChanged<T>：接收一个 T 类型参数的回调函数 typedef',
        'VoidCallback：无参数的回调函数 typedef',
        '单向数据流：数据从父组件流向子组件，事件从子组件回调父组件',
        '状态提升：将共享状态提升到最近的共同祖先组件',
        '组件解耦：子组件不持有状态，只负责展示和发出事件',
      ],
      children: [
        const SectionTitle('自定义评分组件'),
        _buildCard(
          child: Column(
            children: [
              Text('父组件持有评分: $_rating',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              // 子组件通过回调修改父组件的状态
              _StarRating(
                rating: _rating,
                onRatingChanged: (newRating) {
                  setState(() => _rating = newRating);
                },
              ),
              const SizedBox(height: 8),
              Text('评分等级: ${_ratingText(_rating)}',
                  style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),

        const SectionTitle('颜色选择器组件'),
        _buildCard(
          child: Column(
            children: [
              // 预览选中颜色
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _selectedColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _selectedColor.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.palette, color: Colors.white, size: 36),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '选中颜色: #${_selectedColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
              ),
              const SizedBox(height: 12),
              // 子组件：颜色选择器
              _ColorPicker(
                selectedColor: _selectedColor,
                onColorChanged: (color) {
                  setState(() => _selectedColor = color);
                },
              ),
            ],
          ),
        ),

        const SectionTitle('计数器子组件 (VoidCallback)'),
        _buildCard(
          child: Column(
            children: [
              Text('父组件的计数: $_count',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              // 子组件：只有按钮，通过 VoidCallback 通知父组件
              _CounterControls(
                count: _count,
                onIncrement: () => setState(() => _count++),
                onDecrement: () => setState(() {
                  if (_count > 0) _count--;
                }),
                onReset: () => setState(() => _count = 0),
              ),
            ],
          ),
        ),

        const SectionTitle('组合使用：图书评价卡片'),
        _buildCard(
          child: _BookReviewCard(
            title: 'Flutter 实战',
            rating: _rating,
            color: _selectedColor,
            onRatingChanged: (r) => setState(() => _rating = r),
            onColorChanged: (c) => setState(() => _selectedColor = c),
          ),
        ),
      ],
    );
  }

  String _ratingText(int rating) {
    const texts = ['未评分', '很差', '较差', '一般', '不错', '非常好'];
    return rating >= 0 && rating <= 5 ? texts[rating] : '';
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

// ==================== 子组件 ====================

/// 自定义评分组件
/// 通过 [ValueChanged] 回调通知父组件评分变化
class _StarRating extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onRatingChanged;

  const _StarRating({
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () => onRatingChanged(index + 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              index < rating ? Icons.star : Icons.star_border,
              color: index < rating ? Colors.amber : Colors.grey[400],
              size: 36,
            ),
          ),
        );
      }),
    );
  }
}

/// 颜色选择器组件
/// 通过 [ValueChanged] 回调通知父组件颜色变化
class _ColorPicker extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorChanged;

  const _ColorPicker({
    required this.selectedColor,
    required this.onColorChanged,
  });

  static const _colors = [
    Colors.red, Colors.pink, Colors.purple, Colors.deepPurple,
    Colors.indigo, Colors.blue, Colors.teal, Colors.green,
    Colors.orange, Colors.brown,
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _colors.map((color) {
        final isSelected = color == selectedColor;
        return GestureDetector(
          onTap: () => onColorChanged(color),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: Colors.black, width: 3)
                  : null,
              boxShadow: isSelected
                  ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 8)]
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : null,
          ),
        );
      }).toList(),
    );
  }
}

/// 计数器控制组件
/// 使用 VoidCallback 回调
class _CounterControls extends StatelessWidget {
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onReset;

  const _CounterControls({
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: count > 0 ? onDecrement : null,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
          child: const Icon(Icons.remove, color: Colors.white),
        ),
        const SizedBox(width: 12),
        OutlinedButton(
          onPressed: onReset,
          child: const Text('重置'),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: onIncrement,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green[400]),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ],
    );
  }
}

/// 图书评价卡片（组合使用多个回调）
class _BookReviewCard extends StatelessWidget {
  final String title;
  final int rating;
  final Color color;
  final ValueChanged<int> onRatingChanged;
  final ValueChanged<Color> onColorChanged;

  const _BookReviewCard({
    required this.title,
    required this.rating,
    required this.color,
    required this.onRatingChanged,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.book, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    _StarRating(
                      rating: rating,
                      onRatingChanged: onRatingChanged,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('选择封面主题色：', style: TextStyle(fontSize: 13)),
          const SizedBox(height: 8),
          _ColorPicker(
            selectedColor: color,
            onColorChanged: onColorChanged,
          ),
        ],
      ),
    );
  }
}
