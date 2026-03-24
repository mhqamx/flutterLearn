import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';
import 'package:image_picker/image_picker.dart';

/// 图片选择演示页面
/// 展示从相册选图和拍照功能（对应 iOS PhotosPicker）
class ImagePickerDemoPage extends StatefulWidget {
  const ImagePickerDemoPage({super.key});

  @override
  State<ImagePickerDemoPage> createState() => _ImagePickerDemoPageState();
}

class _ImagePickerDemoPageState extends State<ImagePickerDemoPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _singleImage;
  List<XFile> _multiImages = [];
  String _imageInfo = '';

  /// 从相册选择单张图片
  Future<void> _pickFromGallery() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (image != null) {
        final file = File(image.path);
        final size = await file.length();
        setState(() {
          _singleImage = image;
          _imageInfo = '路径: ${image.name}\n'
              '大小: ${(size / 1024).toStringAsFixed(1)} KB\n'
              'MIME: ${image.mimeType ?? "未知"}';
        });
      }
    } catch (e) {
      _showSnackBar('选择图片失败: $e');
    }
  }

  /// 拍照
  Future<void> _pickFromCamera() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (image != null) {
        final file = File(image.path);
        final size = await file.length();
        setState(() {
          _singleImage = image;
          _imageInfo = '路径: ${image.name}\n'
              '大小: ${(size / 1024).toStringAsFixed(1)} KB\n'
              '来源: 相机';
        });
      }
    } catch (e) {
      _showSnackBar('拍照失败（模拟器可能不支持相机）: $e');
    }
  }

  /// 选择多张图片
  Future<void> _pickMultiImages() async {
    try {
      final images = await _picker.pickMultiImage(
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 80,
      );
      if (images.isNotEmpty) {
        setState(() {
          _multiImages = images;
        });
        _showSnackBar('已选择 ${images.length} 张图片');
      }
    } catch (e) {
      _showSnackBar('选择图片失败: $e');
    }
  }

  void _showSnackBar(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: '图片选择',
      subtitle: '使用 image_picker 从相册选图或拍照（对应 iOS PhotosPicker）',
      conceptItems: const [
        'ImagePicker：Flutter 图片选择插件，支持相册和相机',
        'pickImage：选择单张图片，可设置最大宽高和质量',
        'pickMultiImage：选择多张图片',
        'ImageSource.gallery/camera：指定图片来源',
        'XFile：跨平台的文件类，包含路径、名称等信息',
      ],
      children: [
        const SectionTitle('选择单张图片'),
        _buildCard(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickFromGallery,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('从相册选择'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickFromCamera,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('拍照'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 显示选中的单张图片
              if (_singleImage != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(_singleImage!.path),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _imageInfo,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ] else
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 40, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('未选择图片', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
            ],
          ),
        ),

        const SectionTitle('选择多张图片'),
        _buildCard(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _pickMultiImages,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('选择多张图片'),
                ),
              ),
              const SizedBox(height: 12),

              if (_multiImages.isNotEmpty) ...[
                Text('已选择 ${_multiImages.length} 张图片',
                    style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                // 图片网格
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _multiImages.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(
                            File(_multiImages[index].path),
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ] else
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('点击上方按钮选择多张图片', style: TextStyle(color: Colors.grey)),
                  ),
                ),
            ],
          ),
        ),

        // 注意事项
        const SectionTitle('注意事项'),
        _buildCard(
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('模拟器上拍照功能可能不可用',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                '- iOS 需要在 Info.plist 中配置相机和相册权限\n'
                '- Android 需要在 AndroidManifest.xml 中配置权限\n'
                '- maxWidth/maxHeight 可限制图片尺寸\n'
                '- imageQuality (0-100) 控制压缩质量',
                style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.6),
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
