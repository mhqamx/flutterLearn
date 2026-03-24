import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// 定时器演示页面
/// 展示 Timer 和 Stream.periodic 的用法
class TimerDemoPage extends StatefulWidget {
  const TimerDemoPage({super.key});

  @override
  State<TimerDemoPage> createState() => _TimerDemoPageState();
}

class _TimerDemoPageState extends State<TimerDemoPage> {
  // === Timer.periodic 定时器 ===
  Timer? _periodicTimer;
  int _periodicCount = 0;
  bool _isPeriodicRunning = false;

  // === 倒计时 ===
  Timer? _countdownTimer;
  int _countdownSeconds = 30;
  int _countdownRemaining = 30;
  bool _isCountdownRunning = false;

  // === 秒表 ===
  Timer? _stopwatchTimer;
  int _stopwatchMilliseconds = 0;
  bool _isStopwatchRunning = false;
  List<String> _lapTimes = [];

  // === Stream.periodic ===
  StreamSubscription? _streamSubscription;
  int _streamCount = 0;
  bool _isStreamRunning = false;

  @override
  void dispose() {
    _periodicTimer?.cancel();
    _countdownTimer?.cancel();
    _stopwatchTimer?.cancel();
    _streamSubscription?.cancel();
    super.dispose();
  }

