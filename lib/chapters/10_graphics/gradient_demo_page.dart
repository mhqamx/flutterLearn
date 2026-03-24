import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

class GradientDemoPage extends StatefulWidget {
  const GradientDemoPage({super.key});

  @override
  State<GradientDemoPage> createState() => _GradientDemoPageState();
}

class _GradientDemoPageState extends State<GradientDemoPage> {
  double _angle = 0.0;
  double _radius = 0.5;
  int _selectedType = 0;

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Gradient 渐变',
      subtitle: '线性渐变、径向渐变、扫描渐变的使用',
      conceptItems: const [
        'LinearGradient：线性渐变，通过 begin/end 控制方向',
        'RadialGradient：径向渐变，通过 center/radius 控制',
        'SweepGradient：扫描渐变，围绕中心点旋转',
        'BoxDecoration：通过 gradient 属性应用渐变',
        'ShaderMask：将渐变作为遮罩应用到子组件',
      ],
      children: [
        const SectionTitle('渐变类型选择'),
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(value: 0, label: Text('线性')),
            ButtonSegment(value: 1, label: Text('径向')),
            ButtonSegment(value: 2, label: Text('扫描')),
          ],
          selected: {_selectedType},
          onSelectionChanged: (v) => setState(() => _selectedType = v.first),
        ),
        const SizedBox(height: 16),

        // 渐变展示
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: _buildGradient(),
          ),
          child: Center(
            child: Text(
              ['LinearGradient', 'RadialGradient', 'SweepGradient'][_selectedType],
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black54)]),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 参数控制
        if (_selectedType == 0) ...[
          Text('角度: ${_angle.toStringAsFixed(0)}°'),
          Slider(
            value: _angle,
            min: 0,
            max: 360,
            onChanged: (v) => setState(() => _angle = v),
          ),
        ],
        if (_selectedType == 1) ...[
          Text('半径: ${_radius.toStringAsFixed(2)}'),
          Slider(
            value: _radius,
            min: 0.1,
            max: 1.0,
            onChanged: (v) => setState(() => _radius = v),
          ),
        ],

        const SectionTitle('渐变文字（ShaderMask）'),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.purple, Colors.blue, Colors.cyan],
          ).createShader(bounds),
          child: const Text('Flutter 渐变文字',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
        ),

        const SectionTitle('多色渐变卡片'),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _gradientCard('日出', [Colors.orange, Colors.red, Colors.pink]),
            _gradientCard('海洋', [Colors.blue, Colors.cyan, Colors.teal]),
            _gradientCard('森林', [Colors.green, Colors.teal, Colors.cyan]),
            _gradientCard('夕阳', [Colors.deepPurple, Colors.purple, Colors.pink]),
          ],
        ),
      ],
    );
  }

  Gradient _buildGradient() {
    const colors = [Colors.blue, Colors.purple, Colors.pink, Colors.orange];
    switch (_selectedType) {
      case 0:
        final rad = _angle * 3.14159 / 180;
        return LinearGradient(
          begin: Alignment(-1.0 * _cos(rad), -1.0 * _sin(rad)),
          end: Alignment(_cos(rad), _sin(rad)),
          colors: colors,
        );
      case 1:
        return RadialGradient(colors: colors, radius: _radius);
      case 2:
        return SweepGradient(colors: [...colors, colors.first]);
      default:
        return const LinearGradient(colors: [Colors.blue, Colors.purple]);
    }
  }

  double _cos(double rad) => rad == 0 ? 1.0 : (rad / rad.abs()) * (1.0 - (rad % 3.14159) / 3.14159).abs();
  double _sin(double rad) => _cos(rad - 1.5708);

  Widget _gradientCard(String label, List<Color> colors) {
    return Container(
      width: 150,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(colors: colors),
      ),
      child: Center(
        child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}
