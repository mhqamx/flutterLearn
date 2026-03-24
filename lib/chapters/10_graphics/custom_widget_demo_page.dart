import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

class CustomWidgetDemoPage extends StatefulWidget {
  const CustomWidgetDemoPage({super.key});

  @override
  State<CustomWidgetDemoPage> createState() => _CustomWidgetDemoPageState();
}

class _CustomWidgetDemoPageState extends State<CustomWidgetDemoPage> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDark ? ThemeData.dark(useMaterial3: true) : ThemeData.light(useMaterial3: true),
      child: DemoScaffold(
        title: '自定义 Widget',
        subtitle: '组合现有 Widget 创建可复用的自定义组件',
        conceptItems: const [
          'Widget 组合：通过嵌套现有 Widget 构建自定义组件',
          'Theme：通过 ThemeData 统一管理应用样式',
          'InkWell：带水波纹效果的可点击区域',
          'Badge：Material 3 角标组件',
          'Extension：通过扩展方法增强 Widget 能力',
        ],
        children: [
          // 主题切换
          const SectionTitle('Theme 主题切换'),
          SwitchListTile(
            title: const Text('深色模式'),
            subtitle: const Text('切换 ThemeData.dark / ThemeData.light'),
            value: _isDark,
            onChanged: (v) => setState(() => _isDark = v),
          ),

          // 自定义 InfoCard
          const SectionTitle('自定义 InfoCard 组件'),
          const InfoCard(
            icon: Icons.flutter_dash,
            title: 'Flutter',
            subtitle: 'Google 的跨平台 UI 框架',
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          const InfoCard(
            icon: Icons.code,
            title: 'Dart',
            subtitle: '专为客户端优化的编程语言',
            color: Colors.teal,
          ),
          const SizedBox(height: 12),
          const InfoCard(
            icon: Icons.widgets,
            title: 'Widget',
            subtitle: 'Flutter 中一切皆 Widget',
            color: Colors.orange,
          ),

          // Badge 图标
          const SectionTitle('BadgeIcon 角标组件'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BadgeIcon(icon: Icons.mail, count: 5, color: Colors.red, onTap: () {}),
              BadgeIcon(icon: Icons.shopping_cart, count: 3, color: Colors.green, onTap: () {}),
              BadgeIcon(icon: Icons.notifications, count: 12, color: Colors.orange, onTap: () {}),
              BadgeIcon(icon: Icons.chat, count: 0, color: Colors.blue, onTap: () {}),
            ],
          ),

          // 统计卡片
          const SectionTitle('StatCard 统计组件'),
          Row(
            children: const [
              Expanded(child: StatCard(label: '今日阅读', value: '42', unit: '篇', color: Colors.blue)),
              SizedBox(width: 12),
              Expanded(child: StatCard(label: '学习时长', value: '3.5', unit: '小时', color: Colors.green)),
              SizedBox(width: 12),
              Expanded(child: StatCard(label: '完成任务', value: '8', unit: '个', color: Colors.orange)),
            ],
          ),
        ],
      ),
    );
  }
}

/// 自定义信息卡片组件
class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}

/// 带角标的图标组件
class BadgeIcon extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color color;
  final VoidCallback? onTap;

  const BadgeIcon({
    super.key,
    required this.icon,
    required this.count,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Badge(
          isLabelVisible: count > 0,
          label: Text('$count', style: const TextStyle(fontSize: 10)),
          child: Icon(icon, size: 32, color: color),
        ),
      ),
    );
  }
}

/// 统计卡片组件
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
          Text(unit, style: TextStyle(fontSize: 12, color: color.withValues(alpha: 0.7))),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
