import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// 底部弹窗 Demo
/// 演示 showModalBottomSheet、DraggableScrollableSheet、自定义内容
class BottomSheetDemoPage extends StatefulWidget {
  const BottomSheetDemoPage({super.key});

  @override
  State<BottomSheetDemoPage> createState() => _BottomSheetDemoPageState();
}

class _BottomSheetDemoPageState extends State<BottomSheetDemoPage> {
  String _selectedItem = '尚未选择';

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: '底部弹窗 BottomSheet',
      subtitle: '演示不同类型的底部弹窗，包括模态弹窗、可拖拽弹窗和自定义内容',
      conceptItems: const [
        'showModalBottomSheet：显示模态底部弹窗，点击外部可关闭',
        'DraggableScrollableSheet：可拖拽高度的底部弹窗',
        'isScrollControlled：设为 true 可让弹窗占据更多屏幕空间',
        'shape：自定义弹窗形状，通常设置圆角',
        'useSafeArea：确保弹窗不被系统 UI 遮挡',
      ],
      children: [
        const SectionTitle('1. 基础 ModalBottomSheet'),
        ElevatedButton.icon(
          onPressed: () => _showBasicBottomSheet(context),
          icon: const Icon(Icons.vertical_align_bottom),
          label: const Text('显示基础底部弹窗'),
        ),
        const SizedBox(height: 16),

        const SectionTitle('2. DraggableScrollableSheet 可拖拽'),
        ElevatedButton.icon(
          onPressed: () => _showDraggableSheet(context),
          icon: const Icon(Icons.drag_handle),
          label: const Text('显示可拖拽弹窗'),
        ),
        const SizedBox(height: 16),

        const SectionTitle('3. 列表选择弹窗'),
        ElevatedButton.icon(
          onPressed: () => _showListSelectionSheet(context),
          icon: const Icon(Icons.list),
          label: const Text('显示列表选择弹窗'),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('已选择: $_selectedItem', style: const TextStyle(fontSize: 14)),
        ),
        const SizedBox(height: 16),

        const SectionTitle('4. 全屏 BottomSheet'),
        ElevatedButton.icon(
          onPressed: () => _showFullScreenSheet(context),
          icon: const Icon(Icons.fullscreen),
          label: const Text('显示全屏弹窗'),
        ),
      ],
    );
  }

  /// 基础底部弹窗
  void _showBasicBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // 设置圆角
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 拖拽指示条
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Icon(Icons.info_outline, size: 48, color: Colors.blue),
              const SizedBox(height: 12),
              const Text('基础底部弹窗', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('这是一个使用 showModalBottomSheet 创建的基础弹窗'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('关闭'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 可拖拽底部弹窗
  void _showDraggableSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          // 初始高度占屏幕 40%
          initialChildSize: 0.4,
          // 最小高度 25%
          minChildSize: 0.25,
          // 最大高度 85%
          maxChildSize: 0.85,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                // 拖拽手柄
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('上下拖拽调整高度', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: 30,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(child: Text('${index + 1}')),
                        title: Text('列表项 ${index + 1}'),
                        subtitle: const Text('可以滚动查看更多内容'),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// 列表选择弹窗
  void _showListSelectionSheet(BuildContext context) {
    final items = [
      {'icon': Icons.wb_sunny, 'label': '晴天', 'color': Colors.orange},
      {'icon': Icons.cloud, 'label': '多云', 'color': Colors.grey},
      {'icon': Icons.grain, 'label': '下雨', 'color': Colors.blue},
      {'icon': Icons.ac_unit, 'label': '下雪', 'color': Colors.lightBlue},
      {'icon': Icons.thunderstorm, 'label': '雷暴', 'color': Colors.deepPurple},
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text('选择天气', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...items.map((item) {
                return ListTile(
                  leading: Icon(item['icon'] as IconData, color: item['color'] as Color),
                  title: Text(item['label'] as String),
                  onTap: () {
                    setState(() {
                      _selectedItem = item['label'] as String;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  /// 全屏底部弹窗
  void _showFullScreenSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            children: [
              // 头部带关闭按钮
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('全屏弹窗', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // 内容区域
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.fullscreen, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      const Text('这是一个接近全屏的底部弹窗'),
                      const Text('通过 isScrollControlled: true 实现'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
