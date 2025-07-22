// lib/models/city_info.dart

class CityInfo {
  final String province;
  final String city;
  final double latitude;
  final double longitude;
  final String standardTimezone;
  final String solarTimezone;
  final int solarOffsetMinutes;

  CityInfo({
    required this.province,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.standardTimezone,
    required this.solarTimezone,
    required this.solarOffsetMinutes,
  });

  factory CityInfo.fromJson(Map<String, dynamic> json) {
    return CityInfo(
      province: json['province'],
      city: json['city'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      standardTimezone: json['standard_timezone'],
      solarTimezone: json['solar_timezone'],
      solarOffsetMinutes: json['solar_offset_minutes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'province': province,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'standard_timezone': standardTimezone,
      'solar_timezone': solarTimezone,
      'solar_offset_minutes': solarOffsetMinutes,
    };
  }
}
