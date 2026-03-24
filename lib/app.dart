import 'package:flutter/material.dart';
import 'package:flutter_learn/models/lesson.dart';
import 'package:flutter_learn/resources/lesson_data.dart';

class FlutterLearnApp extends StatelessWidget {
  const FlutterLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 学习',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int? _selectedChapterIndex;
  int? _selectedLessonIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter 学习'),
        centerTitle: true,
      ),
      drawer: _buildDrawer(),
      body: _selectedChapterIndex != null && _selectedLessonIndex != null
          ? LessonData.chapters[_selectedChapterIndex!]
              .lessons[_selectedLessonIndex!]
              .builder()
          : _buildWelcome(),
    );
  }

  Widget _buildWelcome() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(size: 80),
            const SizedBox(height: 24),
            Text('Flutter 学习工程',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('对标 SwiftUI 学习工程的 Flutter 版本',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600])),
            const SizedBox(height: 32),
            // 统计
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _buildStatChip('${LessonData.chapters.length}', '章节'),
                _buildStatChip(
                  '${LessonData.chapters.fold<int>(0, (sum, c) => sum + c.lessons.length)}',
                  '知识点',
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text('← 打开侧边栏选择章节开始学习',
                style: TextStyle(color: Colors.grey[500])),
            const SizedBox(height: 32),
            // 章节概览
            ...LessonData.chapters.map((chapter) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: chapter.color.withValues(alpha: 0.15),
                    child: Icon(chapter.icon, color: chapter.color, size: 20),
                  ),
                  title: Text(chapter.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('${chapter.lessons.length} 个知识点', style: const TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right, size: 18),
                  onTap: () {
                    final idx = LessonData.chapters.indexOf(chapter);
                    setState(() {
                      _selectedChapterIndex = idx;
                      _selectedLessonIndex = 0;
                    });
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer)),
          Text(label, style: TextStyle(fontSize: 12,
              color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.7))),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FlutterLogo(size: 40),
                  const SizedBox(height: 12),
                  Text('Flutter 学习',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${LessonData.chapters.length} 章 · '
                      '${LessonData.chapters.fold<int>(0, (s, c) => s + c.lessons.length)} 个知识点',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: LessonData.chapters.length,
                itemBuilder: (context, chapterIndex) {
                  final chapter = LessonData.chapters[chapterIndex];
                  return _ChapterExpansionTile(
                    chapter: chapter,
                    chapterIndex: chapterIndex,
                    selectedChapterIndex: _selectedChapterIndex,
                    selectedLessonIndex: _selectedLessonIndex,
                    onLessonSelected: (lessonIndex) {
                      setState(() {
                        _selectedChapterIndex = chapterIndex;
                        _selectedLessonIndex = lessonIndex;
                      });
                      Navigator.pop(context); // 关闭 Drawer
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChapterExpansionTile extends StatelessWidget {
  final Chapter chapter;
  final int chapterIndex;
  final int? selectedChapterIndex;
  final int? selectedLessonIndex;
  final ValueChanged<int> onLessonSelected;

  const _ChapterExpansionTile({
    required this.chapter,
    required this.chapterIndex,
    required this.selectedChapterIndex,
    required this.selectedLessonIndex,
    required this.onLessonSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: chapter.color.withValues(alpha: 0.15),
        child: Icon(chapter.icon, color: chapter.color, size: 16),
      ),
      title: Text('第${chapterIndex + 1}章：${chapter.title}',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      initiallyExpanded: chapterIndex == selectedChapterIndex,
      children: chapter.lessons.asMap().entries.map((entry) {
        final lessonIndex = entry.key;
        final lesson = entry.value;
        final isSelected = chapterIndex == selectedChapterIndex && lessonIndex == selectedLessonIndex;
        return ListTile(
          dense: true,
          selected: isSelected,
          leading: Icon(lesson.icon, size: 18, color: isSelected ? chapter.color : Colors.grey),
          title: Text(lesson.title, style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          subtitle: Text(lesson.description, style: const TextStyle(fontSize: 11)),
          onTap: () => onLessonSelected(lessonIndex),
        );
      }).toList(),
    );
  }
}
