import 'package:flutter/material.dart';
import 'package:flutter_learn/models/lesson.dart';

// 第一章
import 'package:flutter_learn/chapters/01_basics/text_demo_page.dart';
import 'package:flutter_learn/chapters/01_basics/image_demo_page.dart';
import 'package:flutter_learn/chapters/01_basics/button_demo_page.dart';
import 'package:flutter_learn/chapters/01_basics/text_field_demo_page.dart';
import 'package:flutter_learn/chapters/01_basics/switch_demo_page.dart';
import 'package:flutter_learn/chapters/01_basics/slider_demo_page.dart';

// 第二章
import 'package:flutter_learn/chapters/02_layout/row_column_demo_page.dart';
import 'package:flutter_learn/chapters/02_layout/padding_demo_page.dart';
import 'package:flutter_learn/chapters/02_layout/layout_builder_demo_page.dart';
import 'package:flutter_learn/chapters/02_layout/grid_demo_page.dart';
import 'package:flutter_learn/chapters/02_layout/scroll_view_demo_page.dart';

// 第三章
import 'package:flutter_learn/chapters/03_state/set_state_demo_page.dart';
import 'package:flutter_learn/chapters/03_state/callback_demo_page.dart';
import 'package:flutter_learn/chapters/03_state/change_notifier_demo_page.dart';
import 'package:flutter_learn/chapters/03_state/provider_demo_page.dart';
import 'package:flutter_learn/chapters/03_state/riverpod_demo_page.dart';

// 第四章
import 'package:flutter_learn/chapters/04_navigation/navigator_demo_page.dart';
import 'package:flutter_learn/chapters/04_navigation/bottom_sheet_demo_page.dart';
import 'package:flutter_learn/chapters/04_navigation/dialog_demo_page.dart';
import 'package:flutter_learn/chapters/04_navigation/tab_bar_demo_page.dart';
import 'package:flutter_learn/chapters/04_navigation/app_bar_demo_page.dart';

// 第五章
import 'package:flutter_learn/chapters/05_list/list_basics_demo_page.dart';
import 'package:flutter_learn/chapters/05_list/list_section_demo_page.dart';
import 'package:flutter_learn/chapters/05_list/search_demo_page.dart';
import 'package:flutter_learn/chapters/05_list/dismissible_demo_page.dart';

// 第六章
import 'package:flutter_learn/chapters/06_animation/basic_animation_demo_page.dart';
import 'package:flutter_learn/chapters/06_animation/animated_switcher_demo_page.dart';
import 'package:flutter_learn/chapters/06_animation/hero_demo_page.dart';
import 'package:flutter_learn/chapters/06_animation/gesture_demo_page.dart';

// 第七章
import 'package:flutter_learn/chapters/07_persistence/shared_prefs_demo_page.dart';
import 'package:flutter_learn/chapters/07_persistence/file_demo_page.dart';
import 'package:flutter_learn/chapters/07_persistence/sqflite_demo_page.dart';
import 'package:flutter_learn/chapters/07_persistence/hive_demo_page.dart';

// 第八章
import 'package:flutter_learn/chapters/08_network/network_request_demo_page.dart';
import 'package:flutter_learn/chapters/08_network/image_picker_demo_page.dart';
import 'package:flutter_learn/chapters/08_network/share_demo_page.dart';
import 'package:flutter_learn/chapters/08_network/map_demo_page.dart';
import 'package:flutter_learn/chapters/08_network/timer_demo_page.dart';

// 第九章
import 'package:flutter_learn/chapters/09_controls/picker_demo_page.dart';
import 'package:flutter_learn/chapters/09_controls/progress_demo_page.dart';
import 'package:flutter_learn/chapters/09_controls/menu_demo_page.dart';
import 'package:flutter_learn/chapters/09_controls/focus_demo_page.dart';

// 第十章
import 'package:flutter_learn/chapters/10_graphics/custom_paint_demo_page.dart';
import 'package:flutter_learn/chapters/10_graphics/gradient_demo_page.dart';
import 'package:flutter_learn/chapters/10_graphics/custom_widget_demo_page.dart';
import 'package:flutter_learn/chapters/10_graphics/charts_demo_page.dart';

// 实战模块
import 'package:flutter_learn/modules/module_tab_page.dart';

