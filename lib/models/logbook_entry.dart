import 'package:flutter/material.dart';

class LogbookEntry {
  const LogbookEntry({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.icon,
    required this.accentColor,
    required this.backgroundColor,
  });

  final String title;
  final String subtitle;
  final String amount;
  final IconData icon;
  final Color accentColor;
  final Color backgroundColor;
}

class LogbookDateGroupData {
  const LogbookDateGroupData({required this.date, required this.entries});

  final String date;
  final List<LogbookEntry> entries;
}
