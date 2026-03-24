import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';

/// 过渡动画 Demo
/// 演示 AnimatedSwitcher、FadeTransition、SlideTransition、ScaleTransition、RotationTransition
class AnimatedSwitcherDemoPage extends StatefulWidget {
  const AnimatedSwitcherDemoPage({super.key});

  @override
  State<AnimatedSwitcherDemoPage> createState() => _AnimatedSwitcherDemoPageState();
}

class _AnimatedSwitcherDemoPageState extends State<AnimatedSwitcherDemoPage>
    with TickerProviderStateMixin {
  // AnimatedSwitcher 计数器
  int _counter = 0;

  // 当前过渡效果类型
  String _transitionType = 'fade';

  // 显式动画控制器
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _slideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _scaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _rotationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    // 初始播放
    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
    _rotationController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: '过渡动画 Transition',
      subtitle: '演示 AnimatedSwitcher 组件切换和各种 Transition 过渡效果',
      conceptItems: const [
        'AnimatedSwitcher：在子组件切换时自动播放过渡动画',
        'FadeTransition：淡入淡出过渡，通过 opacity 控制',
        'SlideTransition：滑动过渡，通过 position (Offset) 控制',
        'ScaleTransition：缩放过渡，通过 scale 控制',
        'RotationTransition：旋转过渡，通过 turns 控制',
        'AnimationController：显式动画的核心控制器，需要 TickerProviderStateMixin',
        'transitionBuilder：自定义 AnimatedSwitcher 的过渡动画',
      ],
      children: [
        const SectionTitle('1. AnimatedSwitcher 组件切换'),
        _buildAnimatedSwitcherDemo(),
        const SizedBox(height: 16),

        const SectionTitle('2. FadeTransition 淡入淡出'),
        _buildFadeTransitionDemo(),
        const SizedBox(height: 16),

        const SectionTitle('3. SlideTransition 滑动'),
        _buildSlideTransitionDemo(),
        const SizedBox(height: 16),

        const SectionTitle('4. ScaleTransition 缩放'),
        _buildScaleTransitionDemo(),
        const SizedBox(height: 16),

        const SectionTitle('5. RotationTransition 旋转'),
        _buildRotationTransitionDemo(),
      ],
    );
  }

  /// AnimatedSwitcher 示例
  Widget _buildAnimatedSwitcherDemo() {
    return Column(
      children: [
        // 选择过渡效果
        Wrap(
          spacing: 8,
          children: [
            _transitionChip('fade', '淡入淡出'),
            _transitionChip('slide', '滑动'),
            _transitionChip('scale', '缩放'),
            _transitionChip('rotation', '旋转'),
          ],
        ),
        const SizedBox(height: 16),
        // 切换展示区
        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                switch (_transitionType) {
                  case 'slide':
                    return SlideTransition(
                      position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(animation),
                      child: child,
                    );
                  case 'scale':
                    return ScaleTransition(scale: animation, child: child);
                  case 'rotation':
                    return RotationTransition(turns: animation, child: child);
                  default: // fade
                    return FadeTransition(opacity: animation, child: child);
                }
              },
              // key 变化触发切换动画
              child: Text(
                '$_counter',
                key: ValueKey<int>(_counter),
                style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () => setState(() => _counter++),
          icon: const Icon(Icons.add),
          label: const Text('计数 +1（触发切换动画）'),
        ),
      ],
    );
  }

  Widget _transitionChip(String type, String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _transitionType == type,
      onSelected: (_) => setState(() => _transitionType = type),
    );
  }

  /// FadeTransition 示例
  Widget _buildFadeTransitionDemo() {
    return Column(
      children: [
        FadeTransition(
          opacity: _fadeController,
          child: Container(
            width: 120,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('淡入淡出', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildControlButtons(_fadeController),
      ],
    );
  }

  /// SlideTransition 示例
  Widget _buildSlideTransitionDemo() {
    final slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack));

    return Column(
      children: [
        SlideTransition(
          position: slideAnimation,
          child: Container(
            width: 120,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('滑动进入', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildControlButtons(_slideController),
      ],
    );
  }

  /// ScaleTransition 示例
  Widget _buildScaleTransitionDemo() {
    final scaleAnimation = CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut);

    return Column(
      children: [
        ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            width: 120,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('缩放', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildControlButtons(_scaleController),
      ],
    );
  }

  /// RotationTransition 示例
  Widget _buildRotationTransitionDemo() {
    return Column(
      children: [
        RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
          ),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.refresh, color: Colors.white, size: 40),
          ),
        ),
        const SizedBox(height: 8),
        _buildControlButtons(_rotationController),
      ],
    );
  }

  /// 通用控制按钮
  Widget _buildControlButtons(AnimationController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => controller.forward(from: 0),
          icon: const Icon(Icons.play_arrow),
          tooltip: '播放',
        ),
        IconButton(
          onPressed: () => controller.reverse(),
          icon: const Icon(Icons.fast_rewind),
          tooltip: '反向播放',
        ),
        IconButton(
          onPressed: () => controller.repeat(reverse: true),
          icon: const Icon(Icons.repeat),
          tooltip: '循环',
        ),
        IconButton(
          onPressed: () => controller.stop(),
          icon: const Icon(Icons.stop),
          tooltip: '停止',
        ),
      ],
    );
  }
}
