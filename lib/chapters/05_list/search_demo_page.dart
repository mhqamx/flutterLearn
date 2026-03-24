import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// 搜索功能 Demo
/// 演示 SearchBar、SearchDelegate、实时搜索过滤、搜索历史、热门标签
class SearchDemoPage extends StatefulWidget {
  const SearchDemoPage({super.key});

  @override
  State<SearchDemoPage> createState() => _SearchDemoPageState();
}

class _SearchDemoPageState extends State<SearchDemoPage> {
  // 示例书籍数据
  final List<String> _allBooks = [
    'Flutter 实战', 'Dart 编程语言', '移动端架构设计', '深入理解 Widget',
    '状态管理实践', 'UI 动画进阶', '网络编程指南', '测试驱动开发',
    'Flutter Web 开发', 'Flutter Desktop 应用', '响应式编程', 'Bloc 状态管理',
    'Provider 入门', 'GetX 实践', 'Riverpod 进阶', '自定义绘制',
  ];

  // 搜索历史
  final List<String> _searchHistory = ['Flutter', 'Dart', 'Widget'];

  // 热门搜索标签
  final List<String> _hotTags = ['Flutter', '动画', '状态管理', '网络', '架构', '测试'];

  // 实时搜索
  String _searchText = '';
  final _searchController = TextEditingController();

  List<String> get _filteredBooks {
    if (_searchText.isEmpty) return _allBooks;
    return _allBooks.where((b) => b.toLowerCase().contains(_searchText.toLowerCase())).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: '搜索功能',
      subtitle: '演示 Flutter 中多种搜索方式，包括搜索栏、搜索代理和实时过滤',
      conceptItems: const [
        'SearchBar：Material 3 搜索栏组件，支持建议列表',
        'showSearch + SearchDelegate：全屏搜索页面，支持搜索建议和结果展示',
        'TextField + 过滤：使用 onChanged 实现实时搜索过滤',
        'Chip/ActionChip：用于展示热门搜索标签',
      ],
      children: [
        const SectionTitle('1. SearchBar Widget'),
        SearchBar(
          hintText: '搜索书籍...',
          leading: const Icon(Icons.search),
          trailing: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.mic),
            ),
          ],
          onTap: () {
            // 点击打开 SearchDelegate
            showSearch(context: context, delegate: _BookSearchDelegate(_allBooks, _searchHistory));
          },
        ),
        const SizedBox(height: 16),

        const SectionTitle('2. showSearch + SearchDelegate'),
        ElevatedButton.icon(
          onPressed: () {
            showSearch(
              context: context,
              delegate: _BookSearchDelegate(_allBooks, _searchHistory),
            );
          },
          icon: const Icon(Icons.search),
          label: const Text('打开全屏搜索'),
        ),
        const SizedBox(height: 16),

        const SectionTitle('3. 实时搜索过滤'),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: '输入关键词实时过滤...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchText.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchText = '');
                    },
                    icon: const Icon(Icons.clear),
                  )
                : null,
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) => setState(() => _searchText = value),
        ),
        const SizedBox(height: 8),
        Text('找到 ${_filteredBooks.length} 本书', style: TextStyle(color: Colors.grey[600])),
        const SizedBox(height: 8),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _filteredBooks.isEmpty
              ? const Center(child: Text('未找到匹配的书籍', style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  itemCount: _filteredBooks.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.book, size: 20),
                      title: Text(_filteredBooks[index]),
                    );
                  },
                ),
        ),
        const SizedBox(height: 16),

        const SectionTitle('4. 搜索历史'),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: _searchHistory.map((history) {
            return Chip(
              avatar: const Icon(Icons.history, size: 16),
              label: Text(history),
              onDeleted: () {
                setState(() => _searchHistory.remove(history));
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        const SectionTitle('5. 热门搜索标签'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _hotTags.map((tag) {
            return ActionChip(
              avatar: const Icon(Icons.local_fire_department, size: 16, color: Colors.orange),
              label: Text(tag),
              onPressed: () {
                setState(() {
                  _searchController.text = tag;
                  _searchText = tag;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// 自定义 SearchDelegate
class _BookSearchDelegate extends SearchDelegate<String> {
  final List<String> books;
  final List<String> history;

  _BookSearchDelegate(this.books, this.history);

  @override
  String get searchFieldLabel => '搜索书籍...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () => query = '',
          icon: const Icon(Icons.clear),
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, ''),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = books.where((b) => b.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.book),
          title: Text(results[index]),
          onTap: () => close(context, results[index]),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // 空查询时显示历史
    if (query.isEmpty) {
      return ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('搜索历史', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          ...history.map((h) => ListTile(
                leading: const Icon(Icons.history, color: Colors.grey),
                title: Text(h),
                onTap: () => query = h,
              )),
        ],
      );
    }

    // 有查询时显示建议
    final suggestions = books.where((b) => b.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.search),
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index];
            showResults(context);
          },
        );
      },
    );
  }
}
