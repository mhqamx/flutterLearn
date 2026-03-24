import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences 演示页面
/// 展示键值对本地持久化存储（对应 iOS AppStorage）
class SharedPrefsDemoPage extends StatefulWidget {
  const SharedPrefsDemoPage({super.key});

  @override
  State<SharedPrefsDemoPage> createState() => _SharedPrefsDemoPageState();
}

class _SharedPrefsDemoPageState extends State<SharedPrefsDemoPage> {
  // 存储的值
  String _storedString = '';
  int _storedInt = 0;
  bool _storedBool = false;
  int _counter = 0;
  bool _isDarkTheme = false;

  // 输入控制器
  final _stringController = TextEditingController();
  final _intController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAllValues();
  }

  @override
  void dispose() {
    _stringController.dispose();
    _intController.dispose();
    super.dispose();
  }

  /// 加载所有已存储的值
  Future<void> _loadAllValues() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedString = prefs.getString('demo_string') ?? '未设置';
      _storedInt = prefs.getInt('demo_int') ?? 0;
      _storedBool = prefs.getBool('demo_bool') ?? false;
      _counter = prefs.getInt('demo_counter') ?? 0;
      _isDarkTheme = prefs.getBool('demo_dark_theme') ?? false;
    });
  }

  /// 保存字符串
  Future<void> _saveString() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('demo_string', _stringController.text);
    _loadAllValues();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('字符串已保存'), duration: Duration(seconds: 1)),
      );
    }
  }

  /// 保存整数
  Future<void> _saveInt() async {
    final value = int.tryParse(_intController.text);
    if (value == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('demo_int', value);
    _loadAllValues();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('整数已保存'), duration: Duration(seconds: 1)),
      );
    }
  }

  /// 切换布尔值
  Future<void> _toggleBool(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('demo_bool', value);
    _loadAllValues();
  }

  /// 增加计数器
  Future<void> _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    _counter++;
    await prefs.setInt('demo_counter', _counter);
    setState(() {});
  }

  /// 重置计数器
  Future<void> _resetCounter() async {
    final prefs = await SharedPreferences.getInstance();
    _counter = 0;
    await prefs.setInt('demo_counter', _counter);
    setState(() {});
  }

  /// 切换主题偏好
  Future<void> _toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('demo_dark_theme', value);
    setState(() {
      _isDarkTheme = value;
    });
  }

  /// 清除所有存储
  Future<void> _clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('demo_string');
    await prefs.remove('demo_int');
    await prefs.remove('demo_bool');
    await prefs.remove('demo_counter');
    await prefs.remove('demo_dark_theme');
    _stringController.clear();
    _intController.clear();
    _loadAllValues();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('所有数据已清除'), duration: Duration(seconds: 1)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'SharedPreferences',
      subtitle: '轻量级键值对存储，适合保存用户偏好设置（对应 iOS AppStorage）',
      conceptItems: const [
        'SharedPreferences：基于键值对的本地持久化存储',
        'setString/getInt/setBool：支持 String、int、double、bool、List<String>',
        'getInstance()：获取 SharedPreferences 实例（异步）',
        'remove/clear：删除指定 key 或清除所有数据',
        '适用场景：用户偏好、主题设置、简单配置项',
      ],
      children: [
        const SectionTitle('存储字符串'),
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('当前值: $_storedString',
                  style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _stringController,
                      decoration: const InputDecoration(
                        hintText: '输入字符串...',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(onPressed: _saveString, child: const Text('保存')),
                ],
              ),
            ],
          ),
        ),

        const SectionTitle('存储整数'),
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('当前值: $_storedInt',
                  style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _intController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: '输入整数...',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(onPressed: _saveInt, child: const Text('保存')),
                ],
              ),
            ],
          ),
        ),

        const SectionTitle('存储布尔值'),
        _buildCard(
          child: SwitchListTile(
            title: const Text('布尔值开关'),
            subtitle: Text('当前值: $_storedBool'),
            value: _storedBool,
            onChanged: _toggleBool,
          ),
        ),

        const SectionTitle('主题偏好存储'),
        _buildCard(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isDarkTheme ? Colors.grey[800] : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Icon(
                  _isDarkTheme ? Icons.dark_mode : Icons.light_mode,
                  size: 48,
                  color: _isDarkTheme ? Colors.amber : Colors.orange,
                ),
                const SizedBox(height: 8),
                Text(
                  _isDarkTheme ? '深色模式' : '浅色模式',
                  style: TextStyle(
                    fontSize: 16,
                    color: _isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Switch(
                  value: _isDarkTheme,
                  onChanged: _toggleTheme,
                ),
                Text(
                  '此偏好会持久化保存，退出后再进入仍生效',
                  style: TextStyle(
                    fontSize: 12,
                    color: _isDarkTheme ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SectionTitle('持久化计数器'),
        _buildCard(
          child: Column(
            children: [
              Text(
                '$_counter',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('退出页面再返回，计数值仍然保留',
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _incrementCounter,
                    icon: const Icon(Icons.add),
                    label: const Text('增加'),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: _resetCounter,
                    icon: const Icon(Icons.refresh),
                    label: const Text('重置'),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _clearAll,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            label: const Text('清除所有存储', style: TextStyle(color: Colors.red)),
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
