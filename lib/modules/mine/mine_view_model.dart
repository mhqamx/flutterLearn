import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learn/core/models/app_user.dart';
import 'package:flutter_learn/core/network/api_endpoint.dart';
import 'package:flutter_learn/core/network/api_error.dart';
import 'package:flutter_learn/core/network/network_manager.dart';

class MineViewModel extends ChangeNotifier {
  final _network = NetworkManager.shared;

  AppUser? user;
  bool isLoading = false;
  bool isLoggedIn = false;
  ApiException? error;

  final menuItems = const [
    ProfileMenuItem(icon: Icons.shopping_bag, title: '我的订单', subtitle: '查看全部订单', color: Colors.blue),
    ProfileMenuItem(icon: Icons.favorite, title: '我的收藏', subtitle: '收藏的内容', color: Colors.red),
    ProfileMenuItem(icon: Icons.history, title: '浏览历史', subtitle: '最近浏览', color: Colors.orange),
    ProfileMenuItem(icon: Icons.location_on, title: '收货地址', subtitle: '管理地址', color: Colors.green),
    ProfileMenuItem(icon: Icons.settings, title: '设置', subtitle: '应用设置', color: Colors.grey),
    ProfileMenuItem(icon: Icons.info, title: '关于', subtitle: '版本 1.0.0', color: Colors.purple),
  ];

  Future<void> loadProfile({int userId = 1}) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      user = await _network.request(
        ApiEndpoint.userProfile(userId),
        fromJson: (json) => AppUser.fromJson(json as Map<String, dynamic>),
      );
      isLoggedIn = true;
    } on ApiException catch (e) {
      error = e;
    }

    isLoading = false;
    notifyListeners();
  }

  void logout() {
    user = null;
    isLoggedIn = false;
    notifyListeners();
  }
}

class ProfileMenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}
