import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// Slider 演示页面
/// 展示 Slider 和 RangeSlider 的各种用法
class SliderDemoPage extends StatefulWidget {
  const SliderDemoPage({super.key});

  @override
  State<SliderDemoPage> createState() => _SliderDemoPageState();
}

class _SliderDemoPageState extends State<SliderDemoPage> {
  /// 基础 Slider 值
  double _basicValue = 50;

  /// 带标签 Slider 值
  double _labelValue = 3;

  /// 自定义颜色 Slider 值
  double _colorValue = 0.5;

  /// RangeSlider 值
  RangeValues _rangeValues = const RangeValues(20, 80);

  /// 字体大小 Slider
  double _fontSize = 16;

  /// 透明度 Slider
  double _opacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Slider 滑块',
      subtitle: '展示 Slider 和 RangeSlider 的各种用法和实时数值显示',
      conceptItems: const [
        'Slider：单值滑动选择器，通过 onChanged 回调更新值',
        'RangeSlider：范围滑动选择器，可选择最小和最大值',
        'divisions：将滑块分为离散的段',
        'label：滑动时显示的气泡标签',
        'SliderTheme：自定义滑块的外观主题',
      ],
      children: [
        const SectionTitle('基础 Slider'),
        _buildCard(
          child: Column(
            children: [
              Text('当前值: ${_basicValue.toInt()}',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              Slider(
                value: _basicValue,
                min: 0,
                max: 100,
                onChanged: (value) => setState(() => _basicValue = value),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('0'), Text('100')],
              ),
            ],
          ),
        ),

        const SectionTitle('带标签的 Slider（离散值）'),
        _buildCard(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return Icon(
                    Icons.star,
                    size: 32,
                    color: i < _labelValue.toInt()
                        ? Colors.amber
                        : Colors.grey[300],
                  );
                }),
              ),
              const SizedBox(height: 4),
              Text('评分: ${_labelValue.toInt()} 星',
                  style: const TextStyle(fontSize: 16)),
              Slider(
                value: _labelValue,
                min: 0,
                max: 5,
                divisions: 5,
                label: '${_labelValue.toInt()} 星',
                onChanged: (value) => setState(() => _labelValue = value),
              ),
            ],
          ),
        ),

        const SectionTitle('RangeSlider 范围选择'),
        _buildCard(
          child: Column(
            children: [
              Text(
                '价格范围: ¥${_rangeValues.start.toInt()} - ¥${_rangeValues.end.toInt()}',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              RangeSlider(
                values: _rangeValues,
                min: 0,
                max: 200,
                divisions: 20,
                labels: RangeLabels(
                  '¥${_rangeValues.start.toInt()}',
                  '¥${_rangeValues.end.toInt()}',
                ),
                onChanged: (values) => setState(() => _rangeValues = values),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('¥0'), Text('¥200')],
              ),
            ],
          ),
        ),

        const SectionTitle('自定义颜色 Slider'),
        _buildCard(
          child: Column(
            children: [
              Text('进度: ${(_colorValue * 100).toInt()}%',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.green,
                  inactiveTrackColor: Colors.green[100],
                  thumbColor: Colors.green[700],
                  overlayColor: Colors.green.withValues(alpha: 0.2),
                  trackHeight: 8,
                ),
                child: Slider(
                  value: _colorValue,
                  onChanged: (value) => setState(() => _colorValue = value),
                ),
              ),
              const SizedBox(height: 8),
              // 进度条可视化
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _colorValue,
                  minHeight: 12,
                  backgroundColor: Colors.green[100],
                  valueColor: AlwaysStoppedAnimation(Colors.green[600]!),
                ),
              ),
            ],
          ),
        ),

        const SectionTitle('字体大小调节（实时预览）'),
        _buildCard(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Flutter 是一个优秀的跨平台框架',
                  style: TextStyle(fontSize: _fontSize),
                ),
              ),
              const SizedBox(height: 8),
              Text('字体大小: ${_fontSize.toInt()}px'),
              Slider(
                value: _fontSize,
                min: 10,
                max: 36,
                divisions: 26,
                label: '${_fontSize.toInt()}px',
                onChanged: (value) => setState(() => _fontSize = value),
              ),
            ],
          ),
        ),

        const SectionTitle('透明度调节（实时预览）'),
        _buildCard(
          child: Column(
            children: [
              Opacity(
                opacity: _opacity,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: FlutterLogo(size: 60),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text('透明度: ${(_opacity * 100).toInt()}%'),
              Slider(
                value: _opacity,
                min: 0,
                max: 1,
                divisions: 20,
                label: '${(_opacity * 100).toInt()}%',
                onChanged: (value) => setState(() => _opacity = value),
              ),
            ],
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
