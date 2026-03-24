import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// ChangeNotifier 演示页面
/// 对应 SwiftUI 的 ObservableObject，使用 ChangeNotifier + ListenableBuilder
class ChangeNotifierDemoPage extends StatefulWidget {
  const ChangeNotifierDemoPage({super.key});

  @override
  State<ChangeNotifierDemoPage> createState() => _ChangeNotifierDemoPageState();
}

class _ChangeNotifierDemoPageState extends State<ChangeNotifierDemoPage> {
  /// 图书列表通知器
  late final BookListNotifier _bookListNotifier;

  /// 搜索控制器
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bookListNotifier = BookListNotifier();
    _searchController.addListener(() {
      _bookListNotifier.search(_searchController.text);
    });
  }

  @override
  void dispose() {
    _bookListNotifier.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'ChangeNotifier',
      subtitle: '对应 SwiftUI 的 ObservableObject，可观察的状态对象',
      conceptItems: const [
        'ChangeNotifier：可被监听的状态类，调用 notifyListeners() 通知变化',
        'ListenableBuilder：监听 ChangeNotifier 并自动重建 UI',
        'notifyListeners()：通知所有监听者状态已改变',
        '解耦逻辑与 UI：业务逻辑放在 Notifier 中，UI 只负责展示',
        'dispose()：记得在不需要时释放 ChangeNotifier',
      ],
      children: [
        const SectionTitle('搜索过滤'),
        _buildCard(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: '搜索书名...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => _searchController.clear(),
              ),
              border: const OutlineInputBorder(),
            ),
          ),
        ),

        const SectionTitle('图书列表（ListenableBuilder 监听）'),
        // 使用 ListenableBuilder 监听 ChangeNotifier
        ListenableBuilder(
          listenable: _bookListNotifier,
          builder: (context, _) {
            final books = _bookListNotifier.filteredBooks;
            final totalFavorites = _bookListNotifier.favoriteCount;

            return Column(
              children: [
                // 统计信息
                _buildCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statItem('总计', '${_bookListNotifier.books.length} 本'),
                      _statItem('已收藏', '$totalFavorites 本'),
                      _statItem('显示中', '${books.length} 本'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // 添加图书按钮
                _buildCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _showAddBookDialog,
                          icon: const Icon(Icons.add),
                          label: const Text('添加图书'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // 图书列表
                if (books.isEmpty)
                  _buildCard(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                            const SizedBox(height: 8),
                            Text('没有找到匹配的图书',
                                style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  ...books.map((book) => _buildBookItem(book)),
              ],
            );
          },
        ),
      ],
    );
  }

  /// 显示添加图书对话框
  void _showAddBookDialog() {
    final titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('添加图书'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: '书名',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  _bookListNotifier.addBook(titleController.text);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('添加'),
            ),
          ],
        );
      },
    );
  }

  /// 构建图书列表项
  Widget _buildBookItem(Book book) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: book.isFavorite ? Colors.amber[100] : Colors.grey[200],
          child: Icon(
            Icons.book,
            color: book.isFavorite ? Colors.amber[800] : Colors.grey,
          ),
        ),
        title: Text(book.title),
        subtitle: Text(book.isFavorite ? '已收藏' : '未收藏',
            style: TextStyle(
                color: book.isFavorite ? Colors.amber[800] : Colors.grey,
                fontSize: 12)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                book.isFavorite ? Icons.star : Icons.star_border,
                color: book.isFavorite ? Colors.amber : Colors.grey,
              ),
              onPressed: () => _bookListNotifier.toggleFavorite(book.id),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _bookListNotifier.removeBook(book.id),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
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

// ==================== 数据模型 ====================

/// 图书模型
class Book {
  final String id;
  final String title;
  bool isFavorite;

  Book({required this.id, required this.title, this.isFavorite = false});
}

// ==================== ChangeNotifier ====================

/// 图书列表 ChangeNotifier
/// 对应 SwiftUI 的 ObservableObject
class BookListNotifier extends ChangeNotifier {
  /// 图书列表
  final List<Book> _books = [
    Book(id: '1', title: 'Flutter 实战', isFavorite: true),
    Book(id: '2', title: 'Dart 编程语言'),
    Book(id: '3', title: '设计模式'),
    Book(id: '4', title: '重构：改善既有代码的设计', isFavorite: true),
    Book(id: '5', title: '代码大全'),
  ];

  /// 搜索关键词
  String _searchQuery = '';

  /// 自增 ID
  int _nextId = 6;

  /// 获取所有图书
  List<Book> get books => _books;

  /// 获取过滤后的图书
  List<Book> get filteredBooks {
    if (_searchQuery.isEmpty) return _books;
    return _books
        .where((b) => b.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  /// 收藏数量
  int get favoriteCount => _books.where((b) => b.isFavorite).length;

  /// 添加图书
  void addBook(String title) {
    _books.add(Book(id: '${_nextId++}', title: title));
    notifyListeners();
  }

  /// 删除图书
  void removeBook(String id) {
    _books.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  /// 切换收藏状态
  void toggleFavorite(String id) {
    final book = _books.firstWhere((b) => b.id == id);
    book.isFavorite = !book.isFavorite;
    notifyListeners();
  }

  /// 搜索
  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
