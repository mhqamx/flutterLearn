import 'package:flutter/foundation.dart';
import 'package:flutter_learn/core/models/news_article.dart';
import 'package:flutter_learn/core/network/api_endpoint.dart';
import 'package:flutter_learn/core/network/api_error.dart';
import 'package:flutter_learn/core/network/network_manager.dart';

class NewsViewModel extends ChangeNotifier {
  final _network = NetworkManager.shared;

  List<NewsArticle> articles = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;
  ApiException? error;
  String searchText = '';

  int _currentPage = 1;
  static const _pageSize = 15;

  List<NewsArticle> get filteredArticles {
    if (searchText.isEmpty) return articles;
    final query = searchText.toLowerCase();
    return articles.where((a) =>
        a.title.toLowerCase().contains(query) ||
        a.body.toLowerCase().contains(query)).toList();
  }

  void updateSearch(String text) {
    searchText = text;
    notifyListeners();
  }

  Future<void> loadArticles() async {
    _currentPage = 1;
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      articles = await _network.request(
        ApiEndpoint.newsList(page: 1, limit: _pageSize),
        fromJson: NewsArticle.fromJsonList,
      );
      hasMore = articles.length >= _pageSize;
      _currentPage = 2;
    } on ApiException catch (e) {
      error = e;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (isLoadingMore || !hasMore) return;
    isLoadingMore = true;
    notifyListeners();

    try {
      final result = await _network.request(
        ApiEndpoint.newsList(page: _currentPage, limit: _pageSize),
        fromJson: NewsArticle.fromJsonList,
      );
      articles.addAll(result);
      hasMore = result.length >= _pageSize;
      _currentPage++;
    } catch (_) {}

    isLoadingMore = false;
    notifyListeners();
  }
}
