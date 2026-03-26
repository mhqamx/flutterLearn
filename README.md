# Flutter Learn

一个面向 Flutter 入门与进阶练习的学习工程，对标 SwiftUI 学习工程，用章节化 Demo 的方式覆盖常见 UI、状态管理、导航、存储、网络和绘制能力，并补充一个四 Tab 的综合示例模块。

## 项目定位

- 以知识点拆分页面，每个 Demo 都可独立查看和运行
- 使用侧边栏组织章节，适合按主题逐步学习
- 覆盖基础控件到综合模块的完整学习路径
- 对标 SwiftUI 学习工程，整理 Flutter 对应实现
- 适合 iOS / SwiftUI 开发者迁移学习 Flutter

## 架构设计

### MVVM + ChangeNotifier

```
┌──────────────────────────────────────────┐
│  View（Page / Widget）                    │
│  - 纯 UI，只负责展示                       │
│  - 用 ListenableBuilder 监听 ViewModel    │
└────────────┬─────────────────────────────┘
             │ 监听
┌────────────▼─────────────────────────────┐
│  ViewModel（extends ChangeNotifier）       │
│  - 持有状态：isLoading / error / 数据列表    │
│  - 调用 NetworkManager 获取数据             │
│  - notifyListeners() 通知 UI 刷新          │
└────────────┬─────────────────────────────┘
             │ 请求
┌────────────▼─────────────────────────────┐
│  Model / Network                          │
│  - 数据模型（NewsArticle / Product 等）      │
│  - NetworkManager 单例封装 Dio 请求          │
└──────────────────────────────────────────┘
```

### 三层结构

- **`lib/core/`** — 基础设施层：Dio 网络管理（NetworkManager 单例）、数据模型（NewsArticle / Product / AppUser，数据源为 JSONPlaceholder API）、通用 UI 组件（LoadingView / ErrorView）
- **`lib/chapters/01-10/`** — 教学章节层：10 章 46 个独立 Demo 页面，每个页面使用 `DemoScaffold` 包裹，包含交互示例和 `ConceptNote` 知识点
- **`lib/modules/`** — 实战模块层：4 个 Tab（Home / Mall / News / Mine），每个模块有独立的 ViewModel（extends ChangeNotifier）+ Page + Widget

### 导航系统

`app.dart` 的 `MainPage` 是根页面，使用 Drawer 侧边栏导航。`resources/lesson_data.dart` 是集中式章节注册表，所有 Demo 通过 `Lesson.builder` 闭包延迟创建。添加新 Demo 只需：创建页面文件 → 在 `lesson_data.dart` 注册。

### ViewModel 模式

实战模块的 ViewModel 统一使用 `ChangeNotifier` + `ListenableBuilder` 监听，不依赖 Provider（Provider 仅在第三章教学 Demo 中使用）。ViewModel 持有 `isLoading` / `error` / 数据列表等状态，View 层通过 `ListenableBuilder` 响应变化。

### 网络层

`NetworkManager` 是 Dio 单例，泛型 `request<T>` 方法接收 `fromJson` 函数做解码。`ApiEndpoint` 集中管理所有 URL 路径。支持指数退避重试（`requestWithRetry`，1s → 2s → 4s）。

## 项目结构

