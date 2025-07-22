import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  String currentProvince = '北京';
  String currentCity = '北京';
  int solarOffsetMinutes = 0;
  bool useSolarTime = false;

  // 保存所有地址，默认只包含北京
  List<List<String>> savedLocations = [
    ['北京', '北京']
  ];

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    currentProvince = prefs.getString('province') ?? '北京';
    currentCity = prefs.getString('city') ?? '北京';
    solarOffsetMinutes = prefs.getInt('solarOffsetMinutes') ?? 0;
    useSolarTime = prefs.getBool('useSolarTime') ?? false;
    notifyListeners();
  }

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('province', currentProvince);
    await prefs.setString('city', currentCity);
    await prefs.setInt('solarOffsetMinutes', solarOffsetMinutes);
    await prefs.setBool('useSolarTime', useSolarTime);
  }

  void updateLocation(String province, String city, int offset) {
    currentProvince = province;
    currentCity = city;
    solarOffsetMinutes = offset;
    saveToPrefs();
    notifyListeners();
  }

  void updateSolarTime(bool value) {
    useSolarTime = value;
    saveToPrefs();
    notifyListeners();
  }

  // 添加地址
  void addLocation(List<String> location) {
    if (!savedLocations.any((loc) => loc[0] == location[0] && loc[1] == location[1])) {
      savedLocations.add(location);
      notifyListeners();
    }
  }

  // 删除地址（北京永远保留）
  void removeLocation(int index) {
    if (index > 0 && index < savedLocations.length) {
      savedLocations.removeAt(index);
      notifyListeners();
    }
  }

  // 编辑地址
  void updateLocationAt(int index, List<String> newLocation) {
    if (index > 0 && index < savedLocations.length) {
      savedLocations[index] = newLocation;
      notifyListeners();
    }
  }
} 