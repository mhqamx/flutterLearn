import 'package:flutter/material.dart';
import 'package:flutter_learn/modules/home/home_page.dart';
import 'package:flutter_learn/modules/mall/mall_page.dart';
import 'package:flutter_learn/modules/mine/mine_page.dart';
import 'package:flutter_learn/modules/news/news_page.dart';

class ModuleTabPage extends StatefulWidget {
  const ModuleTabPage({super.key});

  @override
  State<ModuleTabPage> createState() => _ModuleTabPageState();
}

class _ModuleTabPageState extends State<ModuleTabPage> {
  int _currentIndex = 0;

  final _pages = const [
    HomePage(),
    MallPage(),
    NewsPage(),
    MinePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: '首页'),
          NavigationDestination(icon: Icon(Icons.store_outlined), selectedIcon: Icon(Icons.store), label: '商城'),
          NavigationDestination(icon: Icon(Icons.article_outlined), selectedIcon: Icon(Icons.article), label: '新闻'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: '我的'),
        ],
      ),
    );
  }
}
