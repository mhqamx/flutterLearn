import 'package:flutter/material.dart';
import 'package:flutter_learn/core/components/loading_view.dart';
import 'package:flutter_learn/modules/mine/mine_view_model.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  final _viewModel = MineViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的')),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading) return const LoadingView();
          return ListView(
            children: [
              // 用户信息区
              _buildUserHeader(),
              const Divider(),
              // 功能菜单
              ..._viewModel.menuItems.map(_buildMenuItem),
              const Divider(),
              // 退出按钮
              if (_viewModel.isLoggedIn)
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('退出登录', style: TextStyle(color: Colors.red)),
                  onTap: () => _viewModel.logout(),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserHeader() {
    final user = _viewModel.user;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.blue[100],
            child: Text(
              user != null ? user.name[0].toUpperCase() : '?',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user?.name ?? '未登录',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(user?.email ?? '点击登录',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildMenuItem(ProfileMenuItem item) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: item.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(item.icon, color: item.color, size: 20),
      ),
      title: Text(item.title),
      subtitle: Text(item.subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
      onTap: () {},
    );
  }
}
