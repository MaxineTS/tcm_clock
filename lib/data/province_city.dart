import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/city_info.dart';

// 从 cities.json 加载数据并创建省市映射
Future<Map<String, List<String>>> loadProvinceCityMap() async {
  final String jsonString = await rootBundle.loadString('lib/data/cities.json');
  final List<dynamic> jsonList = json.decode(jsonString);

  Map<String, List<String>> provinceCityMap = {};
  
  for (var item in jsonList) {
    final cityInfo = CityInfo.fromJson(item);
    final province = cityInfo.province.replaceAll('省', '').replaceAll('市', '').replaceAll('自治区', '');
    
    if (!provinceCityMap.containsKey(province)) {
      provinceCityMap[province] = [];
    }
    
    if (!provinceCityMap[province]!.contains(cityInfo.city)) {
      provinceCityMap[province]!.add(cityInfo.city);
    }
  }
  
  return provinceCityMap;
}

// 获取所有城市信息
Future<List<CityInfo>> loadAllCities() async {
  final String jsonString = await rootBundle.loadString('lib/data/cities.json');
  final List<dynamic> jsonList = json.decode(jsonString);

  return jsonList.map((item) => CityInfo.fromJson(item)).toList();
}

// 根据省市名称查找城市信息
Future<CityInfo?> findCityInfo(String province, String city) async {
  final cities = await loadAllCities();
  
  return cities.firstWhere(
    (cityInfo) => 
      cityInfo.province.replaceAll('省', '').replaceAll('市', '').replaceAll('自治区', '') == province &&
      cityInfo.city == city,
    orElse: () => throw StateError('City not found'),
  );
}