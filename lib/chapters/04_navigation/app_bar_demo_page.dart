import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// AppBar Demo
/// 演示标准 AppBar、SliverAppBar、自定义 leading/actions、搜索模式
class AppBarDemoPage extends StatelessWidget {
  const AppBarDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'AppBar 应用栏',
      subtitle: '演示不同类型的 AppBar，包括标准、可折叠、自定义操作和搜索模式',
      conceptItems: const [
        'AppBar：Material 风格的顶部应用栏，包含 title、leading、actions',
        'SliverAppBar：可随滚动折叠/展开的应用栏，需配合 CustomScrollView',
        'leading：AppBar 左侧按钮，默认为返回按钮',
        'actions：AppBar 右侧操作按钮列表',
        'flexibleSpace：SliverAppBar 展开时显示的灵活空间',
      ],
      children: [
        const SectionTitle('1. 标准 AppBar（title + actions）'),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _StandardAppBarPage()),
            );
          },
          icon: const Icon(Icons.web_asset),
          label: const Text('查看标准 AppBar'),
        ),
        const SizedBox(height: 16),

        const SectionTitle('2. SliverAppBar（可折叠）'),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _SliverAppBarPage()),
            );
          },
          icon: const Icon(Icons.expand),
          label: const Text('查看可折叠 AppBar'),
        ),
        const SizedBox(height: 16),

        const SectionTitle('3. 自定义 leading / actions'),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _CustomActionsAppBarPage()),
            );
          },
          icon: const Icon(Icons.tune),
          label: const Text('查看自定义操作 AppBar'),
        ),
        const SizedBox(height: 16),

        const SectionTitle('4. 搜索模式 AppBar'),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _SearchAppBarPage()),
            );
          },
          icon: const Icon(Icons.search),
          label: const Text('查看搜索 AppBar'),
        ),
      ],
    );
  }
}

/// 标准 AppBar 页面
class _StandardAppBarPage extends StatelessWidget {
  const _StandardAppBarPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('标准 AppBar'),
        actions: [
          IconButton(
            onPressed: () => _showSnack(context, '点击了搜索'),
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () => _showSnack(context, '点击了更多'),
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: const Center(
        child: Text('标准 AppBar 包含 title 和 actions'),
      ),
    );
  }
}

/// SliverAppBar 可折叠页面
class _SliverAppBarPage extends StatelessWidget {
  const _SliverAppBarPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // 展开高度
            expandedHeight: 250,
            // 固定在顶部
            pinned: true,
            // 向下滚动时自动展开
            floating: false,
            // 可折叠区域
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('SliverAppBar'),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.deepPurple, Colors.blue, Colors.teal],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.landscape, size: 80, color: Colors.white54),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => _showSnack(context, '分享'),
                icon: const Icon(Icons.share),
              ),
            ],
          ),
          // 内容列表
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text('列表项 ${index + 1}'),
                subtitle: const Text('向上滚动查看 AppBar 折叠效果'),
              ),
              childCount: 30,
            ),
          ),
        ],
      ),
    );
  }
}

/// 自定义 leading / actions 页面
class _CustomActionsAppBarPage extends StatelessWidget {
  const _CustomActionsAppBarPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 自定义 leading
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
          tooltip: '自定义返回按钮',
        ),
        title: const Text('自定义操作'),
        // 自定义 actions
        actions: [
          // 带徽标的图标
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () => _showSnack(context, '通知'),
                icon: const Icon(Icons.notifications_outlined),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: const Center(
                    child: Text('3', style: TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                ),
              ),
            ],
          ),
          // 头像按钮
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => _showSnack(context, '用户头像'),
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.deepPurple,
                child: Text('U', style: TextStyle(color: Colors.white, fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('自定义 leading: 圆角返回按钮'),
            SizedBox(height: 8),
            Text('自定义 actions: 带徽标的通知 + 用户头像'),
          ],
        ),
      ),
    );
  }
}

/// 搜索模式 AppBar 页面
class _SearchAppBarPage extends StatefulWidget {
  const _SearchAppBarPage();

  @override
  State<_SearchAppBarPage> createState() => _SearchAppBarPageState();
}

class _SearchAppBarPageState extends State<_SearchAppBarPage> {
  bool _isSearching = false;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  final _items = List.generate(20, (i) => '书籍 ${i + 1}: Flutter 开发技巧第${i + 1}章');

  List<String> get _filteredItems {
    if (_searchQuery.isEmpty) return _items;
    return _items.where((item) => item.contains(_searchQuery)).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 搜索模式切换
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: '搜索书籍...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              )
            : const Text('搜索模式 AppBar'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchQuery = '';
                  _searchController.clear();
                } else {
                  _isSearching = true;
                }
              });
            },
            icon: Icon(_isSearching ? Icons.close : Icons.search),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _filteredItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.book),
            title: Text(_filteredItems[index]),
          );
        },
      ),
    );
  }
}

void _showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
  );
}
