import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// CustomPaint 演示页面
/// 展示自定义绘制（对应 iOS Shape/Path）
class CustomPaintDemoPage extends StatefulWidget {
  const CustomPaintDemoPage({super.key});

  @override
  State<CustomPaintDemoPage> createState() => _CustomPaintDemoPageState();
}

class _CustomPaintDemoPageState extends State<CustomPaintDemoPage> {
  // 用户点击位置的圆点列表
  final List<Offset> _dots = [];
  Color _dotColor = Colors.blue;

  // 当前展示的图形类型
  int _currentShape = 0;
  final List<String> _shapeNames = ['圆形', '矩形', '路径', '文本', '渐变'];

  void _clearDots() {
    setState(() => _dots.clear());
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'CustomPaint 自定义绘制',
      subtitle: '使用 CustomPainter 绘制图形和路径（对应 iOS Shape/Path）',
      conceptItems: const [
        'CustomPaint：承载自定义绘制的 Widget',
        'CustomPainter：实现 paint() 方法进行绘制',
        'Canvas：绘制画布，提供 drawCircle、drawRect、drawPath 等方法',
        'Paint：画笔配置，颜色、样式（fill/stroke）、宽度等',
        'Path：定义自由路径，moveTo、lineTo、quadraticBezierTo 等',
      ],
      children: [
        // === 基础图形 ===
        const SectionTitle('基础图形绘制'),
        // 图形类型选择
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _shapeNames.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              return ChoiceChip(
                label: Text(_shapeNames[index]),
                selected: _currentShape == index,
                onSelected: (_) => setState(() => _currentShape = index),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        _buildCard(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 200,
              color: Colors.grey[50],
              child: CustomPaint(
                size: const Size(double.infinity, 200),
                painter: _ShapePainter(shapeType: _currentShape),
              ),
            ),
          ),
        ),

        // === 可交互绘制 ===
        const SectionTitle('点击绘制圆点'),
        _buildCard(
          child: Column(
            children: [
              // 颜色选择
              Row(
                children: [
                  const Text('画笔颜色：', style: TextStyle(fontSize: 13)),
                  ...[Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple].map(
                    (color) => GestureDetector(
                      onTap: () => setState(() => _dotColor = color),
                      child: Container(
                        width: 28,
                        height: 28,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _dotColor == color ? Colors.black : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _clearDots,
                    child: const Text('清除'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 可交互画布
              GestureDetector(
                onTapDown: (details) {
                  setState(() {
                    _dots.add(details.localPosition);
                  });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 250,
                    color: Colors.white,
                    child: CustomPaint(
                      size: const Size(double.infinity, 250),
                      painter: _DotPainter(dots: _dots, color: _dotColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text('已绘制 ${_dots.length} 个点  |  点击画布绘制',
                  style: TextStyle(fontSize: 11, color: Colors.grey[500])),
            ],
          ),
        ),

        // === 复杂路径示例 ===
        const SectionTitle('复杂路径绘制'),
        _buildCard(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 200,
              color: Colors.grey[50],
              child: CustomPaint(
                size: const Size(double.infinity, 200),
                painter: _WavePainter(),
              ),
            ),
          ),
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

/// 基础图形绘制器
class _ShapePainter extends CustomPainter {
  final int shapeType;

  _ShapePainter({required this.shapeType});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    switch (shapeType) {
      case 0: // 圆形
        _drawCircles(canvas, size, center);
      case 1: // 矩形
        _drawRectangles(canvas, size, center);
      case 2: // 路径
        _drawPath(canvas, size);
      case 3: // 文本
        _drawText(canvas, size, center);
      case 4: // 渐变
        _drawGradient(canvas, size, center);
    }
  }

  void _drawCircles(Canvas canvas, Size size, Offset center) {
    // 填充圆
    final fillPaint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 60, fillPaint);

    // 描边圆
    final strokePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, 60, strokePaint);

    // 小圆
    for (int i = 0; i < 6; i++) {
      final angle = i * pi / 3;
      final offset = Offset(
        center.dx + 80 * cos(angle),
        center.dy + 80 * sin(angle),
      );
      canvas.drawCircle(offset, 15, Paint()..color = Colors.blue.withValues(alpha: 0.5));
    }
  }

  void _drawRectangles(Canvas canvas, Size size, Offset center) {
    // 普通矩形
    final rect = Rect.fromCenter(center: center, width: 120, height: 80);
    canvas.drawRect(rect, Paint()..color = Colors.green.withValues(alpha: 0.3));
    canvas.drawRect(
        rect,
        Paint()
          ..color = Colors.green
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);

    // 圆角矩形
    final rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx, center.dy - 60), width: 150, height: 40),
      const Radius.circular(20),
    );
    canvas.drawRRect(rrect, Paint()..color = Colors.orange.withValues(alpha: 0.5));

    // 旋转矩形
    canvas.save();
    canvas.translate(center.dx, center.dy + 50);
    canvas.rotate(pi / 6);
    canvas.drawRect(
      const Rect.fromLTWH(-30, -15, 60, 30),
      Paint()..color = Colors.purple.withValues(alpha: 0.4),
    );
    canvas.restore();
  }

  void _drawPath(Canvas canvas, Size size) {
    // 绘制星形
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    const outerRadius = 70.0;
    const innerRadius = 30.0;

    for (int i = 0; i < 5; i++) {
      final outerAngle = (i * 72 - 90) * pi / 180;
      final innerAngle = ((i * 72 + 36) - 90) * pi / 180;

      final outerPoint = Offset(
        center.dx + outerRadius * cos(outerAngle),
        center.dy + outerRadius * sin(outerAngle),
      );
      final innerPoint = Offset(
        center.dx + innerRadius * cos(innerAngle),
        center.dy + innerRadius * sin(innerAngle),
      );

      if (i == 0) {
        path.moveTo(outerPoint.dx, outerPoint.dy);
      } else {
        path.lineTo(outerPoint.dx, outerPoint.dy);
      }
      path.lineTo(innerPoint.dx, innerPoint.dy);
    }
    path.close();

    canvas.drawPath(path, Paint()..color = Colors.amber.withValues(alpha: 0.4));
    canvas.drawPath(
        path,
        Paint()
          ..color = Colors.amber[700]!
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
  }

  void _drawText(Canvas canvas, Size size, Offset center) {
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Flutter',
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - 40),
    );

    final subTextPainter = TextPainter(
      text: TextSpan(
        text: 'CustomPaint 绘制文本',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    subTextPainter.layout();
    subTextPainter.paint(
      canvas,
      Offset(center.dx - subTextPainter.width / 2, center.dy + 10),
    );
  }

  void _drawGradient(Canvas canvas, Size size, Offset center) {
    // 渐变圆形
    final rect = Rect.fromCircle(center: center, radius: 70);
    final gradient = RadialGradient(
      colors: [Colors.blue, Colors.purple, Colors.pink],
    );
    canvas.drawCircle(
      center,
      70,
      Paint()..shader = gradient.createShader(rect),
    );

    // 渐变文本背景
    final textRect = Rect.fromCenter(center: Offset(center.dx, center.dy + 85), width: 200, height: 24);
    final linearGradient = LinearGradient(
      colors: [Colors.orange, Colors.red],
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(textRect, const Radius.circular(12)),
      Paint()..shader = linearGradient.createShader(textRect),
    );
  }

  @override
  bool shouldRepaint(covariant _ShapePainter oldDelegate) => oldDelegate.shapeType != shapeType;
}

/// 圆点绘制器（可交互）
class _DotPainter extends CustomPainter {
  final List<Offset> dots;
  final Color color;

  _DotPainter({required this.dots, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制背景网格
    final gridPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.1)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 绘制圆点
    for (int i = 0; i < dots.length; i++) {
      final dot = dots[i];
      // 外圈
      canvas.drawCircle(
        dot,
        14,
        Paint()..color = color.withValues(alpha: 0.2),
      );
      // 内圈
      canvas.drawCircle(
        dot,
        8,
        Paint()..color = color.withValues(alpha: 0.6),
      );
      // 中心点
      canvas.drawCircle(
        dot,
        3,
        Paint()..color = color,
      );

      // 连线
      if (i > 0) {
        canvas.drawLine(
          dots[i - 1],
          dots[i],
          Paint()
            ..color = color.withValues(alpha: 0.3)
            ..strokeWidth = 1,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotPainter oldDelegate) => true;
}

/// 波浪绘制器
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 绘制多层波浪
    _drawWave(canvas, size, Colors.blue.withValues(alpha: 0.3), 0.6, 20, 0);
    _drawWave(canvas, size, Colors.blue.withValues(alpha: 0.2), 0.65, 25, 1);
    _drawWave(canvas, size, Colors.blue.withValues(alpha: 0.15), 0.7, 15, 2);
  }

  void _drawWave(Canvas canvas, Size size, Color color, double heightFactor, double amplitude, double phase) {
    final path = Path();
    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x += 1) {
      final y = size.height * heightFactor +
          amplitude * sin((x / size.width * 4 * pi) + phase);
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
