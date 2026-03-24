import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Hive NoSQL 存储演示页面
/// 展示 Hive 键值对存储和对象存储（对应 iOS SwiftData）
class HiveDemoPage extends StatefulWidget {
  const HiveDemoPage({super.key});

  @override
  State<HiveDemoPage> createState() => _HiveDemoPageState();
}

class _HiveDemoPageState extends State<HiveDemoPage> {
  Box? _booksBox;
  Box? _settingsBox;
  bool _isInitialized = false;
  String _statusMessage = '初始化 Hive...';

  final _titleController = TextEditingController();
  final _authorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  /// 初始化 Hive 并打开 Box
  Future<void> _initHive() async {
    try {
      // 打开两个 Box：一个存书籍，一个存设置
      _booksBox = await Hive.openBox('demo_books');
      _settingsBox = await Hive.openBox('demo_settings');
      setState(() {
        _isInitialized = true;
        _statusMessage = 'Hive 已就绪';
      });
    } catch (e) {
      setState(() {
        _statusMessage = '初始化失败: $e';
      });
    }
  }

  /// 获取所有书籍
  List<Map<String, dynamic>> get _books {
    if (_booksBox == null) return [];
    final list = <Map<String, dynamic>>[];
    for (int i = 0; i < _booksBox!.length; i++) {
      final data = _booksBox!.getAt(i);
      if (data is Map) {
        list.add({
          'index': i,
          'title': data['title'] ?? '',
          'author': data['author'] ?? '',
          'isFavorite': data['isFavorite'] ?? false,
          'addedAt': data['addedAt'] ?? '',
        });
      }
    }
    return list;
  }

  /// 添加书籍（存取对象，Map 形式）
  Future<void> _addBook() async {
    final title = _titleController.text.trim();
    final author = _authorController.text.trim();
    if (title.isEmpty || _booksBox == null) return;

    await _booksBox!.add({
      'title': title,
      'author': author.isEmpty ? '未知作者' : author,
      'isFavorite': false,
      'addedAt': DateTime.now().toIso8601String(),
    });
    _titleController.clear();
    _authorController.clear();
    _showSnackBar('已添加: $title');
    setState(() {});
  }

  /// 切换收藏状态
  Future<void> _toggleFavorite(int index) async {
    if (_booksBox == null) return;
    final data = Map<String, dynamic>.from(_booksBox!.getAt(index) as Map);
    data['isFavorite'] = !(data['isFavorite'] ?? false);
    await _booksBox!.putAt(index, data);
    setState(() {});
  }

  /// 删除书籍
  Future<void> _deleteBook(int index) async {
    if (_booksBox == null) return;
    await _booksBox!.deleteAt(index);
    _showSnackBar('已删除');
    setState(() {});
  }

  /// 清空所有书籍
  Future<void> _clearBooks() async {
    if (_booksBox == null) return;
    await _booksBox!.clear();
    _showSnackBar('已清空所有书籍');
    setState(() {});
  }

  /// 存取键值对示例
  Future<void> _saveSettings(String key, dynamic value) async {
    if (_settingsBox == null) return;
    await _settingsBox!.put(key, value);
    setState(() {});
  }

  dynamic _getSetting(String key, [dynamic defaultValue]) {
    return _settingsBox?.get(key, defaultValue: defaultValue);
  }

