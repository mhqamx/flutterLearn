import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// 地图演示页面
/// 展示 FlutterMap 基础用法
class MapDemoPage extends StatefulWidget {
  const MapDemoPage({super.key});

  @override
  State<MapDemoPage> createState() => _MapDemoPageState();
}

class _MapDemoPageState extends State<MapDemoPage> {
  final MapController _mapController = MapController();
  double _currentZoom = 12.0;

  // 标记点列表
  final List<_MapMarkerData> _markers = [
    _MapMarkerData(
      position: LatLng(39.9042, 116.4074),
      title: '北京天安门',
      color: Colors.red,
    ),
    _MapMarkerData(
      position: LatLng(31.2304, 121.4737),
      title: '上海外滩',
      color: Colors.blue,
    ),
    _MapMarkerData(
      position: LatLng(22.5431, 114.0579),
      title: '深圳市民中心',
      color: Colors.green,
    ),
  ];

  // 当前选中的城市索引
  int _selectedCityIndex = 0;

  /// 移动到指定城市
  void _moveToCity(int index) {
    final marker = _markers[index];
    _mapController.move(marker.position, _currentZoom);
    setState(() {
      _selectedCityIndex = index;
    });
  }

  /// 缩放控制
  void _zoomIn() {
    _currentZoom = (_currentZoom + 1).clamp(3.0, 18.0);
    _mapController.move(_mapController.camera.center, _currentZoom);
    setState(() {});
  }

  void _zoomOut() {
    _currentZoom = (_currentZoom - 1).clamp(3.0, 18.0);
    _mapController.move(_mapController.camera.center, _currentZoom);
    setState(() {});
  }

  /// 用户点击地图添加标记
  void _onMapTap(TapPosition tapPosition, LatLng latlng) {
    setState(() {
      _markers.add(_MapMarkerData(
        position: latlng,
        title: '自定义标记 ${_markers.length - 2}',
        color: Colors.orange,
      ));
    });
    _showSnackBar(
      '已添加标记: ${latlng.latitude.toStringAsFixed(4)}, ${latlng.longitude.toStringAsFixed(4)}',
    );
  }

  /// 清除自定义标记（保留前3个城市）
  void _clearCustomMarkers() {
    setState(() {
      if (_markers.length > 3) {
        _markers.removeRange(3, _markers.length);
        _showSnackBar('已清除自定义标记');
      }
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
    return Scaffold(
      appBar: AppBar(title: const Text('地图')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头部说明
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('FlutterMap 地图',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('使用 OpenStreetMap 图层，支持标记和手势操作',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 城市选择
            const SectionTitle('选择城市'),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final marker = _markers[index];
                  final isSelected = _selectedCityIndex == index;
                  return ChoiceChip(
                    label: Text(marker.title),
                    selected: isSelected,
                    onSelected: (_) => _moveToCity(index),
                    selectedColor: marker.color.withValues(alpha: 0.2),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // 地图
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 350,
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _markers[0].position,
                        initialZoom: _currentZoom,
                        onTap: _onMapTap,
                      ),
                      children: [
                        // OpenStreetMap 图层
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.flutter_learn',
                        ),
                        // 标记点图层
                        MarkerLayer(
                          markers: _markers.map((m) {
                            return Marker(
                              point: m.position,
                              width: 40,
                              height: 40,
                              child: GestureDetector(
                                onTap: () => _showSnackBar(m.title),
                                child: Icon(
                                  Icons.location_on,
                                  color: m.color,
                                  size: 40,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),

                    // 缩放控制按钮
                    Positioned(
                      right: 12,
                      top: 12,
                      child: Column(
                        children: [
                          _buildMapButton(Icons.add, _zoomIn),
                          const SizedBox(height: 4),
                          _buildMapButton(Icons.remove, _zoomOut),
                        ],
                      ),
                    ),

                    // 缩放级别显示
                    Positioned(
                      left: 12,
                      bottom: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Zoom: ${_currentZoom.toStringAsFixed(1)}',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),
            Text('点击地图可添加自定义标记',
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),

            // 标记列表
            const SectionTitle('标记点列表'),
            Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    ..._markers.asMap().entries.map((entry) {
                      final i = entry.key;
                      final m = entry.value;
                      return ListTile(
                        dense: true,
                        leading: Icon(Icons.location_on, color: m.color),
                        title: Text(m.title, style: const TextStyle(fontSize: 13)),
                        subtitle: Text(
                          '${m.position.latitude.toStringAsFixed(4)}, ${m.position.longitude.toStringAsFixed(4)}',
                          style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                        ),
                        onTap: () {
                          _mapController.move(m.position, _currentZoom);
                        },
                        trailing: i >= 3
                            ? IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () {
                                  setState(() => _markers.removeAt(i));
                                },
                              )
                            : null,
                      );
                    }),
                    if (_markers.length > 3)
                      TextButton(
                        onPressed: _clearCustomMarkers,
                        child: const Text('清除自定义标记'),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            // 知识点
            const ConceptNote(items: [
              'FlutterMap：基于 Leaflet 的开源地图组件',
              'TileLayer：地图瓦片图层，使用 OpenStreetMap 无需 API Key',
              'MarkerLayer：标记点图层，可自定义 Marker Widget',
              'MapController：控制地图的移动、缩放等操作',
              'MapOptions.onTap：监听地图点击事件获取经纬度',
            ]),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMapButton(IconData icon, VoidCallback onPressed) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(icon, size: 20),
        ),
      ),
    );
  }
}

/// 标记点数据模型
class _MapMarkerData {
  final LatLng position;
  final String title;
  final Color color;

  _MapMarkerData({
    required this.position,
    required this.title,
    required this.color,
  });
}
