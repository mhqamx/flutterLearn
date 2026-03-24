import 'package:flutter/material.dart';

class Lesson {
  final String title;
  final String description;
  final IconData icon;
  final Widget Function() builder;

  const Lesson({
    required this.title,
    required this.description,
    required this.icon,
    required this.builder,
  });
}

class Chapter {
  final String title;
  final IconData icon;
  final Color color;
  final List<Lesson> lessons;

  const Chapter({
    required this.title,
    required this.icon,
    required this.color,
    required this.lessons,
  });
}
