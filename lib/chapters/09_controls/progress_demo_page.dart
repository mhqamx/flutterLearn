import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// 进度指示器演示页面
/// 展示各种进度指示器组件
class ProgressDemoPage extends StatefulWidget {
  const ProgressDemoPage({super.key});

  @override
  State<ProgressDemoPage> createState() => _ProgressDemoPageState();
}

class _ProgressDemoPageState extends State<ProgressDemoPage> {
  double _progressValue = 0.3;
  bool _isAutoRunning = false;
  Timer? _autoTimer;

  // 下拉刷新列表数据
  List<String> _refreshItems = List.generate(5, (i) => '项目 ${i + 1}');
  int _refreshCount = 0;

  @override
  void dispose() {
    _autoTimer?.cancel();
    super.dispose();
  }

  /// 自动推进进度
  void _toggleAutoProgress() {
    if (_isAutoRunning) {
      _autoTimer?.cancel();
      setState(() => _isAutoRunning = false);
    } else {
      setState(() {
        _isAutoRunning = true;
        _progressValue = 0;
      });
      _autoTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
        setState(() {
          _progressValue += 0.01;
          if (_progressValue >= 1.0) {
            _progressValue = 1.0;
            _isAutoRunning = false;
            timer.cancel();
          }
        });
      });
    }
  }

  /// 模拟下拉刷新
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _refreshCount++;
      _refreshItems = List.generate(5, (i) => '刷新 #$_refreshCount - 项目 ${i + 1}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final percent = (_progressValue * 100).toInt();

    return DemoScaffold(
      title: '进度指示器',
      subtitle: '展示 CircularProgressIndicator、LinearProgressIndicator 等',
      conceptItems: const [
        'CircularProgressIndicator：圆形进度指示器',
        'LinearProgressIndicator：线性进度条',
        'value：null 为不确定进度（持续旋转），0.0-1.0 为确定进度',
        'RefreshIndicator：下拉刷新组件，包裹可滚动组件使用',
        'valueColor：通过 AlwaysStoppedAnimation 设置进度颜色',
      ],
      children: [
        // === 不确定进度 ===
        const SectionTitle('不确定进度（加载中）'),
        _buildCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 8),
                  Text('圆形', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
              Column(
                children: [
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(height: 8),
                  Text('小型', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
              Column(
                children: [
                  const SizedBox(
                    width: 150,
                    child: LinearProgressIndicator(),
                  ),
                  const SizedBox(height: 8),
                  Text('线性', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ],
          ),
        ),

        // === 确定进度（Slider 控制） ===
        const SectionTitle('确定进度（Slider 控制）'),
        _buildCard(
          child: Column(
            children: [
              // 显示进度值
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 圆形确定进度
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: _progressValue,
                          strokeWidth: 8,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation(
                            _progressValue >= 1.0 ? Colors.green : Colors.blue,
                          ),
                        ),
                      ),
                      Text(
                        '$percent%',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // 不同颜色的圆形进度
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      value: _progressValue,
                      strokeWidth: 6,
                      backgroundColor: Colors.orange[100],
                      valueColor: const AlwaysStoppedAnimation(Colors.orange),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      value: _progressValue,
                      strokeWidth: 4,
                      backgroundColor: Colors.purple[100],
                      valueColor: const AlwaysStoppedAnimation(Colors.purple),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 线性进度条
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _progressValue,
                  minHeight: 12,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(
                    _progressValue >= 1.0 ? Colors.green : Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0%', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                  Text('$percent%',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w600,
                      )),
                  Text('100%', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                ],
              ),
              const SizedBox(height: 12),

              // Slider 控制
              Slider(
                value: _progressValue,
                onChanged: _isAutoRunning
                    ? null
                    : (val) {
                        setState(() => _progressValue = val);
                      },
              ),

              // 自动进度按钮
              ElevatedButton.icon(
                onPressed: _toggleAutoProgress,
                icon: Icon(_isAutoRunning ? Icons.stop : Icons.play_arrow),
                label: Text(_isAutoRunning ? '停止自动' : '自动推进'),
              ),
            ],
          ),
        ),

        // === 自定义进度条 ===
        const SectionTitle('自定义进度条样式'),
        _buildCard(
          child: Column(
            children: [
              // 渐变进度条
              _buildCustomProgress('下载进度', _progressValue, Colors.blue, Colors.lightBlue),
              const SizedBox(height: 16),
              _buildCustomProgress('上传进度', (_progressValue * 0.7).clamp(0, 1), Colors.green, Colors.lightGreen),
              const SizedBox(height: 16),
              _buildCustomProgress('处理进度', (_progressValue * 1.3).clamp(0, 1), Colors.orange, Colors.amber),
            ],
          ),
        ),

        // === RefreshIndicator ===
        const SectionTitle('RefreshIndicator 下拉刷新'),
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('刷新次数: $_refreshCount',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    itemCount: _refreshItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 16,
                          child: Text('${index + 1}'),
                        ),
                        title: Text(_refreshItems[index]),
                        dense: true,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text('下拉列表触发刷新',
                    style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 自定义进度条
  Widget _buildCustomProgress(String label, double value, Color startColor, Color endColor) {
    final clampedValue = value.clamp(0.0, 1.0);
    final percent = (clampedValue * 100).toInt();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            Text('$percent%', style: TextStyle(fontSize: 13, color: startColor)),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: clampedValue,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [startColor, endColor]),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
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
