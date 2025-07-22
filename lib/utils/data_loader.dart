import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/shichen.dart';

Future<List<Shichen>> loadShichenData() async {
  final String jsonString = await rootBundle.loadString('lib/data/shichen_data.json');
  final List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((e) => Shichen.fromJson(e)).toList();
}
