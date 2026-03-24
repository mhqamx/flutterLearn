# Flutter Learn

一个面向 Flutter 入门与进阶练习的学习工程，目标是用章节化 Demo 的方式覆盖常见 UI、状态管理、导航、存储、网络和绘制能力，并补充一个四 Tab 的综合示例模块。

## 项目定位

- 以知识点拆分页面，每个 Demo 都可独立查看和运行
- 使用侧边栏组织章节，适合按主题逐步学习
- 覆盖基础控件到综合模块的完整学习路径
- 对标 SwiftUI 学习工程，整理 Flutter 对应实现

## 当前内容

项目当前包含 11 个章节、47 个知识点示例：

1. 基础视图
   `Text`、`Image`、`Button`、`TextField`、`Switch`、`Slider`
2. 布局系统
   `Row/Column/Stack`、`Padding/Spacer`、`LayoutBuilder`、`GridView`、`ScrollView`
3. 状态管理
   `setState`、`Callback`、`ChangeNotifier`、`Provider`、`ValueNotifier`
4. 导航路由
   `Navigator`、`BottomSheet`、`Dialog`、`TabBar`、`AppBar`
5. 列表与数据
   `ListView`、分组列表、搜索过滤、`Dismissible`
6. 动画与过渡
   基础动画、`AnimatedSwitcher`、`Hero`、手势拖拽
7. 数据持久化
   `SharedPreferences`、文件读写、`SQLite`、`Hive`
8. 网络与系统
   `Dio` 请求、图片选择、系统分享、地图、定时器
9. 选择控件
   日期时间选择、进度指示器、菜单、焦点管理
10. 图形与样式
    `CustomPaint`、渐变、自定义 Widget、图表
11. 实战模块
    首页 / 商城 / 新闻 / 我的 四 Tab 示例应用

## 技术栈

- Flutter 3 / Dart 3
- Material 3
- `dio`
- `provider`
- `shared_preferences`
- `path_provider`
- `sqflite`
- `hive` / `hive_flutter`
- `cached_network_image`
- `image_picker`
- `fl_chart`
- `share_plus`
- `flutter_map`

## 项目结构

```text
lib/
├── app.dart                    # 应用入口与章节导航
├── main.dart                   # Flutter 启动与 Hive 初始化
├── chapters/                   # 分章节学习示例
│   ├── 01_basics/
│   ├── 02_layout/
│   ├── 03_state/
│   ├── 04_navigation/
│   ├── 05_list/
│   ├── 06_animation/
│   ├── 07_persistence/
│   ├── 08_network/
│   ├── 09_controls/
│   └── 10_graphics/
├── modules/                    # 综合业务模块示例
├── core/                       # 通用模型、网络层、公共组件
├── resources/                  # 章节与课程数据
├── models/                     # 课程模型
└── shared/                     # 共享 UI 组件
```

## 运行方式

```bash
flutter pub get
flutter run
```

常用命令：

```bash
flutter analyze
flutter test
```

## 应用说明

- 应用首页展示章节总览与知识点统计
- 左侧 Drawer 可按章节展开并选择具体 Demo
- 每个页面聚焦一个主题，便于单点理解和对照练习
- `实战模块` 提供更接近真实应用组织方式的参考实现

## 适用场景

- Flutter 初学者系统梳理常见控件与 API
- iOS / SwiftUI 开发者迁移学习 Flutter
- 团队内部用于课堂演示或知识点速查
- 作为新 Demo 或练习项目的基础模板
