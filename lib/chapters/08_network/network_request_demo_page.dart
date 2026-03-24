import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';
import 'package:flutter_learn/core/network/network_manager.dart';
import 'package:flutter_learn/core/network/api_endpoint.dart';
import 'package:flutter_learn/core/network/api_error.dart';
import 'package:flutter_learn/core/models/product.dart';

/// 网络请求演示页面
/// 展示 Dio 网络请求的各种用法
class NetworkRequestDemoPage extends StatefulWidget {
  const NetworkRequestDemoPage({super.key});

  @override
  State<NetworkRequestDemoPage> createState() => _NetworkRequestDemoPageState();
}

enum _RequestState { idle, loading, success, error }

class _NetworkRequestDemoPageState extends State<NetworkRequestDemoPage> {
  // GET 请求状态
  _RequestState _getState = _RequestState.idle;
  List<Product> _products = [];
  String _getError = '';
  int _getTimeMs = 0;

  // 并发请求状态
  _RequestState _concurrentState = _RequestState.idle;
  List<Product> _concurrentProducts = [];
  List<Product> _concurrentProducts2 = [];
  String _concurrentError = '';
  int _concurrentTimeMs = 0;

  // 重试请求状态
  _RequestState _retryState = _RequestState.idle;
  String _retryMessage = '';
  int _retryTimeMs = 0;

  /// GET 请求：获取产品列表
  Future<void> _fetchProducts() async {
    setState(() {
      _getState = _RequestState.loading;
      _getError = '';
    });
    final stopwatch = Stopwatch()..start();

    try {
      final products = await NetworkManager.shared.request(
        ApiEndpoint.products(page: 1, limit: 10),
        fromJson: Product.fromJsonList,
      );
      stopwatch.stop();
      setState(() {
        _products = products;
        _getTimeMs = stopwatch.elapsedMilliseconds;
        _getState = _RequestState.success;
      });
    } on ApiException catch (e) {
      stopwatch.stop();
      setState(() {
        _getError = e.message;
        _getTimeMs = stopwatch.elapsedMilliseconds;
        _getState = _RequestState.error;
      });
    } catch (e) {
      stopwatch.stop();
      setState(() {
        _getError = e.toString();
        _getTimeMs = stopwatch.elapsedMilliseconds;
        _getState = _RequestState.error;
      });
    }
  }

  /// 并发请求：Future.wait
  Future<void> _fetchConcurrent() async {
    setState(() {
      _concurrentState = _RequestState.loading;
      _concurrentError = '';
    });
    final stopwatch = Stopwatch()..start();

    try {
      // 同时发起两个请求
      final results = await Future.wait([
        NetworkManager.shared.request(
          ApiEndpoint.products(page: 1, limit: 5),
          fromJson: Product.fromJsonList,
        ),
        NetworkManager.shared.request(
          ApiEndpoint.products(page: 2, limit: 5),
          fromJson: Product.fromJsonList,
        ),
      ]);
      stopwatch.stop();
      setState(() {
        _concurrentProducts = results[0];
        _concurrentProducts2 = results[1];
        _concurrentTimeMs = stopwatch.elapsedMilliseconds;
        _concurrentState = _RequestState.success;
      });
    } on ApiException catch (e) {
      stopwatch.stop();
      setState(() {
        _concurrentError = e.message;
        _concurrentTimeMs = stopwatch.elapsedMilliseconds;
        _concurrentState = _RequestState.error;
      });
    } catch (e) {
      stopwatch.stop();
      setState(() {
        _concurrentError = e.toString();
        _concurrentTimeMs = stopwatch.elapsedMilliseconds;
        _concurrentState = _RequestState.error;
      });
    }
  }

