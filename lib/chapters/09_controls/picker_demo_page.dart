import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// 选择器演示页面
/// 展示各种选择器组件
class PickerDemoPage extends StatefulWidget {
  const PickerDemoPage({super.key});

  @override
  State<PickerDemoPage> createState() => _PickerDemoPageState();
}

class _PickerDemoPageState extends State<PickerDemoPage> {
  // DropdownButton
  String _selectedCity = '北京';
  final List<String> _cities = ['北京', '上海', '广州', '深圳', '杭州', '成都', '武汉'];

  // DatePicker
  DateTime _selectedDate = DateTime.now();

  // TimePicker
  TimeOfDay _selectedTime = TimeOfDay.now();

  // CupertinoPicker
  int _selectedFruitIndex = 0;
  final List<String> _fruits = ['苹果', '香蕉', '橙子', '草莓', '葡萄', '西瓜', '芒果', '桃子'];

  /// 显示日期选择器
  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('zh', 'CN'),
      helpText: '选择日期',
      cancelText: '取消',
      confirmText: '确定',
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  /// 显示时间选择器
  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      helpText: '选择时间',
      cancelText: '取消',
      confirmText: '确定',
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  /// 显示 CupertinoPicker 底部弹窗
  void _showCupertinoPicker() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 280,
          child: Column(
            children: [
              // 顶部栏
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: const Border(bottom: BorderSide(color: Colors.black12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('取消'),
                    ),
                    const Text('选择水果', style: TextStyle(fontWeight: FontWeight.w600)),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('确定'),
                    ),
                  ],
                ),
              ),
              // 滚轮选择器
              Expanded(
                child: CupertinoPicker(
                  magnification: 1.2,
                  squeeze: 1.2,
                  useMagnifier: true,
                  itemExtent: 40,
                  scrollController: FixedExtentScrollController(
                    initialItem: _selectedFruitIndex,
                  ),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedFruitIndex = index;
                    });
                  },
                  children: _fruits.map((fruit) {
                    return Center(
                      child: Text(fruit, style: const TextStyle(fontSize: 18)),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: '选择器',
      subtitle: '展示 DropdownButton、DatePicker、TimePicker、CupertinoPicker',
      conceptItems: const [
        'DropdownButton：下拉选择菜单，Material 风格',
        'showDatePicker：Material 日期选择对话框',
        'showTimePicker：Material 时间选择对话框',
        'CupertinoPicker：iOS 风格的滚轮选择器',
        'FixedExtentScrollController：控制滚轮初始选中项',
      ],
      children: [
        // DropdownButton
        const SectionTitle('DropdownButton 下拉选择'),
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('选择城市：', style: TextStyle(fontSize: 15)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedCity,
                      isExpanded: true,
                      items: _cities.map((city) {
                        return DropdownMenuItem(
                          value: city,
                          child: Text(city),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedCity = val!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_city, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text('当前选中: $_selectedCity',
                        style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),

        // DatePicker
        const SectionTitle('showDatePicker 日期选择'),
        _buildCard(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.green),
                title: const Text('选择日期'),
                subtitle: Text(
                  '${_selectedDate.year}年${_selectedDate.month}月${_selectedDate.day}日',
                  style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: _pickDate,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '星期${'一二三四五六日'[_selectedDate.weekday - 1]}  |  '
                  '今年第 ${_selectedDate.difference(DateTime(_selectedDate.year, 1, 1)).inDays + 1} 天',
                  style: TextStyle(fontSize: 13, color: Colors.green[700]),
                ),
              ),
            ],
          ),
        ),

        // TimePicker
        const SectionTitle('showTimePicker 时间选择'),
        _buildCard(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.access_time, color: Colors.orange),
                title: const Text('选择时间'),
                subtitle: Text(
                  '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: _pickTime,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _selectedTime.period == DayPeriod.am ? '上午' : '下午',
                  style: TextStyle(fontSize: 13, color: Colors.orange[700]),
                ),
              ),
            ],
          ),
        ),

        // CupertinoPicker
        const SectionTitle('CupertinoPicker 滚轮选择'),
        _buildCard(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.apple, color: Colors.red),
                title: const Text('选择水果'),
                subtitle: Text(
                  _fruits[_selectedFruitIndex],
                  style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: _showCupertinoPicker,
              ),
              // 当前选中的水果信息
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      _getFruitEmoji(_selectedFruitIndex),
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _fruits[_selectedFruitIndex],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          '索引: $_selectedFruitIndex',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getFruitEmoji(int index) {
    const emojis = ['🍎', '🍌', '🍊', '🍓', '🍇', '🍉', '🥭', '🍑'];
    return emojis[index % emojis.length];
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
