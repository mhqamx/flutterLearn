import 'package:flutter/foundation.dart';
import 'package:flutter_learn/core/models/news_article.dart';
import 'package:flutter_learn/core/network/api_endpoint.dart';
import 'package:flutter_learn/core/network/api_error.dart';
import 'package:flutter_learn/core/network/network_manager.dart';

class HomeViewModel extends ChangeNotifier {
  final _network = NetworkManager.shared;

  List<NewsArticle> banners = [];
  List<NewsArticle> recommends = [];
  bool isLoading = false;
  ApiException? error;

  Future<void> loadAll() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _network.request(
          '${ApiEndpoint.homeBanners}?_limit=5',
          fromJson: (json) => (json as List).map((e) =>
            NewsArticle(id: e['id'], userId: e['userId'] ?? 1, title: e['title'] ?? '', body: '')).toList(),
        ),
        _network.request(
          '${ApiEndpoint.homeRecommend}?_limit=10',
          fromJson: NewsArticle.fromJsonList,
        ),
      ]);
      banners = results[0];
      recommends = results[1];
    } on ApiException catch (e) {
      error = e;
    } catch (e) {
      error = ApiException(ApiError.unknown, detail: e.toString());
    }

    isLoading = false;
    notifyListeners();
  }
}
