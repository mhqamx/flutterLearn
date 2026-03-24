import 'package:flutter/foundation.dart';
import 'package:flutter_learn/core/models/product.dart';
import 'package:flutter_learn/core/network/api_endpoint.dart';
import 'package:flutter_learn/core/network/api_error.dart';
import 'package:flutter_learn/core/network/network_manager.dart';

class MallViewModel extends ChangeNotifier {
  final _network = NetworkManager.shared;

  List<Product> products = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;
  ApiException? error;

  int _currentPage = 1;
  static const _pageSize = 20;

  Future<void> loadProducts() async {
    _currentPage = 1;
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      products = await _network.request(
        ApiEndpoint.products(page: 1, limit: _pageSize),
        fromJson: Product.fromJsonList,
      );
      hasMore = products.length >= _pageSize;
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
        ApiEndpoint.products(page: _currentPage, limit: _pageSize),
        fromJson: Product.fromJsonList,
      );
      products.addAll(result);
      hasMore = result.length >= _pageSize;
      _currentPage++;
    } catch (_) {}

    isLoadingMore = false;
    notifyListeners();
  }
}