  /// 带重试的请求
  Future<void> _fetchWithRetry() async {
    setState(() {
      _retryState = _RequestState.loading;
      _retryMessage = '请求中（最多重试3次）...';
    });
    final stopwatch = Stopwatch()..start();

    try {
      final products = await NetworkManager.shared.requestWithRetry(
        ApiEndpoint.products(page: 1, limit: 3),
        fromJson: Product.fromJsonList,
        maxRetries: 3,
      );
      stopwatch.stop();
      setState(() {
        _retryMessage = '成功获取 ${products.length} 条数据';
        _retryTimeMs = stopwatch.elapsedMilliseconds;
        _retryState = _RequestState.success;
      });
    } on ApiException catch (e) {
      stopwatch.stop();
      setState(() {
        _retryMessage = '重试后仍失败: ${e.message}';
        _retryTimeMs = stopwatch.elapsedMilliseconds;
        _retryState = _RequestState.error;
      });
    } catch (e) {
      stopwatch.stop();
      setState(() {
        _retryMessage = '错误: $e';
        _retryTimeMs = stopwatch.elapsedMilliseconds;
        _retryState = _RequestState.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Dio 网络请求',
      subtitle: '展示 GET 请求、并发请求、错误处理和重试机制',
      conceptItems: const [
        'Dio：Flutter 最流行的 HTTP 客户端库',
        'NetworkManager：封装 Dio，统一管理请求配置和错误处理',
        'Future.wait：并发执行多个异步操作，等待全部完成',
        'requestWithRetry：带指数退避的重试机制',
        'ApiException：统一的异常模型，区分网络/服务器/解析错误',
      ],
      children: [
        // === GET 请求 ===
        const SectionTitle('GET 请求 - 获取产品列表'),
        _buildCard(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _getState == _RequestState.loading ? null : _fetchProducts,
                  icon: const Icon(Icons.download),
                  label: const Text('发起 GET 请求'),
                ),
              ),
              const SizedBox(height: 12),
              _buildStatusBar(_getState, _getTimeMs, _getError),
              if (_getState == _RequestState.success) ...[
                const Divider(),
                ...(_products.take(5).map((p) => ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.blue[50],
                        child: Text('${p.id}', style: const TextStyle(fontSize: 12)),
                      ),
                      title: Text(p.shortTitle, style: const TextStyle(fontSize: 13)),
                      subtitle: Text('${p.category} | ${p.priceText}',
                          style: const TextStyle(fontSize: 11)),
                    ))),
                if (_products.length > 5)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text('...还有 ${_products.length - 5} 条',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  ),
              ],
            ],
          ),
        ),

        // === 并发请求 ===
        const SectionTitle('并发请求 - Future.wait'),
        _buildCard(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _concurrentState == _RequestState.loading
                      ? null
                      : _fetchConcurrent,
                  icon: const Icon(Icons.sync),
                  label: const Text('同时发起2个请求'),
                ),
              ),
              const SizedBox(height: 12),
              _buildStatusBar(_concurrentState, _concurrentTimeMs, _concurrentError),
              if (_concurrentState == _RequestState.success) ...[
                const Divider(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('请求1: 获取到 ${_concurrentProducts.length} 条（第1页）',
                          style: const TextStyle(fontSize: 13)),
                      const SizedBox(height: 4),
                      Text('请求2: 获取到 ${_concurrentProducts2.length} 条（第2页）',
                          style: const TextStyle(fontSize: 13)),
                      const SizedBox(height: 4),
                      Text('两个请求并行执行，总耗时仅 ${_concurrentTimeMs}ms',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[700],
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),

        // === 重试请求 ===
        const SectionTitle('错误处理与重试'),
        _buildCard(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _retryState == _RequestState.loading
                      ? null
                      : _fetchWithRetry,
                  icon: const Icon(Icons.replay),
                  label: const Text('带重试的请求'),
                ),
              ),
              const SizedBox(height: 12),
              _buildStatusBar(_retryState, _retryTimeMs, ''),
              if (_retryMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _retryState == _RequestState.success
                          ? Colors.green[50]
                          : _retryState == _RequestState.error
                              ? Colors.red[50]
                              : Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(_retryMessage, style: const TextStyle(fontSize: 13)),
                  ),
                ),
            ],
          ),
        ),

        // 请求说明
        const SectionTitle('API 说明'),
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Base URL', ApiEndpoint.baseUrl),
              const SizedBox(height: 4),
              _buildInfoRow('数据源', 'JSONPlaceholder（免费 REST API）'),
              const SizedBox(height: 4),
              _buildInfoRow('Product 模型', '基于 /photos 接口映射'),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建请求状态栏
  Widget _buildStatusBar(_RequestState state, int timeMs, String error) {
    IconData icon;
    Color color;
    String text;

    switch (state) {
      case _RequestState.idle:
        icon = Icons.hourglass_empty;
        color = Colors.grey;
        text = '等待发起请求';
      case _RequestState.loading:
        return const Row(
          children: [
            SizedBox(
              width: 16, height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 8),
            Text('请求中...', style: TextStyle(color: Colors.blue)),
          ],
        );
      case _RequestState.success:
        icon = Icons.check_circle;
        color = Colors.green;
        text = '成功  |  耗时 ${timeMs}ms';
      case _RequestState.error:
        icon = Icons.error;
        color = Colors.red;
        text = '失败  |  耗时 ${timeMs}ms${error.isNotEmpty ? '  |  $error' : ''}';
    }

    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(color: color, fontSize: 13))),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ),
        Expanded(
          child: Text(value, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
        ),
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