class LessonData {
  static final List<Chapter> chapters = [
    Chapter(
      title: '基础视图',
      icon: Icons.widgets,
      color: Colors.blue,
      lessons: [
        Lesson(title: 'Text 文本', description: '显示和样式化文本内容', icon: Icons.text_fields, builder: () => const TextDemoPage()),
        Lesson(title: 'Image 图片', description: '展示图片和图标', icon: Icons.image, builder: () => const ImageDemoPage()),
        Lesson(title: 'Button 按钮', description: '各种按钮样式和交互', icon: Icons.smart_button, builder: () => const ButtonDemoPage()),
        Lesson(title: 'TextField 输入框', description: '文本输入和表单验证', icon: Icons.edit, builder: () => const TextFieldDemoPage()),
        Lesson(title: 'Switch 开关', description: '开关和复选框控件', icon: Icons.toggle_on, builder: () => const SwitchDemoPage()),
        Lesson(title: 'Slider 滑块', description: '滑块和范围选择', icon: Icons.tune, builder: () => const SliderDemoPage()),
      ],
    ),
    Chapter(
      title: '布局系统',
      icon: Icons.dashboard,
      color: Colors.green,
      lessons: [
        Lesson(title: 'Row/Column/Stack', description: '基础布局容器', icon: Icons.view_column, builder: () => const RowColumnDemoPage()),
        Lesson(title: 'Padding/Spacer', description: '间距和弹性布局', icon: Icons.space_bar, builder: () => const PaddingDemoPage()),
        Lesson(title: 'LayoutBuilder', description: '响应式布局和约束', icon: Icons.aspect_ratio, builder: () => const LayoutBuilderDemoPage()),
        Lesson(title: 'GridView 网格', description: '网格布局', icon: Icons.grid_view, builder: () => const GridDemoPage()),
        Lesson(title: 'ScrollView 滚动', description: '滚动容器和 Sliver', icon: Icons.view_list, builder: () => const ScrollViewDemoPage()),
      ],
    ),
    Chapter(
      title: '状态管理',
      icon: Icons.sync,
      color: Colors.orange,
      lessons: [
        Lesson(title: 'setState', description: '基础状态管理', icon: Icons.refresh, builder: () => const SetStateDemoPage()),
        Lesson(title: 'Callback 回调', description: '父子组件通信', icon: Icons.call_made, builder: () => const CallbackDemoPage()),
        Lesson(title: 'ChangeNotifier', description: '可观察对象模式', icon: Icons.notifications, builder: () => const ChangeNotifierDemoPage()),
        Lesson(title: 'Provider', description: '跨组件状态共享', icon: Icons.share, builder: () => const ProviderDemoPage()),
        Lesson(title: 'ValueNotifier', description: 'ValueNotifier 和 InheritedWidget', icon: Icons.lightbulb, builder: () => const RiverpodDemoPage()),
      ],
    ),
    Chapter(
      title: '导航路由',
      icon: Icons.navigation,
      color: Colors.purple,
      lessons: [
        Lesson(title: 'Navigator 导航', description: '页面跳转和传参', icon: Icons.arrow_forward, builder: () => const NavigatorDemoPage()),
        Lesson(title: 'BottomSheet 底部弹窗', description: '模态和可拖拽弹窗', icon: Icons.vertical_align_bottom, builder: () => const BottomSheetDemoPage()),
        Lesson(title: 'Dialog 对话框', description: '各种对话框样式', icon: Icons.chat_bubble, builder: () => const DialogDemoPage()),
        Lesson(title: 'TabBar 标签', description: '顶部和底部标签导航', icon: Icons.tab, builder: () => const TabBarDemoPage()),
        Lesson(title: 'AppBar 导航栏', description: '应用栏和工具栏', icon: Icons.web_asset, builder: () => const AppBarDemoPage()),
      ],
    ),
    Chapter(
      title: '列表与数据',
      icon: Icons.list,
      color: Colors.teal,
      lessons: [
        Lesson(title: 'ListView 列表', description: '基础列表视图', icon: Icons.format_list_bulleted, builder: () => const ListBasicsDemoPage()),
        Lesson(title: '分组列表', description: '分组和折叠列表', icon: Icons.segment, builder: () => const ListSectionDemoPage()),
        Lesson(title: 'Search 搜索', description: '搜索和过滤', icon: Icons.search, builder: () => const SearchDemoPage()),
        Lesson(title: 'Dismissible 滑动', description: '侧滑删除和操作', icon: Icons.swipe, builder: () => const DismissibleDemoPage()),
      ],
    ),
    Chapter(
      title: '动画与过渡',
      icon: Icons.animation,
      color: Colors.red,
      lessons: [
        Lesson(title: '基础动画', description: '隐式动画组件', icon: Icons.auto_awesome, builder: () => const BasicAnimationDemoPage()),
        Lesson(title: 'AnimatedSwitcher', description: '组件切换过渡', icon: Icons.swap_horiz, builder: () => const AnimatedSwitcherDemoPage()),
        Lesson(title: 'Hero 动画', description: '共享元素过渡', icon: Icons.flight, builder: () => const HeroDemoPage()),
        Lesson(title: 'Gesture 手势', description: '手势识别和拖拽', icon: Icons.touch_app, builder: () => const GestureDemoPage()),
      ],
    ),
    Chapter(
      title: '数据持久化',
      icon: Icons.storage,
      color: Colors.indigo,
      lessons: [
        Lesson(title: 'SharedPreferences', description: '键值对存储', icon: Icons.save, builder: () => const SharedPrefsDemoPage()),
        Lesson(title: 'File 文件', description: '文件读写操作', icon: Icons.insert_drive_file, builder: () => const FileDemoPage()),
        Lesson(title: 'SQLite 数据库', description: 'SQL 关系数据库', icon: Icons.table_chart, builder: () => const SqfliteDemoPage()),
        Lesson(title: 'Hive NoSQL', description: '轻量 NoSQL 存储', icon: Icons.inventory_2, builder: () => const HiveDemoPage()),
      ],
    ),
    Chapter(
      title: '网络与系统',
      icon: Icons.cloud,
      color: Colors.cyan,
      lessons: [
        Lesson(title: '网络请求', description: 'Dio HTTP 请求', icon: Icons.http, builder: () => const NetworkRequestDemoPage()),
        Lesson(title: '图片选择', description: '相册和相机', icon: Icons.photo_camera, builder: () => const ImagePickerDemoPage()),
        Lesson(title: '分享', description: '系统分享功能', icon: Icons.share, builder: () => const ShareDemoPage()),
        Lesson(title: '地图', description: 'OpenStreetMap 地图', icon: Icons.map, builder: () => const MapDemoPage()),
        Lesson(title: '定时器', description: 'Timer 和倒计时', icon: Icons.timer, builder: () => const TimerDemoPage()),
      ],
    ),
    Chapter(
      title: '选择控件',
      icon: Icons.checklist,
      color: Colors.amber,
      lessons: [
        Lesson(title: 'Picker 选择器', description: '日期、时间、下拉选择', icon: Icons.date_range, builder: () => const PickerDemoPage()),
        Lesson(title: 'Progress 进度', description: '进度指示器', icon: Icons.hourglass_bottom, builder: () => const ProgressDemoPage()),
        Lesson(title: 'Menu 菜单', description: '弹出和下拉菜单', icon: Icons.menu, builder: () => const MenuDemoPage()),
        Lesson(title: 'Focus 焦点', description: '焦点管理和键盘', icon: Icons.center_focus_strong, builder: () => const FocusDemoPage()),
      ],
    ),
    Chapter(
      title: '图形与样式',
      icon: Icons.palette,
      color: Colors.pink,
      lessons: [
        Lesson(title: 'CustomPaint 画布', description: '自定义绘制图形', icon: Icons.brush, builder: () => const CustomPaintDemoPage()),
        Lesson(title: 'Gradient 渐变', description: '线性、径向、扫描渐变', icon: Icons.gradient, builder: () => const GradientDemoPage()),
        Lesson(title: '自定义 Widget', description: '组合组件和主题', icon: Icons.extension, builder: () => const CustomWidgetDemoPage()),
        Lesson(title: 'Charts 图表', description: '柱状图、折线图、饼图', icon: Icons.bar_chart, builder: () => const ChartsDemoPage()),
      ],
    ),
    Chapter(
      title: '实战模块',
      icon: Icons.rocket_launch,
      color: Colors.deepOrange,
      lessons: [
        Lesson(title: '完整 App Demo', description: '首页/商城/新闻/我的 四Tab应用', icon: Icons.apps, builder: () => const ModuleTabPage()),
      ],
    ),
  ];
}
