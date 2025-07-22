import 'package:flutter/material.dart';

class AppTextStyles {
  // Title1
  static const title1Emphasized = TextStyle(
    fontFamily: 'SourceHanSerif',
    fontWeight: FontWeight.bold,
    fontSize: 32,
    height: 40 / 32,
    letterSpacing: 0.08, // 8%
  );
  static const title1Regular = TextStyle(
    fontFamily: 'SourceHanSerif',
    fontWeight: FontWeight.normal,
    fontSize: 32,
    height: 40 / 32,
    letterSpacing: 0.04, // 4%
  );

  // Title2
  static const title2Emphasized = TextStyle(
    fontFamily: 'SourceHanSerif',
    fontWeight: FontWeight.bold,
    fontSize: 24,
    height: 32 / 24,
    letterSpacing: 0.10, // 10%
  );
  static const title2Regular = TextStyle(
    fontFamily: 'SourceHanSerif',
    fontWeight: FontWeight.normal,
    fontSize: 24,
    height: 32 / 24,
    letterSpacing: 0.06, // 6%
  );

  // Title3
  static const title3Emphasized = TextStyle(
    fontFamily: 'SourceHanSerif',
    fontWeight: FontWeight.bold,
    fontSize: 20,
    height: 24 / 20,
    letterSpacing: 0.04, // 4%
  );
  static const title3Regular = TextStyle(
    fontFamily: 'SourceHanSerif',
    fontWeight: FontWeight.normal,
    fontSize: 20,
    height: 24 / 20,
    letterSpacing: 0.03, // 3%
  );

  // Body
  static const bodyEmphasized = TextStyle(
    fontFamily: 'SourceHanSerif',
    fontWeight: FontWeight.bold,
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: 0.02, // 2%
  );
  static const bodyRegular = TextStyle(
    fontFamily: 'SourceHanSerif',
    fontWeight: FontWeight.normal,
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: 0.02, // 2%
  );

  // Subheadline
  static const subheadlineEmphasized = TextStyle(
    fontFamily: 'SourceHanSerif',
    fontWeight: FontWeight.w900, // Emphasized
    fontSize: 14,
    height: 16 / 14,
    letterSpacing: 0.02, // 2%
  );
  static const subheadlinerRegular = TextStyle(
    fontFamily: 'SourceHanSerif',
    fontWeight: FontWeight.w500, // Medium
    fontSize: 14,
    height: 16 / 14,
    letterSpacing: 0.02, // 2%
  );

  // Footnote
  static const footnoteEmphasized = TextStyle(
    fontFamily: 'SourceHanSerif',
    fontWeight: FontWeight.w900, // Emphasized
    fontSize: 12,
    height: 16 / 12,
    letterSpacing: 0.02, // 2%
  );
  static const footnoteRegular = TextStyle(
    fontFamily: 'SourceHanSerif',
    fontWeight: FontWeight.w500, // Medium
    fontSize: 12,
    height: 16 / 12,
    letterSpacing: 0.02, // 2%
  );
}
