import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// Text Widget 演示页面
/// 展示 Flutter 中文本相关的各种样式和用法
class TextDemoPage extends StatelessWidget {
  const TextDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Text 文本',
      subtitle: '展示 Text widget 的各种样式、富文本和溢出处理',
      conceptItems: const [
        'Text：Flutter 中最基础的文本展示组件',
        'TextStyle：通过 style 参数控制字体大小、颜色、粗细等',
        'RichText：在同一行中展示不同样式的文本片段',
        'TextOverflow：控制文本溢出时的表现（省略号、裁剪等）',
        'TextAlign：控制文本在容器内的对齐方式',
      ],
      children: [
        const SectionTitle('基础文本'),
        _buildCard(
          child: const Text('Hello, Flutter!'),
        ),

        const SectionTitle('字体大小'),
        _buildCard(
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('12px 小号文本', style: TextStyle(fontSize: 12)),
              SizedBox(height: 8),
              Text('16px 默认文本', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('20px 中号文本', style: TextStyle(fontSize: 20)),
              SizedBox(height: 8),
              Text('28px 大号文本', style: TextStyle(fontSize: 28)),
            ],
          ),
        ),

        const SectionTitle('颜色'),
        _buildCard(
          child: const Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              Text('红色', style: TextStyle(color: Colors.red, fontSize: 18)),
              Text('蓝色', style: TextStyle(color: Colors.blue, fontSize: 18)),
              Text('绿色', style: TextStyle(color: Colors.green, fontSize: 18)),
              Text('紫色', style: TextStyle(color: Colors.purple, fontSize: 18)),
              Text('橙色', style: TextStyle(color: Colors.orange, fontSize: 18)),
            ],
          ),
        ),

        const SectionTitle('粗体与斜体'),
        _buildCard(
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('普通文本 (FontWeight.normal)', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('粗体文本 (FontWeight.bold)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('斜体文本 (FontStyle.italic)',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
              SizedBox(height: 8),
              Text('粗斜体文本',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic)),
            ],
          ),
        ),

        const SectionTitle('行间距'),
        _buildCard(
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Flutter 是 Google 开发的跨平台 UI 框架。这段文字使用默认行间距，可以看到行与行之间的距离比较紧凑。',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              Text(
                'Flutter 是 Google 开发的跨平台 UI 框架。这段文字使用 1.8 倍行间距（height: 1.8），阅读体验更加舒适。',
                style: TextStyle(fontSize: 14, height: 1.8),
              ),
            ],
          ),
        ),

        const SectionTitle('对齐方式'),
        _buildCard(
          child: const Column(
            children: [
              Text('左对齐 (TextAlign.left)',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14)),
              Divider(),
              SizedBox(
                width: double.infinity,
                child: Text('居中对齐 (TextAlign.center)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14)),
              ),
              Divider(),
              SizedBox(
                width: double.infinity,
                child: Text('右对齐 (TextAlign.right)',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 14)),
              ),
            ],
          ),
        ),

        const SectionTitle('富文本 RichText'),
        _buildCard(
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              children: const [
                TextSpan(text: 'RichText 可以在'),
                TextSpan(
                  text: '同一行',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
                ),
                TextSpan(text: '中展示'),
                TextSpan(
                  text: '不同样式',
                  style: TextStyle(
                      color: Colors.blue,
                      fontStyle: FontStyle.italic,
                      fontSize: 20),
                ),
                TextSpan(text: '的文本，比如'),
                TextSpan(
                  text: '下划线',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.green),
                ),
                TextSpan(text: '和'),
                TextSpan(
                  text: '删除线',
                  style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.orange),
                ),
                TextSpan(text: '。'),
              ],
            ),
          ),
        ),

        const SectionTitle('文本溢出处理'),
        _buildCard(
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TextOverflow.ellipsis - 超长文本会在末尾显示省略号来提示用户内容被截断了',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14)),
              SizedBox(height: 12),
              Text('TextOverflow.clip - 超长文本会被直接裁剪掉，不会显示任何提示符号',
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: TextStyle(fontSize: 14)),
              SizedBox(height: 12),
              Text('TextOverflow.fade - 超长文本会以渐隐效果结束，看起来更加优雅自然',
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: TextStyle(fontSize: 14)),
              SizedBox(height: 12),
              Text(
                'maxLines: 2 - 这段文字限制最多显示两行，超出部分会以省略号结束。Flutter 提供了灵活的文本控制方式。',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 通用卡片包裹
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
