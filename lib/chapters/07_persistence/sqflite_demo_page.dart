import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

/// SQLite 数据库演示页面
/// 展示 sqflite CRUD 操作（对应 iOS CoreData）
class SqfliteDemoPage extends StatefulWidget {
  const SqfliteDemoPage({super.key});

  @override
  State<SqfliteDemoPage> createState() => _SqfliteDemoPageState();
}

class _SqfliteDemoPageState extends State<SqfliteDemoPage> {
  Database? _database;
  List<Map<String, dynamic>> _todos = [];
  final _titleController = TextEditingController();
  String _statusMessage = '初始化数据库...';

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _database?.close();
    super.dispose();
  }

  /// 创建/打开数据库并建表
  Future<void> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'demo_todos.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // 创建待办事项表
        await db.execute('''
          CREATE TABLE todos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            is_done INTEGER NOT NULL DEFAULT 0,
            created_at TEXT NOT NULL
          )
        ''');
      },
    );
    setState(() {
      _statusMessage = '数据库已就绪';
    });
    _queryTodos();
  }

  /// 插入待办事项
  Future<void> _insertTodo() async {
    final title = _titleController.text.trim();
    if (title.isEmpty || _database == null) return;

    await _database!.insert('todos', {
      'title': title,
      'is_done': 0,
      'created_at': DateTime.now().toIso8601String(),
    });
    _titleController.clear();
    _showSnackBar('已添加: $title');
    _queryTodos();
  }

  /// 查询所有待办事项
  Future<void> _queryTodos() async {
    if (_database == null) return;
    final results = await _database!.query(
      'todos',
      orderBy: 'created_at DESC',
    );
    setState(() {
      _todos = results;
    });
  }

  /// 更新待办状态（完成/未完成）
  Future<void> _toggleTodo(int id, bool isDone) async {
    if (_database == null) return;
    await _database!.update(
      'todos',
      {'is_done': isDone ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
    _queryTodos();
  }

  /// 更新待办标题
  Future<void> _updateTodoTitle(int id, String newTitle) async {
    if (_database == null || newTitle.trim().isEmpty) return;
    await _database!.update(
      'todos',
      {'title': newTitle.trim()},
      where: 'id = ?',
      whereArgs: [id],
    );
    _showSnackBar('已更新');
    _queryTodos();
  }

  /// 删除待办事项
  Future<void> _deleteTodo(int id) async {
    if (_database == null) return;
    await _database!.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
    _showSnackBar('已删除');
    _queryTodos();
  }

  /// 清空所有待办
  Future<void> _deleteAll() async {
    if (_database == null) return;
    await _database!.delete('todos');
    _showSnackBar('已清空所有待办');
    _queryTodos();
  }

  void _showSnackBar(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
      );
    }
  }

  /// 显示编辑对话框
  void _showEditDialog(int id, String currentTitle) {
    final editController = TextEditingController(text: currentTitle);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('编辑待办'),
        content: TextField(
          controller: editController,
          autofocus: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: '输入新的标题',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              _updateTodoTitle(id, editController.text);
              Navigator.pop(ctx);
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final doneTodos = _todos.where((t) => t['is_done'] == 1).toList();
    final pendingTodos = _todos.where((t) => t['is_done'] == 0).toList();

    return DemoScaffold(
      title: 'SQLite 数据库',
      subtitle: '使用 sqflite 实现结构化数据 CRUD 操作（对应 iOS CoreData）',
      conceptItems: const [
        'sqflite：Flutter 的 SQLite 插件，支持完整 SQL 操作',
        'openDatabase：打开或创建数据库，支持版本迁移',
        'insert/query/update/delete：对应 SQL 的增删改查',
        'where + whereArgs：参数化查询，防止 SQL 注入',
        'PRIMARY KEY AUTOINCREMENT：自增主键',
      ],
      children: [
        // 数据库状态
        _buildCard(
          child: Row(
            children: [
              Icon(
                _database != null ? Icons.check_circle : Icons.hourglass_top,
                color: _database != null ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 8),
              Text(_statusMessage),
              const Spacer(),
              Text('共 ${_todos.length} 条',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            ],
          ),
        ),

        const SectionTitle('添加待办事项（INSERT）'),
        _buildCard(
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: '输入待办事项...',
                    border: OutlineInputBorder(),
                    isDense: true,
                    prefixIcon: Icon(Icons.add_task),
                  ),
                  onSubmitted: (_) => _insertTodo(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _insertTodo,
                child: const Text('添加'),
              ),
            ],
          ),
        ),

        const SectionTitle('待办列表（SELECT + UPDATE + DELETE）'),
        if (pendingTodos.isEmpty && doneTodos.isEmpty)
          _buildCard(
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('暂无待办事项', style: TextStyle(color: Colors.grey)),
              ),
            ),
          ),

        // 未完成的待办
        if (pendingTodos.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 8, bottom: 4),
            child: Text('未完成 (${pendingTodos.length})',
                style: TextStyle(color: Colors.orange[700], fontWeight: FontWeight.w600)),
          ),
          ...pendingTodos.map((todo) => _buildTodoTile(todo)),
        ],

        // 已完成的待办
        if (doneTodos.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 12, bottom: 4),
            child: Text('已完成 (${doneTodos.length})',
                style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.w600)),
          ),
          ...doneTodos.map((todo) => _buildTodoTile(todo)),
        ],

        if (_todos.isNotEmpty) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _deleteAll,
              icon: const Icon(Icons.delete_sweep, color: Colors.red),
              label: const Text('清空所有', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTodoTile(Map<String, dynamic> todo) {
    final isDone = todo['is_done'] == 1;
    final id = todo['id'] as int;
    final title = todo['title'] as String;

    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        leading: Checkbox(
          value: isDone,
          onChanged: (val) => _toggleTodo(id, val ?? false),
        ),
        title: Text(
          title,
          style: TextStyle(
            decoration: isDone ? TextDecoration.lineThrough : null,
            color: isDone ? Colors.grey : null,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () => _showEditDialog(id, title),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
              onPressed: () => _deleteTodo(id),
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
