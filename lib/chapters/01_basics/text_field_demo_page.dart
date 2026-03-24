import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// TextField 演示页面
/// 展示 Flutter 中文本输入框的各种用法
class TextFieldDemoPage extends StatefulWidget {
  const TextFieldDemoPage({super.key});

  @override
  State<TextFieldDemoPage> createState() => _TextFieldDemoPageState();
}

class _TextFieldDemoPageState extends State<TextFieldDemoPage> {
  /// 基础输入框控制器
  final _basicController = TextEditingController();

  /// 密码输入框控制器
  final _passwordController = TextEditingController();

  /// 多行输入控制器
  final _multilineController = TextEditingController();

  /// 实时显示的文本
  String _displayText = '';

  /// 密码是否可见
  bool _passwordVisible = false;

  /// 表单验证用的 Key
  final _formKey = GlobalKey<FormState>();

  /// 验证输入框的控制器
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 监听基础输入框的变化
    _basicController.addListener(() {
      setState(() => _displayText = _basicController.text);
    });
  }

  @override
  void dispose() {
    _basicController.dispose();
    _passwordController.dispose();
    _multilineController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'TextField 输入框',
      subtitle: '展示文本输入框的各种装饰、验证和控制器用法',
      conceptItems: const [
        'TextField：Flutter 的文本输入组件',
        'TextEditingController：控制和读取输入框内容',
        'InputDecoration：配置输入框的外观（标签、图标、边框等）',
        'TextFormField：带验证功能的输入框，配合 Form 使用',
        'obscureText：密码输入框，隐藏输入内容',
      ],
      children: [
        const SectionTitle('基础输入框 + 实时显示'),
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _basicController,
                decoration: const InputDecoration(
                  labelText: '请输入文本',
                  hintText: '在这里输入内容...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _displayText.isEmpty ? '（输入内容将在这里实时显示）' : _displayText,
                  style: TextStyle(
                    color: _displayText.isEmpty ? Colors.grey : Colors.blue[800],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SectionTitle('带装饰的输入框'),
        _buildCard(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: '搜索',
                  hintText: '搜索内容...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {},
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: '手机号',
                  prefixIcon: Icon(Icons.phone),
                  prefixText: '+86 ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: '金额',
                  prefixIcon: Icon(Icons.attach_money),
                  suffixText: '元',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),

        const SectionTitle('密码输入框'),
        _buildCard(
          child: TextField(
            controller: _passwordController,
            obscureText: !_passwordVisible,
            decoration: InputDecoration(
              labelText: '密码',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() => _passwordVisible = !_passwordVisible);
                },
              ),
              border: const OutlineInputBorder(),
            ),
          ),
        ),

        const SectionTitle('多行输入'),
        _buildCard(
          child: TextField(
            controller: _multilineController,
            maxLines: 5,
            maxLength: 200,
            decoration: const InputDecoration(
              labelText: '详细描述',
              hintText: '请输入详细描述内容...',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
        ),

        const SectionTitle('输入验证（TextFormField + Form）'),
        _buildCard(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: '姓名',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入姓名';
                    }
                    if (value.length < 2) {
                      return '姓名至少 2 个字符';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: '邮箱',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入邮箱';
                    }
                    if (!value.contains('@')) {
                      return '请输入有效的邮箱地址';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '验证通过！姓名: ${_nameController.text}, 邮箱: ${_emailController.text}'),
                          ),
                        );
                      }
                    },
                    child: const Text('提交验证'),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SectionTitle('不同输入框样式'),
        _buildCard(
          child: const Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'OutlineInputBorder（默认）',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'UnderlineInputBorder',
                  border: UnderlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: '无边框 + 填充背景',
                  filled: true,
                  border: InputBorder.none,
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