  void _showSnackBar(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final books = _books;
    final favoriteBooks = books.where((b) => b['isFavorite'] == true).toList();
    final otherBooks = books.where((b) => b['isFavorite'] != true).toList();

    return DemoScaffold(
      title: 'Hive NoSQL 存储',
      subtitle: '轻量级 NoSQL 数据库，无需 Schema 定义（对应 iOS SwiftData）',
      conceptItems: const [
        'Hive：纯 Dart 编写的轻量级 NoSQL 数据库',
        'Box：Hive 中的存储容器，类似数据库的表',
        'put/get：键值对存取，key 可以是 String 或 int',
        'add/getAt/putAt/deleteAt：按索引操作，类似 List',
        'ValueListenableBuilder：监听 Box 变化自动更新 UI',
      ],
      children: [
        // 状态
        _buildCard(
          child: Row(
            children: [
              Icon(
                _isInitialized ? Icons.check_circle : Icons.hourglass_top,
                color: _isInitialized ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 8),
              Text(_statusMessage),
              const Spacer(),
              Text('共 ${books.length} 本书',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            ],
          ),
        ),

        const SectionTitle('键值对存取'),
        _buildCard(
          child: Column(
            children: [
              // 用户名键值对
              Row(
                children: [
                  const Text('用户名：', style: TextStyle(fontWeight: FontWeight.w600)),
                  Expanded(
                    child: Text(
                      '${_getSetting('username', '未设置')}',
                      style: TextStyle(color: Colors.blue[700]),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _saveSettings('username', 'Flutter学习者');
                    },
                    child: const Text('设置'),
                  ),
                ],
              ),
              const Divider(),
              // 阅读目标
              Row(
                children: [
                  const Text('年度阅读目标：', style: TextStyle(fontWeight: FontWeight.w600)),
                  Expanded(
                    child: Text(
                      '${_getSetting('readingGoal', 0)} 本',
                      style: TextStyle(color: Colors.green[700]),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                    onPressed: () {
                      final current = _getSetting('readingGoal', 0) as int;
                      if (current > 0) _saveSettings('readingGoal', current - 1);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                    onPressed: () {
                      final current = _getSetting('readingGoal', 0) as int;
                      _saveSettings('readingGoal', current + 1);
                    },
                  ),
                ],
              ),
              const Divider(),
              // 布尔值
              SwitchListTile(
                title: const Text('通知提醒'),
                subtitle: Text('${_getSetting('notifications', false)}'),
                value: _getSetting('notifications', false) as bool,
                onChanged: (val) => _saveSettings('notifications', val),
                dense: true,
              ),
            ],
          ),
        ),

        const SectionTitle('添加书籍（Map 对象存储）'),
        _buildCard(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: '书名',
                  border: OutlineInputBorder(),
                  isDense: true,
                  prefixIcon: Icon(Icons.book),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _authorController,
                decoration: const InputDecoration(
                  hintText: '作者（可选）',
                  border: OutlineInputBorder(),
                  isDense: true,
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isInitialized ? _addBook : null,
                  icon: const Icon(Icons.add),
                  label: const Text('添加书籍'),
                ),
              ),
            ],
          ),
        ),

        const SectionTitle('收藏书籍列表'),
        if (books.isEmpty)
          _buildCard(
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(Icons.library_books, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('暂无书籍', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),

        // 收藏的书
        if (favoriteBooks.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 4, bottom: 4),
            child: Text('收藏 (${favoriteBooks.length})',
                style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.w600, fontSize: 13)),
          ),
          ...favoriteBooks.map(_buildBookTile),
        ],

        // 其他书
        if (otherBooks.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 8, bottom: 4),
            child: Text('全部 (${otherBooks.length})',
                style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600, fontSize: 13)),
          ),
          ...otherBooks.map(_buildBookTile),
        ],

        if (books.isNotEmpty) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _clearBooks,
              icon: const Icon(Icons.delete_sweep, color: Colors.red),
              label: const Text('清空所有书籍', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],

        // 监听变化说明
        if (_booksBox != null) ...[
          const SectionTitle('ValueListenableBuilder 监听变化'),
          _buildCard(
            child: ValueListenableBuilder(
              valueListenable: _booksBox!.listenable(),
              builder: (context, Box box, _) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '当前 Box 中有 ${box.length} 条数据\n'
                          '此区域通过 ValueListenableBuilder 自动更新',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBookTile(Map<String, dynamic> book) {
    final isFav = book['isFavorite'] as bool;
    final index = book['index'] as int;
    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isFav ? Colors.red[50] : Colors.grey[100],
          child: Icon(
            Icons.book,
            color: isFav ? Colors.red : Colors.grey,
          ),
        ),
        title: Text(book['title'] as String),
        subtitle: Text(book['author'] as String,
            style: const TextStyle(fontSize: 12)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : Colors.grey,
              ),
              onPressed: () => _toggleFavorite(index),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
              onPressed: () => _deleteBook(index),
            ),
          ],
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
