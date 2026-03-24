import 'package:flutter/material.dart';
import 'package:flutter_learn/core/components/error_view.dart';
import 'package:flutter_learn/core/components/loading_view.dart';
import 'package:flutter_learn/core/models/news_article.dart';
import 'package:flutter_learn/modules/home/home_banner_widget.dart';
import 'package:flutter_learn/modules/home/home_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _viewModel = HomeViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.loadAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('首页')),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading) return const LoadingView();
          if (_viewModel.error != null) {
            return ErrorView(
              message: _viewModel.error!.message,
              onRetry: () => _viewModel.loadAll(),
            );
          }
          return RefreshIndicator(
            onRefresh: () => _viewModel.loadAll(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                HomeBannerWidget(items: _viewModel.banners),
                const SizedBox(height: 20),
                // 快速入口
                _buildQuickEntry(),
                const SizedBox(height: 20),
                // 推荐内容
                _buildSectionHeader('推荐内容'),
                const SizedBox(height: 8),
                ..._viewModel.recommends.map(_buildRecommendRow),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickEntry() {
    final entries = [
      ('政务', Icons.account_balance, Colors.blue),
      ('教育', Icons.school, Colors.green),
      ('医疗', Icons.local_hospital, Colors.red),
      ('交通', Icons.directions_bus, Colors.orange),
      ('生活', Icons.home, Colors.purple),
      ('社保', Icons.security, Colors.teal),
      ('公积金', Icons.savings, Colors.indigo),
      ('更多', Icons.more_horiz, Colors.grey),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
      ),
      itemCount: entries.length,
      itemBuilder: (context, i) {
        final (label, icon, color) = entries[i];
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Spacer(),
        TextButton(onPressed: () {}, child: const Text('更多')),
      ],
    );
  }

  Widget _buildRecommendRow(NewsArticle article) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(article.formattedTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(article.summary, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(article.category, style: TextStyle(fontSize: 11, color: Colors.blue[600])),
            const SizedBox(height: 4),
            Text(article.publishedAt, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}
