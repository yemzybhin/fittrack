import 'package:fittrack/feature/dashboard/presentation/pages/dashboard_page.dart';
import 'package:fittrack/feature/dashboard/presentation/pages/workout_page.dart';
import 'package:flutter/cupertino.dart';

import 'icons.dart';

class PageItem {
  final String title;
  final Widget widget;
  final String icon;
  final bool showDot;

  PageItem(
      {required this.title,
      required this.widget,
      required this.icon,
      this.showDot = false});

  static List<PageItem> pages = [
    PageItem(
        title: "Dash Board",
        widget: DashboardPage(),
        icon: CustomIcons.dashboard),
    PageItem(
        title: "Work Out", widget: WorkoutPage(), icon: CustomIcons.workout),
  ];
}
