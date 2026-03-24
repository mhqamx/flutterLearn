import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// setState 演示页面
/// 对应 SwiftUI 的 @State，展示最基础的状态管理方式
class SetStateDemoPage extends StatefulWidget {
  const SetStateDemoPage({super.key});

  @override
  State<SetStateDemoPage> createState() => _SetStateDemoPageState();
}

class _SetStateDemoPageState extends State<SetStateDemoPage> {
  /// 借阅计数
  int _borrowCount = 0;

  /// 收藏状态
  bool _isFavorite = false;

  /// 5星评分
  int _rating = 0;

  /// 是否展开详情
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'setState 状态管理',
      subtitle: '对应 SwiftUI 的 @State，Flutter 最基础的状态管理方式',
      conceptItems: const [
        'StatefulWidget：有可变状态的组件，配合 State 类使用',
        'setState()：通知框架状态发生变化，触发重新构建',
        '状态局部性：setState 只影响当前组件及其子组件',
        '生命周期：initState → build → setState → build → dispose',
        '注意：不要在 build 方法中调用 setState',
      ],
      children: [
        const SectionTitle('借阅计数器'),
        _buildCard(
          child: Column(
            children: [
              const Text('当前借阅数量',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 8),
              Text('$_borrowCount',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _borrowCount > 0 ? Colors.blue : Colors.grey)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 减少按钮
                  IconButton.filled(
                    onPressed: _borrowCount > 0
                        ? () => setState(() => _borrowCount--)
                        : null,
                    icon: const Icon(Icons.remove),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      disabledBackgroundColor: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(width: 24),
                  // 增加按钮
                  IconButton.filled(
                    onPressed: () => setState(() => _borrowCount++),
                    icon: const Icon(Icons.add),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.green[400],
                    ),
                  ),
                ],
              ),
              if (_borrowCount >= 5)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('已借阅 $_borrowCount 本，注意及时归还！',
                      style: const TextStyle(color: Colors.orange, fontSize: 13)),
                ),
            ],
          ),
        ),

        const SectionTitle('收藏状态切换（带动画）'),
        _buildCard(
          child: GestureDetector(
            onTap: () => setState(() => _isFavorite = !_isFavorite),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey(_isFavorite),
                    color: _isFavorite ? Colors.red : Colors.grey,
                    size: 48,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  _isFavorite ? '已收藏' : '未收藏',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _isFavorite ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SectionTitle('5星评分交互'),
        _buildCard(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => setState(() {
                      // 点击已选中的最后一颗星可以取消
                      _rating = (index + 1 == _rating) ? 0 : index + 1;
                    }),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          key: ValueKey('star_$index${index < _rating}'),
                          color: index < _rating ? Colors.amber : Colors.grey[400],
                          size: 40,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              Text(
                _rating == 0
                    ? '点击星星评分'
                    : _ratingText(_rating),
                style: TextStyle(
                  fontSize: 15,
                  color: _rating > 0 ? Colors.amber[800] : Colors.grey,
                ),
              ),
            ],
          ),
        ),

        const SectionTitle('条件显示（展开/收起详情）'),
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Flutter 入门指南',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('作者：Google Flutter 团队',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        setState(() => _isExpanded = !_isExpanded),
                    icon: AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(Icons.keyboard_arrow_down, size: 28),
                    ),
                  ),
                ],
              ),
              // 展开/收起的详情区域
              AnimatedCrossFade(
                firstChild: const SizedBox(width: double.infinity),
                secondChild: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('书籍简介', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text(
                        'Flutter 是 Google 推出的跨平台 UI 开发框架，使用 Dart 语言编写。'
                        '它可以从一套代码库构建精美的、原生编译的多平台应用。\n\n'
                        '本书涵盖：\n'
                        '• Widget 基础和布局系统\n'
                        '• 状态管理和路由导航\n'
                        '• 动画和自定义绘制\n'
                        '• 网络请求和数据持久化',
                        style: TextStyle(fontSize: 14, height: 1.6),
                      ),
                    ],
                  ),
                ),
                crossFadeState: _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () =>
                      setState(() => _isExpanded = !_isExpanded),
                  child: Text(_isExpanded ? '收起详情' : '查看详情'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 评分文案
  String _ratingText(int rating) {
    const texts = ['', '很差', '较差', '一般', '不错', '非常好'];
    return '$rating 星 - ${texts[rating]}';
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
