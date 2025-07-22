
class Meridian {
  final String name;
  final String short;
  final String full;
  final String function;
  final String description;

  Meridian({
    required this.name,
    required this.short,
    required this.full,
    required this.function,
    required this.description,
  });

  factory Meridian.fromJson(Map<String, dynamic> json) {
    return Meridian(
      name: json['name'] ?? '',
      short: json['short'] ?? '',
      full: json['full'] ?? '',
      function: json['function'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class Reference {
  final String source;
  final String content;
  final String translation;

  Reference({
    required this.source,
    required this.content,
    required this.translation,
  });

  factory Reference.fromJson(Map<String, dynamic> json) {
    return Reference(
      source: json['source'] ?? '',
      content: json['content'] ?? '',
      translation: json['translation'] ?? '',
    );
  }
}

class Shichen {
  final String timeTitle;
  final String hours;
  final Meridian meridian;
  final String functionText;
  final String riskText;
  final String suggestion;
  final List<Reference> references;

  Shichen({
    required this.timeTitle,
    required this.hours,
    required this.meridian,
    required this.functionText,
    required this.riskText,
    required this.suggestion,
    required this.references,
  });

  factory Shichen.fromJson(Map<String, dynamic> json) {
    var refs = json['references'] as List<dynamic>? ?? [];
    return Shichen(
      timeTitle: json['timeTitle'] ?? '',
      hours: json['hours'] ?? '',
      meridian: Meridian.fromJson(json['meridian'] ?? {}),
      functionText: json['functionText'] ?? '',
      riskText: json['riskText'] ?? '',
      suggestion: json['suggestion'] ?? '',
      references: refs.map((e) => Reference.fromJson(e)).toList(),
    );
  }
}
