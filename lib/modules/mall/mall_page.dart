import 'package:flutter/material.dart';
import 'package:flutter_learn/core/components/error_view.dart';
import 'package:flutter_learn/core/components/loading_view.dart';
import 'package:flutter_learn/modules/mall/mall_view_model.dart';
import 'package:flutter_learn/modules/mall/product_card_widget.dart';

class MallPage extends StatefulWidget {
  const MallPage({super.key});

  @override
  State<MallPage> createState() => _MallPageState();
}

class _MallPageState extends State<MallPage> {
  final _viewModel = MallViewModel();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _viewModel.loadProducts();
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
      appBar: AppBar(title: const Text('商城')),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading) return const LoadingView();
          if (_viewModel.error != null) {
            return ErrorView(
              message: _viewModel.error!.message,
              onRetry: () => _viewModel.loadProducts(),
            );
          }
          return RefreshIndicator(
            onRefresh: () => _viewModel.loadProducts(),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ProductCardWidget(product: _viewModel.products[index]),
                      childCount: _viewModel.products.length,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _viewModel.isLoadingMore
                      ? const InlineLoadingView()
                      : !_viewModel.hasMore
                          ? const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: Text('已加载全部', style: TextStyle(color: Colors.grey, fontSize: 13))),
                            )
                          : const SizedBox.shrink(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
