import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// TabBar Demo
/// 演示 TabBar + TabBarView、BottomNavigationBar、NavigationBar、自定义指示器
class TabBarDemoPage extends StatefulWidget {
  const TabBarDemoPage({super.key});

  @override
  State<TabBarDemoPage> createState() => _TabBarDemoPageState();
}

class _TabBarDemoPageState extends State<TabBarDemoPage> {
  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'TabBar 标签导航',
      subtitle: '演示 Flutter 中多种标签页和导航栏组件',
      conceptItems: const [
        'DefaultTabController：为后代组件提供 TabController，无需手动管理',
        'TabBar + TabBarView：顶部标签页，需配合 TabController 使用',
        'BottomNavigationBar：底部导航栏（Material 2 风格）',
        'NavigationBar：底部导航栏（Material 3 风格）',
        'indicator：自定义 TabBar 的指示器样式',
      ],
      children: [
        const SectionTitle('1. TabBar + TabBarView（顶部标签）'),
        _buildTopTabBarExample(),
        const SizedBox(height: 16),

        const SectionTitle('2. BottomNavigationBar 预览'),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _BottomNavBarExample()),
            );
          },
          icon: const Icon(Icons.navigation),
          label: const Text('查看底部导航栏示例'),
        ),
        const SizedBox(height: 16),

        const SectionTitle('3. NavigationBar (Material 3) 预览'),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _NavigationBarExample()),
            );
          },
          icon: const Icon(Icons.navigation_outlined),
          label: const Text('查看 Material 3 导航栏示例'),
        ),
        const SizedBox(height: 16),

        const SectionTitle('4. 自定义 Tab 指示器'),
        _buildCustomIndicatorTabBar(),
      ],
    );
  }

  /// 顶部 TabBar 示例
  Widget _buildTopTabBarExample() {
    return SizedBox(
      height: 260,
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            // TabBar
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.home), text: '首页'),
                  Tab(icon: Icon(Icons.explore), text: '发现'),
                  Tab(icon: Icon(Icons.person), text: '我的'),
                ],
              ),
            ),
            // TabBarView
            Expanded(
              child: TabBarView(
                children: [
                  _buildTabContent('首页', Icons.home, Colors.blue),
                  _buildTabContent('发现', Icons.explore, Colors.green),
                  _buildTabContent('我的', Icons.person, Colors.orange),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 自定义指示器 TabBar
  Widget _buildCustomIndicatorTabBar() {
    return SizedBox(
      height: 260,
      child: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                // 自定义指示器
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Colors.grey,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: '全部'),
                  Tab(text: '技术'),
                  Tab(text: '文学'),
                  Tab(text: '科学'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildTabContent('全部书籍', Icons.menu_book, Colors.purple),
                  _buildTabContent('技术书籍', Icons.computer, Colors.blue),
                  _buildTabContent('文学作品', Icons.auto_stories, Colors.red),
                  _buildTabContent('科学读物', Icons.science, Colors.teal),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(String label, IconData icon, Color color) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: color),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

/// BottomNavigationBar 完整示例页面
class _BottomNavBarExample extends StatefulWidget {
  const _BottomNavBarExample();

  @override
  State<_BottomNavBarExample> createState() => _BottomNavBarExampleState();
}

class _BottomNavBarExampleState extends State<_BottomNavBarExample> {
  int _currentIndex = 0;

  final _pages = const [
    _SampleTabPage(title: '首页', icon: Icons.home, color: Colors.blue),
    _SampleTabPage(title: '搜索', icon: Icons.search, color: Colors.green),
    _SampleTabPage(title: '收藏', icon: Icons.favorite, color: Colors.red),
    _SampleTabPage(title: '设置', icon: Icons.settings, color: Colors.grey),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BottomNavigationBar')),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '搜索'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '收藏'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '设置'),
        ],
      ),
    );
  }
}

/// NavigationBar (Material 3) 完整示例页面
class _NavigationBarExample extends StatefulWidget {
  const _NavigationBarExample();

  @override
  State<_NavigationBarExample> createState() => _NavigationBarExampleState();
}

class _NavigationBarExampleState extends State<_NavigationBarExample> {
  int _currentIndex = 0;

  final _pages = const [
    _SampleTabPage(title: '首页', icon: Icons.home, color: Colors.blue),
    _SampleTabPage(title: '消息', icon: Icons.message, color: Colors.purple),
    _SampleTabPage(title: '个人', icon: Icons.person, color: Colors.orange),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NavigationBar (Material 3)')),
      body: _pages[_currentIndex],
      // Material 3 的 NavigationBar
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: '首页'),
          NavigationDestination(icon: Icon(Icons.message_outlined), selectedIcon: Icon(Icons.message), label: '消息'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: '个人'),
        ],
      ),
    );
  }
}

/// 标签页内容示例
class _SampleTabPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SampleTabPage({required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: color),
          const SizedBox(height: 16),
          Text(title, style: TextStyle(fontSize: 24, color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('这是「$title」标签页', style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
