# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run Commands

```bash
flutter pub get              # 安装依赖
flutter run                  # 运行（自动选择设备）
flutter run -d "iPhone 16 Pro"  # 指定iOS模拟器
flutter analyze              # 静态分析（零error为目标）
flutter test                 # 运行测试
flutter test test/widget_test.dart  # 单个测试
```

## Architecture

Flutter 学习工程，对标 SwiftUI 学习工程（/Users/maxiao/Desktop/demo/swiftUILearn），采用 MVVM + Provider 架构。

### 三层结构

- **`lib/core/`** — 基础设施层：Dio 网络管理（NetworkManager 单例）、数据模型（NewsArticle/Product/AppUser，数据源为 JSONPlaceholder API）、通用 UI 组件（LoadingView/ErrorView/SkeletonRow）
- **`lib/chapters/01-10/`** — 教学章节层：10 章 46 个独立 Demo 页面，每个页面使用 `DemoScaffold` 包裹，包含交互示例和 `ConceptNote` 知识点
- **`lib/modules/`** — 实战模块层：4 个 Tab（Home/Mall/News/Mine），每个模块有独立的 ViewModel（extends ChangeNotifier）+ Page + Widget

### 导航系统

`app.dart` 的 `MainPage` 是根页面，使用 Drawer 侧边栏导航。`resources/lesson_data.dart` 是集中式章节注册表，所有 Demo 通过 `Lesson.builder` 闭包延迟创建。添加新 Demo 只需：创建页面文件 → 在 `lesson_data.dart` 注册。

### ViewModel 模式

实战模块的 ViewModel 统一使用 `ChangeNotifier` + `ListenableBuilder` 监听，不依赖 Provider（Provider 仅在第三章教学 Demo 中使用）。ViewModel 持有 `isLoading`/`error`/数据列表等状态，View 层通过 `ListenableBuilder` 响应变化。

### 网络层

`NetworkManager` 是 Dio 单例，泛型 `request<T>` 方法接收 `fromJson` 函数做解码。`ApiEndpoint` 集中管理所有 URL 路径。支持指数退避重试（`requestWithRetry`）。

## Key Dependencies

- `dio` — HTTP 请求
- `provider` — 状态管理（仅教学 Demo 使用）
- `shared_preferences` / `sqflite` / `hive_flutter` — 持久化（教学 Demo）
- `fl_chart` — 图表
- `flutter_map` + `latlong2` — 地图（OpenStreetMap，无需 API key）
- `cached_network_image` — 图片缓存
- `share_plus` 9.x — 分享（API 为 `Share.share()`）

## Conventions

- Demo 页面使用 `DemoScaffold`（来自 `shared/shared_components.dart`）作为容器
- import 路径统一使用 `package:flutter_learn/...` 格式
- 代码注释使用中文
- Hive 在 `main.dart` 中通过 `Hive.initFlutter()` 全局初始化
