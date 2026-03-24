import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// Image Widget 演示页面
/// 展示 Flutter 中图片、图标和头像的各种用法
class ImageDemoPage extends StatefulWidget {
  const ImageDemoPage({super.key});

  @override
  State<ImageDemoPage> createState() => _ImageDemoPageState();
}

class _ImageDemoPageState extends State<ImageDemoPage> {
  /// 当前选中的 BoxFit 模式
  BoxFit _selectedFit = BoxFit.contain;

  /// 图标大小
  double _iconSize = 40;

  /// 图标颜色索引
  int _colorIndex = 0;

  final List<Color> _colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.teal,
  ];

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Image 图片',
      subtitle: '展示 Image、Icon、CircleAvatar 等图片相关组件',
      conceptItems: const [
        'FlutterLogo：Flutter 内置的 Logo 组件，适合做占位图',
        'Icon：Material 图标，支持颜色和大小自定义',
        'BoxFit：控制图片在容器中的填充方式',
        'CircleAvatar：圆形头像组件，常用于用户头像',
        'Image.network：加载网络图片，支持占位和错误处理',
      ],
      children: [
        const SectionTitle('FlutterLogo（替代 AssetImage）'),
        _buildCard(
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  FlutterLogo(size: 40),
                  SizedBox(height: 4),
                  Text('40', style: TextStyle(fontSize: 12)),
                ],
              ),
              Column(
                children: [
                  FlutterLogo(size: 60),
                  SizedBox(height: 4),
                  Text('60', style: TextStyle(fontSize: 12)),
                ],
              ),
              Column(
                children: [
                  FlutterLogo(size: 80),
                  SizedBox(height: 4),
                  Text('80', style: TextStyle(fontSize: 12)),
                ],
              ),
              Column(
                children: [
                  FlutterLogo(size: 100, style: FlutterLogoStyle.stacked),
                  SizedBox(height: 4),
                  Text('stacked', style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),

        const SectionTitle('Icon 图标'),
        _buildCard(
          child: const Wrap(
            spacing: 20,
            runSpacing: 16,
            children: [
              _IconLabel(icon: Icons.home, label: 'home'),
              _IconLabel(icon: Icons.search, label: 'search'),
              _IconLabel(icon: Icons.favorite, label: 'favorite'),
              _IconLabel(icon: Icons.settings, label: 'settings'),
              _IconLabel(icon: Icons.person, label: 'person'),
              _IconLabel(icon: Icons.star, label: 'star'),
              _IconLabel(icon: Icons.bookmark, label: 'bookmark'),
              _IconLabel(icon: Icons.notifications, label: 'notify'),
            ],
          ),
        ),

        const SectionTitle('Icon 颜色和大小（可交互）'),
        _buildCard(
          child: Column(
            children: [
              Icon(Icons.flutter_dash, size: _iconSize, color: _colors[_colorIndex]),
              const SizedBox(height: 12),
              Text('大小: ${_iconSize.toInt()}  颜色索引: $_colorIndex'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _iconSize = (_iconSize + 10).clamp(20, 100);
                    }),
                    child: const Text('增大'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _iconSize = (_iconSize - 10).clamp(20, 100);
                    }),
                    child: const Text('减小'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _colorIndex = (_colorIndex + 1) % _colors.length;
                    }),
                    child: const Text('换色'),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SectionTitle('BoxFit 各模式'),
        _buildCard(
          child: Column(
            children: [
              Container(
                width: 200,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FittedBox(
                  fit: _selectedFit,
                  child: const FlutterLogo(size: 200),
                ),
              ),
              const SizedBox(height: 12),
              Text('当前模式: ${_selectedFit.toString().split('.').last}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: BoxFit.values.map((fit) {
                  final isSelected = fit == _selectedFit;
                  return ChoiceChip(
                    label: Text(fit.toString().split('.').last,
                        style: const TextStyle(fontSize: 12)),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedFit = fit),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        const SectionTitle('圆形头像 CircleAvatar'),
        _buildCard(
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue,
                    child: Text('A', style: TextStyle(color: Colors.white, fontSize: 24)),
                  ),
                  SizedBox(height: 4),
                  Text('文字头像', style: TextStyle(fontSize: 12)),
                ],
              ),
              Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  SizedBox(height: 4),
                  Text('图标头像', style: TextStyle(fontSize: 12)),
                ],
              ),
              Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: FlutterLogo(size: 36),
                  ),
                  SizedBox(height: 4),
                  Text('Logo头像', style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),

        const SectionTitle('网络图片占位（模拟）'),
        _buildCard(
          child: Column(
            children: [
              const Text('Image.network 加载失败时显示 errorBuilder：',
                  style: TextStyle(fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 12),
              Container(
                width: 200,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.network(
                  'https://invalid-url-for-demo.example/image.png',
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image, size: 40, color: Colors.grey),
                          SizedBox(height: 4),
                          Text('加载失败', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    );
                  },
                ),
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

/// 图标+标签组合组件
class _IconLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const _IconLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}
