import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_learn/shared/shared_components.dart';
import 'package:path_provider/path_provider.dart';

/// 文件读写演示页面
/// 展示文件系统操作（对应 iOS FileManager）
class FileDemoPage extends StatefulWidget {
  const FileDemoPage({super.key});

  @override
  State<FileDemoPage> createState() => _FileDemoPageState();
}

class _FileDemoPageState extends State<FileDemoPage> {
  String _appDocPath = '';
  String _tempPath = '';
  List<FileSystemEntity> _files = [];
  String _currentFileContent = '';
  String _selectedFileName = '';

  final _fileNameController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPaths();
  }

  @override
  void dispose() {
    _fileNameController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// 获取应用目录路径
  Future<void> _loadPaths() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final tempDir = await getTemporaryDirectory();
    setState(() {
      _appDocPath = appDocDir.path;
      _tempPath = tempDir.path;
    });
    _listFiles();
  }

  /// 获取笔记目录
  Future<Directory> _getNotesDir() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final notesDir = Directory('${appDocDir.path}/notes');
    if (!await notesDir.exists()) {
      await notesDir.create(recursive: true);
    }
    return notesDir;
  }

  /// 列出目录下的文件
  Future<void> _listFiles() async {
    final notesDir = await _getNotesDir();
    final files = notesDir.listSync()
      ..sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
    setState(() {
      _files = files;
    });
  }

  /// 写入文本文件
  Future<void> _writeFile() async {
    final fileName = _fileNameController.text.trim();
    final content = _contentController.text;
    if (fileName.isEmpty) {
      _showSnackBar('请输入文件名');
      return;
    }
    final notesDir = await _getNotesDir();
    final file = File('${notesDir.path}/$fileName.txt');
    await file.writeAsString(content);
    _fileNameController.clear();
    _contentController.clear();
    _showSnackBar('文件已保存: $fileName.txt');
    _listFiles();
  }

  /// 读取文本文件
  Future<void> _readFile(FileSystemEntity entity) async {
    final file = File(entity.path);
    final content = await file.readAsString();
    setState(() {
      _currentFileContent = content;
      _selectedFileName = file.path.split('/').last;
    });
  }

  /// 删除文件
  Future<void> _deleteFile(FileSystemEntity entity) async {
    final fileName = entity.path.split('/').last;
    await entity.delete();
    _showSnackBar('已删除: $fileName');
    if (_selectedFileName == fileName) {
      setState(() {
        _selectedFileName = '';
        _currentFileContent = '';
      });
    }
    _listFiles();
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: '文件读写',
      subtitle: '展示 dart:io 文件操作与 path_provider 获取目录（对应 iOS FileManager）',
      conceptItems: const [
        'path_provider：获取应用文档目录、临时目录等平台路径',
        'File：dart:io 中的文件类，支持读写操作',
        'Directory：目录操作，创建、列出、删除',
        'writeAsString/readAsString：文本文件的写入和读取',
        'getApplicationDocumentsDirectory：应用私有文档目录（持久化）',
      ],
      children: [
        const SectionTitle('应用目录路径'),
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPathRow('文档目录', _appDocPath),
              const SizedBox(height: 8),
              _buildPathRow('临时目录', _tempPath),
            ],
          ),
        ),

        const SectionTitle('写入笔记'),
        _buildCard(
          child: Column(
            children: [
              TextField(
                controller: _fileNameController,
                decoration: const InputDecoration(
                  hintText: '笔记标题（文件名）',
                  border: OutlineInputBorder(),
                  isDense: true,
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _contentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: '笔记内容...',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _writeFile,
                  icon: const Icon(Icons.save),
                  label: const Text('保存笔记'),
                ),
              ),
            ],
          ),
        ),

        const SectionTitle('笔记列表'),
        _buildCard(
          child: _files.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('暂无笔记，请先创建', style: TextStyle(color: Colors.grey)),
                  ),
                )
              : Column(
                  children: _files.map((entity) {
                    final fileName = entity.path.split('/').last;
                    final stat = entity.statSync();
                    final modTime = stat.modified;
                    final sizeKB = (stat.size / 1024).toStringAsFixed(1);
                    final isSelected = fileName == _selectedFileName;
                    return ListTile(
                      leading: Icon(
                        Icons.description,
                        color: isSelected ? Colors.blue : Colors.grey,
                      ),
                      title: Text(
                        fileName,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(
                        '${modTime.month}/${modTime.day} ${modTime.hour}:${modTime.minute.toString().padLeft(2, '0')}  |  $sizeKB KB',
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _deleteFile(entity),
                      ),
                      onTap: () => _readFile(entity),
                      selected: isSelected,
                    );
                  }).toList(),
                ),
        ),

        if (_selectedFileName.isNotEmpty) ...[
          const SectionTitle('文件内容'),
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.article, size: 18, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _selectedFileName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _currentFileContent.isEmpty ? '（空文件）' : _currentFileContent,
                    style: const TextStyle(fontSize: 14, height: 1.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPathRow(String label, String path) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ),
        Expanded(
          child: Text(
            path.isEmpty ? '加载中...' : path,
            style: TextStyle(fontSize: 11, color: Colors.grey[600], fontFamily: 'monospace'),
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
