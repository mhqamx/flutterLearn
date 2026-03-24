import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learn/core/models/product.dart';

class ProductCardWidget extends StatelessWidget {
  final Product product;

  const ProductCardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 图片
          AspectRatio(
            aspectRatio: 1,
            child: CachedNetworkImage(
              imageUrl: product.thumbnailUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                color: Colors.grey[100],
                child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              errorWidget: (_, __, ___) => Container(
                color: Colors.grey[100],
                child: const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
          // 信息区
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.shortTitle, maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(product.priceText, style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red)),
                    const Spacer(),
                    Text('销量 ${product.salesCount}',
                        style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(product.category,
                          style: const TextStyle(fontSize: 10, color: Colors.orange)),
                    ),
                    const Spacer(),
                    Icon(Icons.star, size: 12, color: Colors.orange[400]),
                    const SizedBox(width: 2),
                    Text(product.rating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
