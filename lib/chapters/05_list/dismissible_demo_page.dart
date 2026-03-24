import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// 滑动操作 Demo
/// 演示 Dismissible 左滑删除、右滑标记、确认删除、SnackBar 撤销
class DismissibleDemoPage extends StatefulWidget {
  const DismissibleDemoPage({super.key});

  @override
  State<DismissibleDemoPage> createState() => _DismissibleDemoPageState();
}

class _DismissibleDemoPageState extends State<DismissibleDemoPage> {
  // 待办事项列表
  final List<Map<String, dynamic>> _todos = [
    {'title': '学习 Flutter 基础', 'done': false},
    {'title': '完成 ListView Demo', 'done': true},
    {'title': '练习状态管理', 'done': false},
    {'title': '学习 Navigator 导航', 'done': false},
    {'title': '实现搜索功能', 'done': true},
    {'title': '学习动画系统', 'done': false},
    {'title': '编写单元测试', 'done': false},
    {'title': '优化应用性能', 'done': false},
  ];

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: '滑动操作 Dismissible',
      subtitle: '演示 Dismissible 组件实现左滑删除、右滑标记、撤销操作',
      conceptItems: const [
        'Dismissible：可滑动移除的组件，支持左右两个方向',
        'direction：控制滑动方向（startToEnd / endToStart / horizontal）',
        'confirmDismiss：异步确认回调，返回 true 允许移除',
        'onDismissed：移除完成后的回调，用于更新数据',
        'background / secondaryBackground：左滑和右滑时显示的背景组件',
      ],
      children: [
        // 操作提示
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Icon(Icons.swipe, color: Colors.blue),
              SizedBox(width: 8),
              Expanded(
                child: Text('左滑 -> 删除 | 右滑 -> 标记完成/取消', style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // 重置按钮
        OutlinedButton.icon(
          onPressed: _resetTodos,
          icon: const Icon(Icons.refresh),
          label: const Text('重置列表'),
        ),
        const SizedBox(height: 12),

        // 待办列表
        Container(
          height: 500,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _todos.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 64, color: Colors.green),
                      SizedBox(height: 8),
                      Text('全部完成！', style: TextStyle(fontSize: 18, color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _todos.length,
                  itemBuilder: (context, index) {
                    final todo = _todos[index];
                    final isDone = todo['done'] as bool;

                    return Dismissible(
                      key: ValueKey('${todo['title']}_$index'),
                      // 右滑背景（标记完成）
                      background: Container(
                        color: Colors.green,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 24),
                        child: const Row(
                          children: [
                            Icon(Icons.check, color: Colors.white),
                            SizedBox(width: 8),
                            Text('标记', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      // 左滑背景（删除）
                      secondaryBackground: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 24),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('删除', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            SizedBox(width: 8),
                            Icon(Icons.delete, color: Colors.white),
                          ],
                        ),
                      ),
                      // 确认删除
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          // 左滑：弹出确认对话框
                          return await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('确认删除'),
                              content: Text('确定要删除「${todo['title']}」吗？'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
                                FilledButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  style: FilledButton.styleFrom(backgroundColor: Colors.red),
                                  child: const Text('删除'),
                                ),
                              ],
                            ),
                          ) ?? false;
                        } else {
                          // 右滑：直接标记，不移除
                          setState(() {
                            _todos[index] = {...todo, 'done': !isDone};
                          });
                          return false; // 不移除
                        }
                      },
                      // 移除完成回调
                      onDismissed: (direction) {
                        final removed = _todos[index];
                        setState(() => _todos.removeAt(index));

                        // 显示 SnackBar 带撤销按钮
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('已删除「${removed['title']}」'),
                            action: SnackBarAction(
                              label: '撤销',
                              onPressed: () {
                                setState(() => _todos.insert(index, removed));
                              },
                            ),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: Icon(
                          isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: isDone ? Colors.green : Colors.grey,
                        ),
                        title: Text(
                          todo['title'] as String,
                          style: TextStyle(
                            decoration: isDone ? TextDecoration.lineThrough : null,
                            color: isDone ? Colors.grey : null,
                          ),
                        ),
                        subtitle: Text(isDone ? '已完成' : '未完成'),
                        trailing: const Icon(Icons.drag_handle, color: Colors.grey),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  /// 重置待办列表
  void _resetTodos() {
    setState(() {
      _todos
        ..clear()
        ..addAll([
          {'title': '学习 Flutter 基础', 'done': false},
          {'title': '完成 ListView Demo', 'done': true},
          {'title': '练习状态管理', 'done': false},
          {'title': '学习 Navigator 导航', 'done': false},
          {'title': '实现搜索功能', 'done': true},
          {'title': '学习动画系统', 'done': false},
          {'title': '编写单元测试', 'done': false},
          {'title': '优化应用性能', 'done': false},
        ]);
    });
  }
}
