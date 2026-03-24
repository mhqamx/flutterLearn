import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// 焦点管理演示页面
/// 展示 FocusNode 和焦点控制
class FocusDemoPage extends StatefulWidget {
  const FocusDemoPage({super.key});

  @override
  State<FocusDemoPage> createState() => _FocusDemoPageState();
}

class _FocusDemoPageState extends State<FocusDemoPage> {
  // 焦点节点
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _addressFocus = FocusNode();
  final _noteFocus = FocusNode();

  // 输入控制器
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();

  // 焦点状态追踪
  String _currentFocusField = '无';

  @override
  void initState() {
    super.initState();
    // 监听焦点变化
    _nameFocus.addListener(() => _updateFocusState('姓名', _nameFocus));
    _emailFocus.addListener(() => _updateFocusState('邮箱', _emailFocus));
    _phoneFocus.addListener(() => _updateFocusState('电话', _phoneFocus));
    _addressFocus.addListener(() => _updateFocusState('地址', _addressFocus));
    _noteFocus.addListener(() => _updateFocusState('备注', _noteFocus));
  }

  void _updateFocusState(String name, FocusNode node) {
    if (node.hasFocus) {
      setState(() => _currentFocusField = name);
    }
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _addressFocus.dispose();
    _noteFocus.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  /// 移到下一个焦点
  void _nextFocus(FocusNode current, FocusNode next) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }

  /// 清除所有焦点
  void _clearFocus() {
    FocusScope.of(context).unfocus();
    setState(() => _currentFocusField = '无');
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: '焦点管理',
      subtitle: '展示 FocusNode 焦点控制和 TextField 焦点切换',
      conceptItems: const [
        'FocusNode：管理 Widget 焦点状态的对象',
        'FocusScope.of(context).requestFocus：请求焦点到指定节点',
        'FocusScope.of(context).unfocus：取消当前焦点（收起键盘）',
        'autofocus：自动获取焦点的属性',
        'TextInputAction：控制键盘右下角按钮（next/done/search）',
      ],
      children: [
        // 焦点状态指示
        _buildCard(
          child: Row(
            children: [
              const Icon(Icons.center_focus_strong, color: Colors.blue),
              const SizedBox(width: 8),
              Text('当前焦点: $_currentFocusField',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w600,
                  )),
              const Spacer(),
              TextButton.icon(
                onPressed: _clearFocus,
                icon: const Icon(Icons.close, size: 16),
                label: const Text('清除焦点'),
              ),
            ],
          ),
        ),

        // === 手动焦点控制 ===
        const SectionTitle('FocusNode 手动焦点控制'),
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('点击按钮将焦点移到对应输入框',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildFocusChip('姓名', _nameFocus),
                  _buildFocusChip('邮箱', _emailFocus),
                  _buildFocusChip('电话', _phoneFocus),
                  _buildFocusChip('地址', _addressFocus),
                  _buildFocusChip('备注', _noteFocus),
                ],
              ),
            ],
          ),
        ),

        // === 表单焦点顺序 ===
        const SectionTitle('表单焦点顺序（键盘 Next/Done）'),
        _buildCard(
          child: Column(
            children: [
              // 姓名 - autofocus
              _buildFocusTextField(
                label: '姓名',
                controller: _nameController,
                focusNode: _nameFocus,
                icon: Icons.person,
                action: TextInputAction.next,
                autofocus: false,
                onSubmitted: (_) => _nextFocus(_nameFocus, _emailFocus),
                hint: '自动聚焦的第一个字段',
              ),
              const SizedBox(height: 12),

              // 邮箱
              _buildFocusTextField(
                label: '邮箱',
                controller: _emailController,
                focusNode: _emailFocus,
                icon: Icons.email,
                action: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                onSubmitted: (_) => _nextFocus(_emailFocus, _phoneFocus),
              ),
              const SizedBox(height: 12),

              // 电话
              _buildFocusTextField(
                label: '电话',
                controller: _phoneController,
                focusNode: _phoneFocus,
                icon: Icons.phone,
                action: TextInputAction.next,
                keyboardType: TextInputType.phone,
                onSubmitted: (_) => _nextFocus(_phoneFocus, _addressFocus),
              ),
              const SizedBox(height: 12),

              // 地址
              _buildFocusTextField(
                label: '地址',
                controller: _addressController,
                focusNode: _addressFocus,
                icon: Icons.location_on,
                action: TextInputAction.next,
                onSubmitted: (_) => _nextFocus(_addressFocus, _noteFocus),
              ),
              const SizedBox(height: 12),

              // 备注 - done
              _buildFocusTextField(
                label: '备注',
                controller: _noteController,
                focusNode: _noteFocus,
                icon: Icons.note,
                action: TextInputAction.done,
                maxLines: 2,
                onSubmitted: (_) {
                  _clearFocus();
                  _showSnackBar('表单填写完成!');
                },
              ),
            ],
          ),
        ),

        // === 焦点顺序说明 ===
        const SectionTitle('TextInputAction 键盘按钮'),
        _buildCard(
          child: Column(
            children: [
              _buildActionInfo('TextInputAction.next', '键盘显示"下一项"按钮，切换到下一个字段'),
              const Divider(height: 16),
              _buildActionInfo('TextInputAction.done', '键盘显示"完成"按钮，收起键盘'),
              const Divider(height: 16),
              _buildActionInfo('TextInputAction.search', '键盘显示"搜索"按钮'),
              const Divider(height: 16),
              _buildActionInfo('TextInputAction.send', '键盘显示"发送"按钮'),
            ],
          ),
        ),

        // === 焦点事件 ===
        const SectionTitle('Focus Widget 焦点事件'),
        _buildCard(
          child: Focus(
            onFocusChange: (hasFocus) {
              // 可监听焦点变化
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Focus Widget 可以包裹任何组件，使其可以接收焦点',
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber[200]!),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.amber, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '在 dispose() 中必须调用 FocusNode.dispose() 释放资源，'
                          '否则会导致内存泄漏。',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 构建焦点切换 Chip
  Widget _buildFocusChip(String label, FocusNode node) {
    final hasFocus = node.hasFocus;
    return ActionChip(
      avatar: Icon(
        hasFocus ? Icons.radio_button_checked : Icons.radio_button_off,
        size: 16,
        color: hasFocus ? Colors.blue : Colors.grey,
      ),
      label: Text(label),
      backgroundColor: hasFocus ? Colors.blue[50] : null,
      onPressed: () {
        FocusScope.of(context).requestFocus(node);
      },
    );
  }

  /// 构建带焦点的输入框
  Widget _buildFocusTextField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required IconData icon,
    required TextInputAction action,
    TextInputType? keyboardType,
    bool autofocus = false,
    int maxLines = 1,
    String? hint,
    ValueChanged<String>? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      textInputAction: action,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        isDense: true,
        prefixIcon: Icon(icon),
        suffixIcon: focusNode.hasFocus
            ? Icon(Icons.check_circle, color: Colors.green[400], size: 20)
            : null,
      ),
    );
  }

  Widget _buildActionInfo(String action, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 170,
          child: Text(
            action,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: Colors.blue[700],
            ),
          ),
        ),
        Expanded(
          child: Text(desc, style: const TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  void _showSnackBar(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
      );
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
