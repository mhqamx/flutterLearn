import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';
import 'package:provider/provider.dart';

/// Provider 演示页面
/// 对应 SwiftUI 的 EnvironmentObject，跨组件共享状态
class ProviderDemoPage extends StatelessWidget {
  const ProviderDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 使用 MultiProvider 提供多个状态
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => CartNotifier()),
      ],
      child: const _ProviderDemoContent(),
    );
  }
}

class _ProviderDemoContent extends StatelessWidget {
  const _ProviderDemoContent();

  @override
  Widget build(BuildContext context) {
    // 使用 context.watch 监听主题变化
    final themeNotifier = context.watch<ThemeNotifier>();

    return Theme(
      data: themeNotifier.isDark ? ThemeData.dark() : ThemeData.light(),
      child: DemoScaffold(
        title: 'Provider 状态管理',
        subtitle: '对应 SwiftUI 的 EnvironmentObject，跨组件树共享状态',
        conceptItems: const [
          'ChangeNotifierProvider：创建并提供 ChangeNotifier 实例',
          'Consumer<T>：消费 Provider 中的数据，自动响应变化',
          'context.watch<T>()：监听并获取 Provider 数据（会触发重建）',
          'context.read<T>()：只读取不监听（不会触发重建）',
          'MultiProvider：同时提供多个 Provider',
        ],
        children: [
          const SectionTitle('主题切换（ChangeNotifierProvider）'),
          _buildCard(
            child: Consumer<ThemeNotifier>(
              builder: (context, theme, _) {
                return Column(
                  children: [
                    Icon(
                      theme.isDark ? Icons.dark_mode : Icons.light_mode,
                      size: 48,
                      color: theme.isDark ? Colors.amber : Colors.orange,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      theme.isDark ? '深色模式' : '浅色模式',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      title: const Text('切换主题'),
                      subtitle: Text(theme.isDark ? '当前为深色模式' : '当前为浅色模式'),
                      value: theme.isDark,
                      onChanged: (_) => theme.toggle(),
                    ),
                  ],
                );
              },
            ),
          ),

          const SectionTitle('购物车（跨组件共享）'),
          // 购物车状态展示
          Consumer<CartNotifier>(
            builder: (context, cart, _) {
              return Column(
                children: [
                  _buildCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Badge(
                              label: Text('${cart.itemCount}'),
                              isLabelVisible: cart.itemCount > 0,
                              child: const Icon(Icons.shopping_cart, size: 32),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('购物车',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text('${cart.itemCount} 件商品，共 ¥${cart.totalPrice.toStringAsFixed(0)}',
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: cart.itemCount > 0 ? () => cart.clear() : null,
                          child: const Text('清空'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 商品列表 - 子组件通过 context.read 修改状态
                  ...CartNotifier.products.map((product) {
                    final quantity = cart.getQuantity(product.name);
                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.only(bottom: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: product.color.withValues(alpha: 0.2),
                          child: Icon(product.icon, color: product.color),
                        ),
                        title: Text(product.name),
                        subtitle: Text('¥${product.price.toStringAsFixed(0)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (quantity > 0)
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline,
                                    color: Colors.red),
                                onPressed: () => cart.removeItem(product.name),
                              ),
                            if (quantity > 0)
                              Text('$quantity',
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline,
                                  color: Colors.green),
                              onPressed: () =>
                                  cart.addItem(product.name, product.price),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          ),

          const SizedBox(height: 8),
          const SectionTitle('深层子组件也能访问'),
          _buildCard(
            child: const _DeepChildWidget(),
          ),
        ],
      ),
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

/// 模拟深层子组件，演示不需要逐层传递就能访问 Provider
class _DeepChildWidget extends StatelessWidget {
  const _DeepChildWidget();

  @override
  Widget build(BuildContext context) {
    // 在任意深度的子组件中都可以直接访问 Provider
    final cart = context.watch<CartNotifier>();
    final theme = context.watch<ThemeNotifier>();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('这是一个深层子组件',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('主题模式: ${theme.isDark ? "深色" : "浅色"}'),
          Text('购物车商品数: ${cart.itemCount}'),
          Text('购物车总价: ¥${cart.totalPrice.toStringAsFixed(0)}'),
          const SizedBox(height: 8),
          const Text(
            '无需通过 props 逐层传递，直接通过 context.watch 获取',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// ==================== ChangeNotifier 类 ====================

/// 主题状态管理
class ThemeNotifier extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  void toggle() {
    _isDark = !_isDark;
    notifyListeners();
  }
}

/// 购物车状态管理
class CartNotifier extends ChangeNotifier {
  /// 购物车项目 {商品名: (数量, 单价)}
  final Map<String, (int, double)> _items = {};

  /// 示例商品数据
  static final products = [
    _Product('Flutter 实战', 89.0, Icons.book, Colors.blue),
    _Product('Dart 入门', 59.0, Icons.code, Colors.teal),
    _Product('设计模式', 79.0, Icons.architecture, Colors.orange),
    _Product('算法导论', 99.0, Icons.functions, Colors.purple),
  ];

  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.$1);

  double get totalPrice =>
      _items.values.fold(0.0, (sum, item) => sum + item.$1 * item.$2);

  int getQuantity(String name) => _items[name]?.$1 ?? 0;

  void addItem(String name, double price) {
    final current = _items[name];
    if (current != null) {
      _items[name] = (current.$1 + 1, price);
    } else {
      _items[name] = (1, price);
    }
    notifyListeners();
  }

  void removeItem(String name) {
    final current = _items[name];
    if (current != null && current.$1 > 1) {
      _items[name] = (current.$1 - 1, current.$2);
    } else {
      _items.remove(name);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

/// 商品模型
class _Product {
  final String name;
  final double price;
  final IconData icon;
  final Color color;

  const _Product(this.name, this.price, this.icon, this.color);
}
