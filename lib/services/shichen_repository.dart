import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/shichen_data.dart';

class ShichenRepository {
  Future<List<ShichenData>> loadAll() async {
    final String jsonString = await rootBundle.loadString('lib/data/shichen_data.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((item) => ShichenData.fromJson(item)).toList();
  }

  /// 查找当前时辰（ShichenData）
  ShichenData? findCurrentShichen(DateTime now, List<ShichenData> shichenList) {
    for (final s in shichenList) {
      final range = s.hours.split('–');
      if (range.length != 2) continue;
      final startParts = range[0].split(':');
      final endParts = range[1].split(':');
      if (startParts.length != 2 || endParts.length != 2) continue;
      int startHour = int.parse(startParts[0]);
      int startMinute = int.parse(startParts[1]);
      int endHour = int.parse(endParts[0]);
      int endMinute = int.parse(endParts[1]);
      final start = DateTime(now.year, now.month, now.day, startHour, startMinute);
      // 跨天处理：如果结束小时小于开始小时，说明跨天
      DateTime end = DateTime(now.year, now.month, now.day, endHour, endMinute);
      if (end.isBefore(start)) {
        end = end.add(Duration(days: 1));
      }
      // 处理 now 可能在第二天凌晨的情况
      DateTime testNow = now;
      if (now.isBefore(start)) {
        testNow = now.add(Duration(days: 1));
      }
      if (!testNow.isBefore(start) && testNow.isBefore(end)) {
        return s;
      }
    }
    return null;
  }

  /// 计算当前时辰内的“几刻”（每刻15分钟）
  int getKeInShichen(DateTime now, ShichenData shichen) {
    final range = shichen.hours.split('–');
    if (range.length != 2) return 1;
    final startParts = range[0].split(':');
    final endParts = range[1].split(':');
    if (startParts.length != 2 || endParts.length != 2) return 1;
    int startHour = int.parse(startParts[0]);
    int startMinute = int.parse(startParts[1]);
    int endHour = int.parse(endParts[0]);
    int endMinute = int.parse(endParts[1]);
    DateTime start = DateTime(now.year, now.month, now.day, startHour, startMinute);
    // 跨天处理
    if (startHour > endHour || (startHour == endHour && startMinute > endMinute)) {
      // 跨天时辰（如子时）
      if (now.hour < startHour || (now.hour == startHour && now.minute < startMinute)) {
        start = start.subtract(Duration(days: 1));
      }
    } else if (now.isBefore(start)) {
      start = start.subtract(Duration(days: 1));
    }
    final diff = now.difference(start);
    final ke = (diff.inMinutes ~/ 15) + 1;
    return ke.clamp(1, 8); // 每时辰8刻
  }

  /// 获取当前时辰内的进度百分比（0~1），用于表盘指针
  double getShichenProgress(DateTime now, ShichenData shichen) {
    final range = shichen.hours.split('–');
    if (range.length != 2) return 0.0;
    final startParts = range[0].split(':');
    final endParts = range[1].split(':');
    if (startParts.length != 2 || endParts.length != 2) return 0.0;
    int startHour = int.parse(startParts[0]);
    int startMinute = int.parse(startParts[1]);
    int endHour = int.parse(endParts[0]);
    int endMinute = int.parse(endParts[1]);
    DateTime start = DateTime(now.year, now.month, now.day, startHour, startMinute);
    DateTime end = DateTime(now.year, now.month, now.day, endHour, endMinute);
    // 跨天处理
    if (startHour > endHour || (startHour == endHour && startMinute > endMinute)) {
      if (now.hour < startHour || (now.hour == startHour && now.minute < startMinute)) {
        start = start.subtract(Duration(days: 1));
        end = end.add(Duration(days: 1));
      } else {
        end = end.add(Duration(days: 1));
      }
    } else if (now.isBefore(start)) {
      start = start.subtract(Duration(days: 1));
      end = end.subtract(Duration(days: 1));
    }
    final total = end.difference(start).inMinutes;
    final elapsed = now.difference(start).inMinutes;
    return (elapsed / total).clamp(0.0, 1.0);
  }
}
