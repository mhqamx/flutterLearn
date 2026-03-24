import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// 手势识别 Demo
/// 演示 GestureDetector、Draggable + DragTarget、缩放手势、手势竞争
class GestureDemoPage extends StatefulWidget {
  const GestureDemoPage({super.key});

  @override
  State<GestureDemoPage> createState() => _GestureDemoPageState();
}

class _GestureDemoPageState extends State<GestureDemoPage> {
  // GestureDetector 状态
  String _gestureResult = '请尝试各种手势操作';
  Color _tapColor = Colors.blue;

  // 拖拽位置
  Offset _dragPosition = const Offset(100, 50);
  Color _dragColor = Colors.red;

  // 缩放状态
  double _scale = 1.0;
  double _baseScale = 1.0;

  // DragTarget 接受状态
  bool _accepted = false;

  // 可拖拽方块数据
  final List<_DraggableItem> _draggableItems = [
    _DraggableItem(color: Colors.red, label: '红'),
    _DraggableItem(color: Colors.green, label: '绿'),
    _DraggableItem(color: Colors.blue, label: '蓝'),
  ];

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: '手势识别',
      subtitle: '演示 Flutter 中的手势检测、拖拽、缩放和手势竞争',
      conceptItems: const [
        'GestureDetector：通用手势检测器，支持 tap/doubleTap/longPress/pan/scale',
        'Draggable：可拖拽组件，拖拽时显示 feedback，原位置显示 childWhenDragging',
        'DragTarget：拖拽目标区域，接收 Draggable 放下的数据',
        'GestureDetector.onScaleUpdate：捏合缩放手势，通过 details.scale 获取缩放比例',
        '手势竞争：多个 GestureDetector 嵌套时，胜出的手势获得事件',
      ],
      children: [
        const SectionTitle('1. GestureDetector（tap/doubleTap/longPress）'),
        _buildGestureDetectorDemo(),
        const SizedBox(height: 16),

        const SectionTitle('2. 拖拽移动（Pan 手势）'),
        _buildPanDragDemo(),
        const SizedBox(height: 16),

        const SectionTitle('3. Draggable + DragTarget'),
        _buildDraggableDemo(),
        const SizedBox(height: 16),

        const SectionTitle('4. 捏合缩放手势'),
        _buildScaleDemo(),
      ],
    );
  }

  /// GestureDetector 示例
  Widget _buildGestureDetectorDemo() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _gestureResult = '单击 Tap';
              _tapColor = Colors.blue;
            });
          },
          onDoubleTap: () {
            setState(() {
              _gestureResult = '双击 DoubleTap';
              _tapColor = Colors.green;
            });
          },
          onLongPress: () {
            setState(() {
              _gestureResult = '长按 LongPress';
              _tapColor = Colors.orange;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: _tapColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _tapColor, width: 2),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.touch_app, color: _tapColor, size: 32),
                  const SizedBox(height: 4),
                  const Text('尝试: 单击 / 双击 / 长按', style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '识别到: $_gestureResult',
            style: TextStyle(fontWeight: FontWeight.bold, color: _tapColor),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  /// Pan 拖拽示例
  Widget _buildPanDragDemo() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 8,
            left: 8,
            child: Text('拖拽移动方块', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
          Positioned(
            left: _dragPosition.dx,
            top: _dragPosition.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _dragPosition = Offset(
                    (_dragPosition.dx + details.delta.dx).clamp(0, 280),
                    (_dragPosition.dy + details.delta.dy).clamp(0, 140),
                  );
                });
              },
              onPanEnd: (_) {
                // 随机改变颜色
                setState(() {
                  _dragColor = Colors.primaries[(_dragColor.hashCode + 3) % Colors.primaries.length];
                });
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _dragColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: _dragColor.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 4)),
                  ],
                ),
                child: const Icon(Icons.open_with, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Draggable + DragTarget 示例
  Widget _buildDraggableDemo() {
    return Column(
      children: [
        // 可拖拽方块
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _draggableItems.map((item) {
            return Draggable<_DraggableItem>(
              data: item,
              // 拖拽时的样子
              feedback: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: item.color.withValues(alpha: 0.4), blurRadius: 12),
                  ],
                ),
                child: Center(
                  child: Text(item.label, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, decoration: TextDecoration.none)),
                ),
              ),
              // 拖拽时原位置显示
              childWhenDragging: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey, style: BorderStyle.solid),
                ),
              ),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(item.label, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        // 拖拽目标区域
        DragTarget<_DraggableItem>(
          onAcceptWithDetails: (details) {
            setState(() => _accepted = true);
            // 短暂显示后重置
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) setState(() => _accepted = false);
            });
          },
          builder: (context, candidateData, rejectedData) {
            final isHovering = candidateData.isNotEmpty;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: _accepted
                    ? Colors.green.withValues(alpha: 0.2)
                    : isHovering
                        ? Colors.blue.withValues(alpha: 0.2)
                        : Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _accepted ? Colors.green : (isHovering ? Colors.blue : Colors.grey),
                  width: 2,
                  style: isHovering ? BorderStyle.solid : BorderStyle.solid,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _accepted ? Icons.check_circle : Icons.add_circle_outline,
                      size: 32,
                      color: _accepted ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _accepted ? '接收成功！' : '将方块拖到这里',
                      style: TextStyle(color: _accepted ? Colors.green : Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// 缩放手势示例
  Widget _buildScaleDemo() {
    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: GestureDetector(
            onScaleStart: (_) => _baseScale = _scale,
            onScaleUpdate: (details) {
              setState(() {
                _scale = (_baseScale * details.scale).clamp(0.5, 3.0);
              });
            },
            child: Center(
              child: Transform.scale(
                scale: _scale,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.purple, Colors.blue],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text('捏合缩放', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('缩放比例: ${_scale.toStringAsFixed(2)}x',
                style: TextStyle(color: Colors.grey[600])),
            const SizedBox(width: 12),
            TextButton(
              onPressed: () => setState(() => _scale = 1.0),
              child: const Text('重置'),
            ),
          ],
        ),
      ],
    );
  }
}

/// 可拖拽项目数据
class _DraggableItem {
  final Color color;
  final String label;

  const _DraggableItem({required this.color, required this.label});
}
