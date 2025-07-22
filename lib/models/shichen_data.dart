class ReferenceData {
  final String source;
  final String content;
  final String translation;
  ReferenceData({
    required this.source,
    required this.content,
    required this.translation,
  });
  factory ReferenceData.fromJson(Map<String, dynamic> json) => ReferenceData(
    source: json['source'],
    content: json['content'],
    translation: json['translation'],
  );
}

class MeridianData {
  final String name;
  final String shortName;
  final String fullName;
  final String function;
  final String description;
  MeridianData({
    required this.name,
    required this.shortName,
    required this.fullName,
    required this.function,
    required this.description,
  });
  factory MeridianData.fromJson(Map<String, dynamic> json) => MeridianData(
    name: json['name'],
    shortName: json['short'],
    fullName: json['full'],
    function: json['function'],
    description: json['description'],
  );
}

class ShichenData {
  final String timeTitle;
  final String hours;
  final MeridianData meridian;
  final String functionText;
  final String riskText;
  final String suggestion;
  final List<ReferenceData> references;
  ShichenData({
    required this.timeTitle,
    required this.hours,
    required this.meridian,
    required this.functionText,
    required this.riskText,
    required this.suggestion,
    required this.references,
  });
  factory ShichenData.fromJson(Map<String, dynamic> json) => ShichenData(
    timeTitle: json['timeTitle'],
    hours: json['hours'],
    meridian: MeridianData.fromJson(json['meridian']),
    functionText: json['functionText'],
    riskText: json['riskText'],
    suggestion: json['suggestion'],
    references: (json['references'] as List).map((e) => ReferenceData.fromJson(e)).toList(),
  );
} 