```
flutterLearn/
├── lib/                              # 所有 Dart 源码（核心目录）
│   ├── main.dart                     # 应用入口，初始化 Hive，启动 App
│   ├── app.dart                      # 根 Widget，配置主题、Drawer 导航
│   │
│   ├── core/                         # 基础设施层
│   │   ├── network/                  # 网络层
│   │   │   ├── network_manager.dart  #   Dio 单例封装，统一请求入口
│   │   │   ├── api_endpoint.dart     #   API 地址集中管理
│   │   │   └── api_error.dart        #   错误类型定义与分类
│   │   ├── components/               # 通用 UI 组件
│   │   │   ├── loading_view.dart     #   加载中视图
│   │   │   └── error_view.dart       #   错误展示视图
│   │   └── models/                   # 数据模型
│   │       ├── news_article.dart     #   新闻文章模型
│   │       ├── product.dart          #   商品模型
│   │       └── app_user.dart         #   用户模型
│   │
│   ├── chapters/                     # 教学章节层（10 章 46 个 Demo）
│   │   ├── 01_basics/                #   第1章：基础视图
│   │   ├── 02_layout/                #   第2章：布局系统
│   │   ├── 03_state/                 #   第3章：状态管理
│   │   ├── 04_navigation/            #   第4章：导航路由
│   │   ├── 05_list/                  #   第5章：列表与数据
│   │   ├── 06_animation/             #   第6章：动画与过渡
│   │   ├── 07_persistence/           #   第7章：数据持久化
│   │   ├── 08_network/               #   第8章：网络与系统
│   │   ├── 09_controls/              #   第9章：选择控件
│   │   └── 10_graphics/              #   第10章：图形与样式
│   │
│   ├── modules/                      # 实战模块层（完整 App Demo）
│   │   ├── module_tab_page.dart      #   4-Tab 主页面容器
│   │   ├── home/                     #   首页模块（Banner + 推荐列表）
│   │   │   ├── home_page.dart
│   │   │   ├── home_view_model.dart
│   │   │   └── home_banner_widget.dart
│   │   ├── mall/                     #   商城模块（商品网格）
│   │   │   ├── mall_page.dart
│   │   │   ├── mall_view_model.dart
│   │   │   └── product_card_widget.dart
│   │   ├── news/                     #   新闻模块（新闻列表）
│   │   │   ├── news_page.dart
│   │   │   ├── news_view_model.dart
│   │   │   └── news_row_widget.dart
│   │   └── mine/                     #   我的模块（个人中心）
│   │       ├── mine_page.dart
│   │       └── mine_view_model.dart
│   │
│   ├── models/
│   │   └── lesson.dart               # Chapter / Lesson 数据结构定义
│   ├── resources/
│   │   └── lesson_data.dart          # 章节注册表（所有 Demo 的集中注册）
│   └── shared/
│       └── shared_components.dart    # 通用组件（DemoScaffold / ConceptNote / SectionTitle）
│
├── pubspec.yaml                      # 项目配置 + 依赖声明
├── analysis_options.yaml             # Dart 静态分析规则
├── android/                          # Android 平台代码（Gradle）
├── ios/                              # iOS 平台代码（Xcode + CocoaPods）
├── macos/                            # macOS 平台代码
├── web/                              # Web 平台代码
├── linux/                            # Linux 平台代码
├── windows/                          # Windows 平台代码
└── test/                             # 测试目录
```

## 教学章节内容

项目当前包含 10 个教学章节 + 1 个实战模块，共 47 个知识点示例：

| 章节 | 主题 | Demo 数 | 涵盖内容 |
|------|------|---------|---------|
| 第1章 | 基础视图 | 6 | Text、Image、Button、TextField、Switch、Slider |
| 第2章 | 布局系统 | 5 | Row/Column/Stack、Padding/Spacer、LayoutBuilder、GridView、ScrollView |
| 第3章 | 状态管理 | 5 | setState、Callback、ChangeNotifier、Provider、ValueNotifier |
| 第4章 | 导航路由 | 5 | Navigator、BottomSheet、Dialog、TabBar、AppBar |
| 第5章 | 列表与数据 | 4 | ListView、分组列表、搜索过滤、Dismissible 侧滑删除 |
| 第6章 | 动画与过渡 | 4 | 隐式动画、AnimatedSwitcher、Hero 过渡、手势拖拽 |
| 第7章 | 数据持久化 | 4 | SharedPreferences、文件读写、SQLite、Hive |
| 第8章 | 网络与系统 | 5 | Dio HTTP 请求、图片选择、系统分享、OpenStreetMap 地图、定时器 |
| 第9章 | 选择控件 | 4 | 日期时间选择器、进度指示器、菜单、焦点管理 |
| 第10章 | 图形与样式 | 4 | CustomPaint 画布绘制、渐变、自定义 Widget、图表 |
| 实战 | 完整 App | 1 | 首页 / 商城 / 新闻 / 我的 四 Tab 应用 |