  // ======= Timer.periodic =======
  void _startPeriodicTimer() {
    _periodicTimer?.cancel();
    setState(() {
      _isPeriodicRunning = true;
      _periodicCount = 0;
    });
    _periodicTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _periodicCount++;
      });
    });
  }

  void _stopPeriodicTimer() {
    _periodicTimer?.cancel();
    setState(() {
      _isPeriodicRunning = false;
    });
  }

  // ======= 倒计时 =======
  void _startCountdown() {
    _countdownTimer?.cancel();
    setState(() {
      _countdownRemaining = _countdownSeconds;
      _isCountdownRunning = true;
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdownRemaining--;
      });
      if (_countdownRemaining <= 0) {
        timer.cancel();
        setState(() {
          _isCountdownRunning = false;
        });
        _showSnackBar('倒计时结束!');
      }
    });
  }

  void _stopCountdown() {
    _countdownTimer?.cancel();
    setState(() {
      _isCountdownRunning = false;
    });
  }

  // ======= 秒表 =======
  void _startStopwatch() {
    _stopwatchTimer?.cancel();
    setState(() {
      _isStopwatchRunning = true;
    });
    _stopwatchTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        _stopwatchMilliseconds += 10;
      });
    });
  }

  void _pauseStopwatch() {
    _stopwatchTimer?.cancel();
    setState(() {
      _isStopwatchRunning = false;
    });
  }

  void _resetStopwatch() {
    _stopwatchTimer?.cancel();
    setState(() {
      _stopwatchMilliseconds = 0;
      _isStopwatchRunning = false;
      _lapTimes.clear();
    });
  }

  void _recordLap() {
    setState(() {
      _lapTimes.insert(0, _formatStopwatch(_stopwatchMilliseconds));
    });
  }

  String _formatStopwatch(int ms) {
    final minutes = (ms ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((ms ~/ 1000) % 60).toString().padLeft(2, '0');
    final centiseconds = ((ms % 1000) ~/ 10).toString().padLeft(2, '0');
    return '$minutes:$seconds.$centiseconds';
  }

  // ======= Stream.periodic =======
  void _startStream() {
    _streamSubscription?.cancel();
    setState(() {
      _streamCount = 0;
      _isStreamRunning = true;
    });
    _streamSubscription = Stream.periodic(
      const Duration(milliseconds: 500),
      (count) => count + 1,
    ).listen((count) {
      setState(() {
        _streamCount = count;
      });
    });
  }

  void _stopStream() {
    _streamSubscription?.cancel();
    setState(() {
      _isStreamRunning = false;
    });
  }

  void _showSnackBar(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: '定时器',
      subtitle: '展示 Timer.periodic、倒计时、秒表和 Stream.periodic',
      conceptItems: const [
        'Timer.periodic：按固定间隔重复执行回调',
        'Timer：dart:async 中的定时器类',
        'cancel()：停止定时器，防止内存泄漏（dispose 中必须调用）',
        'Stream.periodic：创建按时间间隔发射事件的 Stream',
        'Stopwatch：Dart 内置的计时器类（此处用 Timer 模拟）',
      ],
      children: [
        // === Timer.periodic ===
        const SectionTitle('Timer.periodic 定时器'),
        _buildCard(
          child: Column(
            children: [
              Text(
                '$_periodicCount',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: _isPeriodicRunning ? Colors.blue : Colors.grey,
                ),
              ),
              const Text('每秒 +1', style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isPeriodicRunning ? null : _startPeriodicTimer,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('开始'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: _isPeriodicRunning ? _stopPeriodicTimer : null,
                    icon: const Icon(Icons.stop),
                    label: const Text('停止'),
                  ),
                ],
              ),
            ],
          ),
        ),

        // === 倒计时 ===
        const SectionTitle('倒计时'),
        _buildCard(
          child: Column(
            children: [
              // 倒计时显示
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: _countdownSeconds > 0
                          ? _countdownRemaining / _countdownSeconds
                          : 0,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(
                        _countdownRemaining <= 5 ? Colors.red : Colors.blue,
                      ),
                    ),
                  ),
                  Text(
                    '$_countdownRemaining',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: _countdownRemaining <= 5 ? Colors.red : Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // 设置倒计时秒数
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('倒计时秒数: '),
                  DropdownButton<int>(
                    value: _countdownSeconds,
                    items: [10, 20, 30, 60].map((s) {
                      return DropdownMenuItem(value: s, child: Text('$s 秒'));
                    }).toList(),
                    onChanged: _isCountdownRunning
                        ? null
                        : (val) {
                            setState(() {
                              _countdownSeconds = val!;
                              _countdownRemaining = val;
                            });
                          },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isCountdownRunning ? null : _startCountdown,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('开始'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: _isCountdownRunning ? _stopCountdown : null,
                    icon: const Icon(Icons.stop),
                    label: const Text('停止'),
                  ),
                ],
              ),
            ],
          ),
        ),

        // === 秒表 ===
        const SectionTitle('秒表'),
        _buildCard(
          child: Column(
            children: [
              Text(
                _formatStopwatch(_stopwatchMilliseconds),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_isStopwatchRunning) ...[
                    ElevatedButton.icon(
                      onPressed: _startStopwatch,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('开始'),
                    ),
                    if (_stopwatchMilliseconds > 0) ...[
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: _resetStopwatch,
                        icon: const Icon(Icons.refresh),
                        label: const Text('重置'),
                      ),
                    ],
                  ] else ...[
                    ElevatedButton.icon(
                      onPressed: _pauseStopwatch,
                      icon: const Icon(Icons.pause),
                      label: const Text('暂停'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: _recordLap,
                      icon: const Icon(Icons.flag),
                      label: const Text('计次'),
                    ),
                  ],
                ],
              ),
              // 计次记录
              if (_lapTimes.isNotEmpty) ...[
                const Divider(height: 24),
                ...(_lapTimes.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Lap ${_lapTimes.length - entry.key}',
                            style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                        Text(entry.value,
                            style: const TextStyle(fontFamily: 'monospace', fontSize: 14)),
                      ],
                    ),
                  );
                })),
              ],
            ],
          ),
        ),

        // === Stream.periodic ===
        const SectionTitle('Stream.periodic'),
        _buildCard(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$_streamCount',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: _isStreamRunning ? Colors.purple : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _isStreamRunning ? Colors.purple[50] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _isStreamRunning ? '每 500ms 发射' : '已停止',
                      style: TextStyle(
                        fontSize: 12,
                        color: _isStreamRunning ? Colors.purple : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // 进度条可视化
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_streamCount % 20) / 20,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation(Colors.purple),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isStreamRunning ? null : _startStream,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('开始'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: _isStreamRunning ? _stopStream : null,
                    icon: const Icon(Icons.stop),
                    label: const Text('停止'),
                  ),
                ],
              ),
            ],
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
