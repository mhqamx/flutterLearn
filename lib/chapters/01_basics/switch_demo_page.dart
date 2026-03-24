import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// Switch 演示页面
/// 展示 Switch、CupertinoSwitch、Checkbox 等开关类组件
class SwitchDemoPage extends StatefulWidget {
  const SwitchDemoPage({super.key});

  @override
  State<SwitchDemoPage> createState() => _SwitchDemoPageState();
}

class _SwitchDemoPageState extends State<SwitchDemoPage> {
  /// Material Switch 状态
  bool _materialSwitch = false;

  /// Cupertino Switch 状态
  bool _cupertinoSwitch = true;

  /// SwitchListTile 状态
  bool _wifiEnabled = true;
  bool _bluetoothEnabled = false;
  bool _airplaneMode = false;

  /// Checkbox 状态
  bool _agreeTerms = false;
  bool _subscribeNews = true;
  bool? _selectAll; // 三态 Checkbox

  /// CheckboxListTile 状态
  final Map<String, bool> _languages = {
    'Dart': true,
    'Swift': false,
    'Kotlin': false,
    'TypeScript': true,
  };

  /// 更新全选状态
  void _updateSelectAll() {
    final allSelected = _languages.values.every((v) => v);
    final noneSelected = _languages.values.every((v) => !v);
    setState(() {
      _selectAll = allSelected
          ? true
          : noneSelected
              ? false
              : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 计算初始全选状态
    final allSelected = _languages.values.every((v) => v);
    final noneSelected = _languages.values.every((v) => !v);
    _selectAll = allSelected ? true : noneSelected ? false : null;

    return DemoScaffold(
      title: 'Switch 开关',
      subtitle: '展示 Switch、CupertinoSwitch、Checkbox 等开关类组件',
      conceptItems: const [
        'Switch：Material Design 风格的开关',
        'CupertinoSwitch：iOS 风格的开关',
        'SwitchListTile：带标题描述的开关列表项',
        'Checkbox：复选框，支持二态和三态',
        'CheckboxListTile：带标题描述的复选框列表项',
      ],
      children: [
        const SectionTitle('Material Switch'),
        _buildCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _materialSwitch ? '已开启' : '已关闭',
                style: TextStyle(
                  fontSize: 16,
                  color: _materialSwitch ? Colors.green : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Switch(
                value: _materialSwitch,
                onChanged: (value) => setState(() => _materialSwitch = value),
              ),
            ],
          ),
        ),

        const SectionTitle('Cupertino Switch（iOS 风格）'),
        _buildCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _cupertinoSwitch ? '已开启' : '已关闭',
                style: TextStyle(
                  fontSize: 16,
                  color: _cupertinoSwitch ? Colors.green : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CupertinoSwitch(
                value: _cupertinoSwitch,
                activeTrackColor: CupertinoColors.activeGreen,
                onChanged: (value) =>
                    setState(() => _cupertinoSwitch = value),
              ),
            ],
          ),
        ),

        const SectionTitle('SwitchListTile（设置页风格）'),
        _buildCard(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Wi-Fi'),
                subtitle: Text(_wifiEnabled ? '已连接到网络' : '已关闭'),
                secondary: Icon(Icons.wifi,
                    color: _wifiEnabled ? Colors.blue : Colors.grey),
                value: _wifiEnabled,
                onChanged: (value) =>
                    setState(() => _wifiEnabled = value),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('蓝牙'),
                subtitle: Text(_bluetoothEnabled ? '已开启' : '已关闭'),
                secondary: Icon(Icons.bluetooth,
                    color: _bluetoothEnabled ? Colors.blue : Colors.grey),
                value: _bluetoothEnabled,
                onChanged: (value) =>
                    setState(() => _bluetoothEnabled = value),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('飞行模式'),
                subtitle: Text(_airplaneMode ? '已开启，所有无线通信已关闭' : '已关闭'),
                secondary: Icon(Icons.airplanemode_active,
                    color: _airplaneMode ? Colors.orange : Colors.grey),
                value: _airplaneMode,
                onChanged: (value) =>
                    setState(() => _airplaneMode = value),
              ),
            ],
          ),
        ),

        const SectionTitle('Checkbox'),
        _buildCard(
          child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _agreeTerms,
                    onChanged: (value) =>
                        setState(() => _agreeTerms = value ?? false),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _agreeTerms = !_agreeTerms),
                    child: const Text('我同意用户协议'),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: _subscribeNews,
                    onChanged: (value) =>
                        setState(() => _subscribeNews = value ?? false),
                  ),
                  GestureDetector(
                    onTap: () =>
                        setState(() => _subscribeNews = !_subscribeNews),
                    child: const Text('订阅新闻通知'),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SectionTitle('CheckboxListTile + 全选'),
        _buildCard(
          child: Column(
            children: [
              CheckboxListTile(
                title: const Text('全选'),
                subtitle: const Text('选择所有编程语言'),
                tristate: true,
                value: _selectAll,
                onChanged: (value) {
                  setState(() {
                    final newValue = value ?? false;
                    _languages.updateAll((key, _) => newValue);
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const Divider(height: 1),
              ..._languages.entries.map((entry) {
                return CheckboxListTile(
                  title: Text(entry.key),
                  value: entry.value,
                  onChanged: (value) {
                    setState(() {
                      _languages[entry.key] = value ?? false;
                    });
                    _updateSelectAll();
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  dense: true,
                );
              }),
            ],
          ),
        ),

        const SectionTitle('状态汇总'),
        _buildCard(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Material Switch: ${_materialSwitch ? "ON" : "OFF"}'),
                Text('Cupertino Switch: ${_cupertinoSwitch ? "ON" : "OFF"}'),
                Text('Wi-Fi: ${_wifiEnabled ? "ON" : "OFF"}'),
                Text('蓝牙: ${_bluetoothEnabled ? "ON" : "OFF"}'),
                Text('飞行模式: ${_airplaneMode ? "ON" : "OFF"}'),
                Text('同意协议: ${_agreeTerms ? "是" : "否"}'),
                Text(
                    '选中的语言: ${_languages.entries.where((e) => e.value).map((e) => e.key).join(", ")}'),
              ],
            ),
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
