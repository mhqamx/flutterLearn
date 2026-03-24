import 'package:flutter/material.dart';

/// Demo 页面顶部标题区
class DemoHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const DemoHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
        ],
      ),
    );
  }
}

/// 核心知识点
class ConceptNote extends StatelessWidget {
  final List<String> items;

  const ConceptNote({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb, color: Colors.amber, size: 18),
              const SizedBox(width: 6),
              Text('核心知识点',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      )),
            ],
          ),
          const SizedBox(height: 10),
          ...items.map((item) {
            final parts = item.split('：');
            if (parts.length >= 2) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${parts[0]}：',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          color: Colors.orange[700],
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: parts.sublist(1).join('：'),
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(item, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            );
          }),
        ],
      ),
    );
  }
}

/// Demo 页面通用脚手架
class DemoScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> conceptItems;
  final List<Widget> children;

  const DemoScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.conceptItems,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DemoHeader(title: title, subtitle: subtitle),
            const SizedBox(height: 16),
            ...children,
            const SizedBox(height: 16),
            ConceptNote(items: conceptItems),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

/// 示例区块标题
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 12),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
    );
  }
}