## 技术栈与依赖

### 语言与框架

| 技术 | 说明 |
|------|------|
| Dart 3 | Flutter 的编程语言，强类型，支持 async/await |
| Flutter SDK ^3.11 | 跨平台 UI 框架，一套代码编译到 iOS / Android / macOS / Web / Linux / Windows |
| Material 3 | Google 最新设计规范，通过 `useMaterial3: true` 启用 |

### 第三方依赖

| 库 | 版本 | 用途 | 类比 iOS |
|---|---|---|---|
| `dio` | ^5.4.0 | HTTP 客户端，支持拦截器、超时、取消 | Alamofire |
| `provider` | ^6.1.0 | 跨组件状态共享（仅教学 Demo 使用） | Combine / @EnvironmentObject |
| `shared_preferences` | ^2.2.0 | 键值对存储 | UserDefaults |
| `path_provider` | ^2.1.0 | 获取文件系统路径 | FileManager |
| `sqflite` | ^2.3.0 | SQLite 关系数据库 | Core Data / GRDB |
| `hive` / `hive_flutter` | ^2.2.3 | 轻量 NoSQL 数据库，纯 Dart 实现 | Realm 轻量替代 |
| `cached_network_image` | ^3.3.0 | 网络图片加载 + 磁盘缓存 | SDWebImage / Kingfisher |
| `image_picker` | ^1.0.0 | 调用相册 / 相机选择图片 | UIImagePickerController |
| `fl_chart` | ^0.68.0 | 柱状图、折线图、饼图 | Charts |
| `flutter_map` + `latlong2` | ^7.0.0 | OpenStreetMap 地图展示（免费，无需 API Key） | MapKit |
| `share_plus` | ^9.0.0 | 调用系统分享面板 | UIActivityViewController |
| `cupertino_icons` | ^1.0.8 | iOS 风格图标库 | SF Symbols |

### 开发工具

| 工具 | 用途 |
|------|------|
| `flutter_lints` | 官方推荐的 Dart 代码规范检查（类似 SwiftLint） |
| `flutter analyze` | 静态代码分析，目标零 error |
| `flutter test` | 单元测试 / Widget 测试 |
| Flutter DevTools | 性能分析、Widget 树查看器 |
| Hot Reload | 保存文件即时刷新 UI（类似 SwiftUI Preview，但更快） |

## SwiftUI 对照表

| SwiftUI 概念 | Flutter 对应 |
|-------------|-------------|
| `View` struct | `StatelessWidget` / `StatefulWidget` |
| `@State` | `setState()` |
| `@ObservedObject` / `@StateObject` | `ChangeNotifier` + `ListenableBuilder` |
| `@EnvironmentObject` | `Provider` |
| `NavigationStack` | `Navigator` |
| `List` / `ForEach` | `ListView.builder` |
| `VStack` / `HStack` / `ZStack` | `Column` / `Row` / `Stack` |
| `.padding()` | `Padding` widget |
| `UserDefaults` | `SharedPreferences` |
| SwiftUI Preview | Hot Reload |

## 运行方式

```bash
flutter pub get                    # 安装依赖（类似 pod install）
flutter run                        # 运行（自动选择连接的设备）
flutter run -d "iPhone 16 Pro"     # 指定 iOS 模拟器运行
flutter analyze                    # 静态代码分析
flutter test                       # 运行测试
```

## 适用场景

- Flutter 初学者系统梳理常见控件与 API
- iOS / SwiftUI 开发者迁移学习 Flutter
- 团队内部用于课堂演示或知识点速查
- 作为新 Demo 或练习项目的基础模板
