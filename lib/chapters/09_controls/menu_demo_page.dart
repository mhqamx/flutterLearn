import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// 菜单演示页面
/// 展示各种菜单组件
class MenuDemoPage extends StatefulWidget {
  const MenuDemoPage({super.key});

  @override
  State<MenuDemoPage> createState() => _MenuDemoPageState();
}

class _MenuDemoPageState extends State<MenuDemoPage> {
  // PopupMenuButton 选中项
  String _popupMenuSelection = '未选择';

  // DropdownMenu 选中项
  String _dropdownMenuSelection = '';

  // Context Menu 选中项
  String _contextMenuSelection = '长按下方区域试试';

  // MenuAnchor 选中项
  String _menuAnchorSelection = '未选择';

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: '菜单',
      subtitle: '展示 PopupMenuButton、DropdownMenu、ContextMenu、MenuAnchor',
      conceptItems: const [
        'PopupMenuButton：弹出式菜单，常用于 AppBar 更多操作',
        'DropdownMenu：Material 3 下拉菜单，支持搜索和过滤',
        'showMenu：在指定位置显示弹出菜单（可用于长按）',
        'MenuAnchor：菜单锚点，将菜单绑定到指定 Widget',
        'PopupMenuItem：菜单项，value 用于区分选中的项',
      ],
      children: [
        // === PopupMenuButton ===
        const SectionTitle('PopupMenuButton 弹出菜单'),
        _buildCard(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('当前选择: $_popupMenuSelection',
                        style: const TextStyle(fontSize: 14)),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      setState(() => _popupMenuSelection = value);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: '编辑',
                        child: ListTile(
                          leading: Icon(Icons.edit, size: 20),
                          title: Text('编辑'),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem(
                        value: '复制',
                        child: ListTile(
                          leading: Icon(Icons.copy, size: 20),
                          title: Text('复制'),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: '分享',
                        child: ListTile(
                          leading: Icon(Icons.share, size: 20),
                          title: Text('分享'),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem(
                        value: '删除',
                        child: ListTile(
                          leading: Icon(Icons.delete, size: 20, color: Colors.red),
                          title: Text('删除', style: TextStyle(color: Colors.red)),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // 带初始值的 PopupMenuButton
              const Divider(),
              Row(
                children: [
                  const Text('排序方式：', style: TextStyle(fontSize: 14)),
                  const Spacer(),
                  PopupMenuButton<String>(
                    initialValue: '按时间',
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('选择排序'),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_drop_down, size: 20),
                        ],
                      ),
                    ),
                    onSelected: (value) {
                      setState(() => _popupMenuSelection = '排序: $value');
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: '按时间', child: Text('按时间')),
                      PopupMenuItem(value: '按名称', child: Text('按名称')),
                      PopupMenuItem(value: '按大小', child: Text('按大小')),
                      PopupMenuItem(value: '按类型', child: Text('按类型')),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        // === DropdownMenu (Material 3) ===
        const SectionTitle('DropdownMenu（Material 3）'),
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownMenu<String>(
                expandedInsets: EdgeInsets.zero,
                label: const Text('选择编程语言'),
                leadingIcon: const Icon(Icons.code),
                onSelected: (value) {
                  setState(() => _dropdownMenuSelection = value ?? '');
                },
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: 'Dart', label: 'Dart', leadingIcon: Icon(Icons.flutter_dash, size: 18)),
                  DropdownMenuEntry(value: 'Swift', label: 'Swift', leadingIcon: Icon(Icons.apple, size: 18)),
                  DropdownMenuEntry(value: 'Kotlin', label: 'Kotlin', leadingIcon: Icon(Icons.android, size: 18)),
                  DropdownMenuEntry(value: 'TypeScript', label: 'TypeScript', leadingIcon: Icon(Icons.javascript, size: 18)),
                  DropdownMenuEntry(value: 'Python', label: 'Python', leadingIcon: Icon(Icons.terminal, size: 18)),
                  DropdownMenuEntry(value: 'Rust', label: 'Rust', leadingIcon: Icon(Icons.settings, size: 18)),
                ],
              ),
              if (_dropdownMenuSelection.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.blue, size: 18),
                      const SizedBox(width: 8),
                      Text('选中: $_dropdownMenuSelection',
                          style: TextStyle(color: Colors.blue[700])),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),

        // === Context Menu（长按） ===
        const SectionTitle('长按 Context Menu'),
        _buildCard(
          child: Column(
            children: [
              Text(_contextMenuSelection,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              const SizedBox(height: 8),
              GestureDetector(
                onLongPressStart: (details) {
                  _showContextMenu(details.globalPosition);
                },
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.touch_app, size: 32, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('长按此区域弹出菜单', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // === MenuAnchor ===
        const SectionTitle('MenuAnchor 菜单锚点'),
        _buildCard(
          child: Column(
            children: [
              Text('选中: $_menuAnchorSelection',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MenuAnchor(
                    builder: (context, controller, child) {
                      return ElevatedButton.icon(
                        onPressed: () {
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
                          }
                        },
                        icon: const Icon(Icons.menu),
                        label: const Text('打开菜单'),
                      );
                    },
                    menuChildren: [
                      MenuItemButton(
                        leadingIcon: const Icon(Icons.home),
                        child: const Text('首页'),
                        onPressed: () => setState(() => _menuAnchorSelection = '首页'),
                      ),
                      MenuItemButton(
                        leadingIcon: const Icon(Icons.explore),
                        child: const Text('发现'),
                        onPressed: () => setState(() => _menuAnchorSelection = '发现'),
                      ),
                      // 子菜单
                      SubmenuButton(
                        leadingIcon: const Icon(Icons.settings),
                        menuChildren: [
                          MenuItemButton(
                            child: const Text('通用设置'),
                            onPressed: () => setState(() => _menuAnchorSelection = '通用设置'),
                          ),
                          MenuItemButton(
                            child: const Text('隐私设置'),
                            onPressed: () => setState(() => _menuAnchorSelection = '隐私设置'),
                          ),
                          MenuItemButton(
                            child: const Text('通知设置'),
                            onPressed: () => setState(() => _menuAnchorSelection = '通知设置'),
                          ),
                        ],
                        child: const Text('设置'),
                      ),
                      MenuItemButton(
                        leadingIcon: const Icon(Icons.info),
                        child: const Text('关于'),
                        onPressed: () => setState(() => _menuAnchorSelection = '关于'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 显示上下文菜单
  void _showContextMenu(Offset position) async {
    final result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 1,
        position.dy + 1,
      ),
      items: [
        const PopupMenuItem(value: '剪切', child: ListTile(leading: Icon(Icons.cut, size: 18), title: Text('剪切'), dense: true, contentPadding: EdgeInsets.zero)),
        const PopupMenuItem(value: '复制', child: ListTile(leading: Icon(Icons.copy, size: 18), title: Text('复制'), dense: true, contentPadding: EdgeInsets.zero)),
        const PopupMenuItem(value: '粘贴', child: ListTile(leading: Icon(Icons.paste, size: 18), title: Text('粘贴'), dense: true, contentPadding: EdgeInsets.zero)),
        const PopupMenuDivider(),
        const PopupMenuItem(value: '全选', child: ListTile(leading: Icon(Icons.select_all, size: 18), title: Text('全选'), dense: true, contentPadding: EdgeInsets.zero)),
      ],
    );
    if (result != null) {
      setState(() => _contextMenuSelection = '执行了: $result');
    }
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
