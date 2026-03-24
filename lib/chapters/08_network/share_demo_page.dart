import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';
import 'package:share_plus/share_plus.dart';

class ShareDemoPage extends StatefulWidget {
  const ShareDemoPage({super.key});

  @override
  State<ShareDemoPage> createState() => _ShareDemoPageState();
}

class _ShareDemoPageState extends State<ShareDemoPage> {
  String _lastShareResult = '尚未分享';
  final _textController = TextEditingController(text: 'Hello from Flutter!');
  final _urlController = TextEditingController(text: 'https://flutter.dev');
  final _subjectController = TextEditingController(text: 'Flutter 学习');

  @override
  void dispose() {
    _textController.dispose();
    _urlController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  Future<void> _shareText() async {
    final text = _textController.text;
    if (text.isEmpty) return;
    final result = await Share.share(text);
    _handleShareResult(result);
  }

  Future<void> _shareUrl() async {
    final url = _urlController.text;
    if (url.isEmpty) return;
    final result = await Share.share(url, subject: 'Flutter 官网链接');
    _handleShareResult(result);
  }

  Future<void> _shareWithSubject() async {
    final text = _textController.text;
    final subject = _subjectController.text;
    if (text.isEmpty) return;
    final result = await Share.share(
      '$subject\n\n$text\n\n${_urlController.text}',
      subject: subject,
    );
    _handleShareResult(result);
  }

  void _handleShareResult(ShareResult result) {
    String statusText;
    switch (result.status) {
      case ShareResultStatus.success:
        statusText = '分享成功';
      case ShareResultStatus.dismissed:
        statusText = '用户取消了分享';
      case ShareResultStatus.unavailable:
        statusText = '分享不可用';
    }
    setState(() => _lastShareResult = statusText);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(statusText), duration: const Duration(seconds: 1)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: '分享功能',
      subtitle: '使用 share_plus 调用系统分享面板（对应 iOS ShareLink）',
      conceptItems: const [
        'Share.share()：分享纯文本',
        'Share.share()：分享并获取结果',
        'ShareResult：分享结果，包含 status 状态',
        'subject：邮件分享时会作为邮件标题',
      ],
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blue),
                const SizedBox(width: 8),
                Text('上次分享结果: $_lastShareResult', style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ),

        const SectionTitle('编辑分享内容'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(controller: _textController, maxLines: 2,
                    decoration: const InputDecoration(labelText: '分享文本', border: OutlineInputBorder(), isDense: true)),
                const SizedBox(height: 8),
                TextField(controller: _urlController,
                    decoration: const InputDecoration(labelText: '链接 URL', border: OutlineInputBorder(), isDense: true, prefixIcon: Icon(Icons.link))),
                const SizedBox(height: 8),
                TextField(controller: _subjectController,
                    decoration: const InputDecoration(labelText: '标题 (Subject)', border: OutlineInputBorder(), isDense: true, prefixIcon: Icon(Icons.title))),
              ],
            ),
          ),
        ),

        const SectionTitle('分享操作'),
        SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _shareText, icon: const Icon(Icons.text_fields), label: const Text('分享文本'))),
        const SizedBox(height: 8),
        SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _shareUrl, icon: const Icon(Icons.link), label: const Text('分享链接'))),
        const SizedBox(height: 8),
        SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _shareWithSubject, icon: const Icon(Icons.share), label: const Text('分享全部内容'))),

        const SectionTitle('快捷分享模板'),
        ...[
          ('Flutter 官网', '推荐学习 Flutter! https://flutter.dev', Icons.flutter_dash),
          ('Dart 语言', 'Dart 编程语言入门: https://dart.dev', Icons.code),
          ('Material Design', 'Material Design 3: https://m3.material.io', Icons.palette),
        ].map((item) => ListTile(
          leading: Icon(item.$3, color: Colors.blue),
          title: Text(item.$1, style: const TextStyle(fontSize: 14)),
          subtitle: Text(item.$2, style: const TextStyle(fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: IconButton(
            icon: const Icon(Icons.share, size: 20),
            onPressed: () async {
              final result = await Share.share(item.$2, subject: item.$1);
              _handleShareResult(result);
            },
          ),
        )),
      ],
    );
  }
}
