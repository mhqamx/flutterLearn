import 'package:flutter/material.dart';
import 'package:flutter_learn/core/components/error_view.dart';
import 'package:flutter_learn/core/components/loading_view.dart';
import 'package:flutter_learn/modules/news/news_row_widget.dart';
import 'package:flutter_learn/modules/news/news_view_model.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final _viewModel = NewsViewModel();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _viewModel.loadArticles();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _viewModel.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新闻'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SearchBar(
              hintText: '搜索新闻',
              leading: const Icon(Icons.search),
              onChanged: (v) => _viewModel.updateSearch(v),
              elevation: WidgetStateProperty.all(0),
            ),
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading) return const LoadingView();
          if (_viewModel.error != null) {
            return ErrorView(
              message: _viewModel.error!.message,
              onRetry: () => _viewModel.loadArticles(),
            );
          }
          final articles = _viewModel.filteredArticles;
          if (articles.isEmpty) {
            return const EmptyStateView(
              icon: Icons.search_off,
              title: '没有找到相关新闻',
            );
          }
          return RefreshIndicator(
            onRefresh: () => _viewModel.loadArticles(),
            child: ListView.separated(
              controller: _scrollController,
              itemCount: articles.length + 1,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                if (index == articles.length) {
                  if (_viewModel.isLoadingMore) return const InlineLoadingView();
                  if (!_viewModel.hasMore) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: Text('已加载全部', style: TextStyle(color: Colors.grey, fontSize: 13))),
                    );
                  }
                  return const SizedBox.shrink();
                }
                final article = articles[index];
                return NewsRowWidget(
                  article: article,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => NewsDetailPage(article: article),
                    ));
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
