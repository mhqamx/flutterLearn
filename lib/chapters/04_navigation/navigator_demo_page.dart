import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// Navigator 页面导航 Demo
/// 演示 Navigator.push / pop、参数传递、返回值接收、多级导航
class NavigatorDemoPage extends StatefulWidget {
  const NavigatorDemoPage({super.key});

  @override
  State<NavigatorDemoPage> createState() => _NavigatorDemoPageState();
}

class _NavigatorDemoPageState extends State<NavigatorDemoPage> {
  String _returnMessage = '尚未收到返回值';

  // 示例书籍数据
  final List<Map<String, String>> _books = [
    {'title': 'Flutter 实战', 'author': '杜文', 'desc': '全面介绍 Flutter 开发技术'},
    {'title': 'Dart 编程语言', 'author': '张三', 'desc': '深入理解 Dart 语法'},
    {'title': '移动端架构', 'author': '李四', 'desc': '移动应用架构设计模式'},
  ];

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Navigator 页面导航',
      subtitle: '演示 Flutter 中使用 Navigator 进行页面跳转、参数传递与返回值接收',
      conceptItems: const [
        'Navigator.push：将新路由压入导航栈，实现页面跳转',
        'Navigator.pop：从导航栈弹出当前路由，返回上一页',
        'MaterialPageRoute：Material 风格的页面路由，带有平台自适应过渡动画',
        'await Navigator.push：等待目标页面返回结果，实现页面间通信',
        '路由参数：通过构造函数向目标页面传递数据',
      ],
      children: [
        const SectionTitle('1. 基础页面跳转'),
        ElevatedButton.icon(
          onPressed: () {
            // 使用 Navigator.push 跳转到新页面
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const _SimplePage(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_forward),
          label: const Text('Navigator.push 跳转'),
        ),
        const SizedBox(height: 16),

        const SectionTitle('2. 接收返回值'),
        ElevatedButton.icon(
          onPressed: () async {
            // await 等待返回值
            final result = await Navigator.push<String>(
              context,
              MaterialPageRoute(
                builder: (context) => const _ReturnValuePage(),
              ),
            );
            if (result != null) {
              setState(() {
                _returnMessage = '收到返回值: $result';
              });
            }
          },
          icon: const Icon(Icons.reply),
          label: const Text('跳转并等待返回值'),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(_returnMessage, style: const TextStyle(fontSize: 14)),
        ),
        const SizedBox(height: 16),

        const SectionTitle('3. 多级导航（书单 -> 书详情 -> 作者信息）'),
        ...List.generate(_books.length, (index) {
          final book = _books[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.primaries[index % Colors.primaries.length],
                child: Text(book['title']![0]),
              ),
              title: Text(book['title']!),
              subtitle: Text(book['author']!),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // 传递参数到下一页
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _BookDetailPage(
                      title: book['title']!,
                      author: book['author']!,
                      description: book['desc']!,
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}

/// 简单跳转目标页面
class _SimplePage extends StatelessWidget {
  const _SimplePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('新页面')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            const Text('这是通过 Navigator.push 跳转的页面', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Navigator.pop 返回'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 带返回值的页面
class _ReturnValuePage extends StatelessWidget {
  const _ReturnValuePage();

  @override
  Widget build(BuildContext context) {
    final options = ['选项 A - 苹果', '选项 B - 香蕉', '选项 C - 橙子'];
    return Scaffold(
      appBar: AppBar(title: const Text('选择一个选项')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: options.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text(options[index]),
              trailing: const Icon(Icons.check),
              onTap: () {
                // 通过 Navigator.pop 返回结果
                Navigator.pop(context, options[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

/// 书籍详情页
class _BookDetailPage extends StatelessWidget {
  final String title;
  final String author;
  final String description;

  const _BookDetailPage({
    required this.title,
    required this.author,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 书籍封面占位
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.deepPurple, Colors.blue],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('作者: $author', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(description, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            // 跳转到作者信息页（第三级导航）
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _AuthorPage(authorName: author),
                  ),
                );
              },
              icon: const Icon(Icons.person),
              label: Text('查看作者「$author」的信息'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 作者信息页（第三级页面）
class _AuthorPage extends StatelessWidget {
  final String authorName;

  const _AuthorPage({required this.authorName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('作者: $authorName')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.deepPurple,
              child: Text(
                authorName[0],
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(authorName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('资深技术作者', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            const Text('著有多本技术书籍，专注于移动开发领域'),
            const SizedBox(height: 24),
            // 返回到书单根页面
            OutlinedButton.icon(
              onPressed: () {
                // popUntil 返回到根页面
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: const Icon(Icons.home),
              label: const Text('返回书单首页'),
            ),
          ],
        ),
      ),
    );
  }
}
