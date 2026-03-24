import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// 对话框 Demo
/// 演示 AlertDialog、SimpleDialog、自定义 Dialog、CupertinoDialog
class DialogDemoPage extends StatefulWidget {
  const DialogDemoPage({super.key});

  @override
  State<DialogDemoPage> createState() => _DialogDemoPageState();
}

class _DialogDemoPageState extends State<DialogDemoPage> {
  String _result = '尚未操作';

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: '对话框 Dialog',
      subtitle: '演示不同类型的对话框，包括确认框、列表选择、自定义输入和 iOS 风格对话框',
      conceptItems: const [
        'showDialog：显示 Material 风格对话框的通用方法',
        'AlertDialog：简单的确认/取消对话框，包含 title、content、actions',
        'SimpleDialog：提供列表选项供用户选择',
        'showCupertinoDialog：iOS 风格的对话框，使用 CupertinoAlertDialog',
        'barrierDismissible：控制点击对话框外部是否关闭',
      ],
      children: [
        // 结果展示
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.amber),
              const SizedBox(width: 8),
              Expanded(child: Text('操作结果: $_result', style: const TextStyle(fontSize: 14))),
            ],
          ),
        ),

        const SectionTitle('1. AlertDialog 确认对话框'),
        ElevatedButton.icon(
          onPressed: () => _showAlertDialog(context),
          icon: const Icon(Icons.warning_amber),
          label: const Text('显示确认对话框'),
        ),
        const SizedBox(height: 16),

        const SectionTitle('2. SimpleDialog 列表选择'),
        ElevatedButton.icon(
          onPressed: () => _showSimpleDialog(context),
          icon: const Icon(Icons.list_alt),
          label: const Text('显示列表选择对话框'),
        ),
        const SizedBox(height: 16),

        const SectionTitle('3. 自定义 Dialog（带输入框）'),
        ElevatedButton.icon(
          onPressed: () => _showInputDialog(context),
          icon: const Icon(Icons.edit),
          label: const Text('显示输入对话框'),
        ),
        const SizedBox(height: 16),

        const SectionTitle('4. CupertinoDialog iOS 风格'),
        ElevatedButton.icon(
          onPressed: () => _showCupertinoStyleDialog(context),
          icon: const Icon(Icons.phone_iphone),
          label: const Text('显示 iOS 风格对话框'),
        ),
      ],
    );
  }

  /// AlertDialog 简单确认
  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.delete_forever, color: Colors.red, size: 40),
          title: const Text('确认删除'),
          content: const Text('确定要删除这本书吗？此操作不可撤销。'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => _result = 'AlertDialog: 取消删除');
              },
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => _result = 'AlertDialog: 确认删除');
              },
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('删除'),
            ),
          ],
        );
      },
    );
  }

  /// SimpleDialog 列表选择
  void _showSimpleDialog(BuildContext context) async {
    final languages = [
      {'name': 'Dart', 'icon': Icons.code},
      {'name': 'Kotlin', 'icon': Icons.android},
      {'name': 'Swift', 'icon': Icons.phone_iphone},
      {'name': 'TypeScript', 'icon': Icons.web},
      {'name': 'Rust', 'icon': Icons.memory},
    ];

    final selected = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('选择编程语言'),
          children: languages.map((lang) {
            return SimpleDialogOption(
              onPressed: () => Navigator.pop(context, lang['name'] as String),
              child: Row(
                children: [
                  Icon(lang['icon'] as IconData, color: Colors.blue),
                  const SizedBox(width: 12),
                  Text(lang['name'] as String, style: const TextStyle(fontSize: 16)),
                ],
              ),
            );
          }).toList(),
        );
      },
    );

    if (selected != null) {
      setState(() => _result = 'SimpleDialog: 选择了 $selected');
    }
  }

  /// 自定义 Dialog（带输入框）
  void _showInputDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('添加笔记'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('请输入笔记内容：'),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: '在此输入...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.dispose();
                Navigator.pop(context);
                setState(() => _result = '自定义Dialog: 取消输入');
              },
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () {
                final text = controller.text;
                controller.dispose();
                Navigator.pop(context);
                setState(() {
                  _result = text.isEmpty
                      ? '自定义Dialog: 提交了空内容'
                      : '自定义Dialog: 提交了「$text」';
                });
              },
              child: const Text('提交'),
            ),
          ],
        );
      },
    );
  }

  /// iOS 风格对话框
  void _showCupertinoStyleDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('更新可用'),
          content: const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('Flutter 3.20 已发布，是否立即更新？'),
          ),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
                setState(() => _result = 'CupertinoDialog: 稍后再说');
              },
              child: const Text('稍后再说'),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
                setState(() => _result = 'CupertinoDialog: 立即更新');
              },
              child: const Text('立即更新'),
            ),
          ],
        );
      },
    );
  }
}
