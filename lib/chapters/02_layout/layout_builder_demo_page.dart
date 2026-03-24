import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// LayoutBuilder / MediaQuery 演示页面
/// 对应 SwiftUI 的 GeometryReader
class LayoutBuilderDemoPage extends StatelessWidget {
  const LayoutBuilderDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return DemoScaffold(
      title: 'LayoutBuilder',
      subtitle: '对应 SwiftUI 的 GeometryReader，获取布局约束和屏幕信息',
      conceptItems: const [
        'LayoutBuilder：在构建时获取父组件传递的约束信息',
        'MediaQuery：获取屏幕尺寸、方向、安全区域等设备信息',
        'BoxConstraints：描述宽高的最小和最大约束',
        'FractionallySizedBox：按比例设定子组件的大小',
        'AspectRatio：按宽高比约束子组件',
      ],
      children: [
        const SectionTitle('MediaQuery 屏幕信息'),
        _buildCard(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow('屏幕尺寸',
                    '${mediaQuery.size.width.toStringAsFixed(1)} x ${mediaQuery.size.height.toStringAsFixed(1)}'),
                _infoRow('设备像素比', mediaQuery.devicePixelRatio.toStringAsFixed(2)),
                _infoRow('方向', mediaQuery.orientation == Orientation.portrait ? '竖屏' : '横屏'),
                _infoRow('顶部安全区域', '${mediaQuery.padding.top}'),
                _infoRow('底部安全区域', '${mediaQuery.padding.bottom}'),
                _infoRow('文字缩放', mediaQuery.textScaler.scale(1.0).toStringAsFixed(2)),
                _infoRow('平台亮度',
                    mediaQuery.platformBrightness == Brightness.dark ? '深色模式' : '浅色模式'),
              ],
            ),
          ),
        ),

        const SectionTitle('LayoutBuilder 获取约束'),
        _buildCard(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('当前 LayoutBuilder 约束：',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _infoRow('maxWidth', constraints.maxWidth.toStringAsFixed(1)),
                    _infoRow('maxHeight',
                        constraints.maxHeight == double.infinity
                            ? 'infinity（无限高）'
                            : constraints.maxHeight.toStringAsFixed(1)),
                    _infoRow('minWidth', constraints.minWidth.toStringAsFixed(1)),
                    _infoRow('minHeight', constraints.minHeight.toStringAsFixed(1)),
                  ],
                ),
              );
            },
          ),
        ),

        const SectionTitle('响应式布局（根据宽度调整）'),
        _buildCard(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // 根据可用宽度决定列数
              final width = constraints.maxWidth;
              int crossAxisCount;
              String label;
              if (width > 600) {
                crossAxisCount = 4;
                label = '宽屏 (>600) → 4列';
              } else if (width > 400) {
                crossAxisCount = 3;
                label = '中屏 (>400) → 3列';
              } else {
                crossAxisCount = 2;
                label = '窄屏 (<=400) → 2列';
              }

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('宽度: ${width.toStringAsFixed(0)}px → $label',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1.5,
                    children: List.generate(8, (index) {
                      final colors = [
                        Colors.red, Colors.blue, Colors.green, Colors.orange,
                        Colors.purple, Colors.teal, Colors.pink, Colors.indigo,
                      ];
                      return Container(
                        decoration: BoxDecoration(
                          color: colors[index].withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text('${index + 1}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),

        const SectionTitle('FractionallySizedBox 比例大小'),
        _buildCard(
          child: Column(
            children: [
              const Text('宽度分别为父组件的 100%、75%、50%、25%：',
                  style: TextStyle(fontSize: 13)),
              const SizedBox(height: 12),
              _fractionBar(1.0, Colors.blue, '100%'),
              const SizedBox(height: 4),
              _fractionBar(0.75, Colors.green, '75%'),
              const SizedBox(height: 4),
              _fractionBar(0.5, Colors.orange, '50%'),
              const SizedBox(height: 4),
              _fractionBar(0.25, Colors.red, '25%'),
            ],
          ),
        ),

        const SectionTitle('AspectRatio 宽高比'),
        _buildCard(
          child: Column(
            children: [
              const Text('AspectRatio(16:9)：', style: TextStyle(fontSize: 13)),
              const SizedBox(height: 8),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[300]!, Colors.purple[300]!],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text('16 : 9',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text('AspectRatio(1:1 正方形)：', style: TextStyle(fontSize: 13)),
              const SizedBox(height: 8),
              FractionallySizedBox(
                widthFactor: 0.5,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.teal[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('1 : 1',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 信息行
  static Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace')),
        ],
      ),
    );
  }

  /// 比例条
  static Widget _fractionBar(double fraction, Color color, String label) {
    return FractionallySizedBox(
      widthFactor: fraction,
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 12)),
        ),
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
