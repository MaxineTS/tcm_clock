import 'package:flutter/material.dart';
import 'dart:math';
import '../theme/app_text_styles.dart';
import '../theme/app_colors.dart';
import '../models/shichen_data.dart';

class ClockDial extends StatelessWidget {
  final double size;
  final DateTime? now;
  final ShichenData? shichen;
  final int? ke;
  final double? shichenProgress;
  const ClockDial({super.key, this.size = 272, this.now, this.shichen, this.ke, this.shichenProgress});

  static const List<String> shichenTitles = [
    '子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥',
  ];

  @override
  Widget build(BuildContext context) {
    final double center = size / 2;
    final double radius = size / 2 - 40;
    final double dotRadius = 3;
    final double dotRingRadius = radius;
    final Color activeColor = AppColors.red500;
    final Color inactiveColor = AppColors.gray400;
    final Color dotColor = AppColors.gray400;

    // 当前时辰索引
    int currentIndex = shichenTitles.indexOf(shichen!.timeTitle);

    // 指针角度（指向当前时辰+几刻），整体逆时针转15°
    double pointerAngle = -pi / 2 - pi / 12;
    if (currentIndex >= 0 && shichenProgress != null) {
      // 每时辰30度
      double base = (currentIndex) * 2 * pi / 12;
      pointerAngle = -pi / 2 - pi / 12 + base + shichenProgress! * (2 * pi / 12);
    }

    final double pointerLength = radius * 0.85;
    final double pointerBase = radius * 0.1;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 表盘底层
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
              border: Border.all(width: 2, color: AppColors.gray100),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gray200.withOpacity(0.5),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
                BoxShadow(
                  color: AppColors.gray300.withOpacity(0.3),
                  offset: const Offset(0, 0),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          // 12个刻度点
          ...List.generate(12, (i) {
            final double angle = -pi / 2 + i * 2 * pi / 12 - pi / 12;
            final double xDot = center + dotRingRadius * cos(angle);
            final double yDot = center + dotRingRadius * sin(angle);
            return Positioned(
              left: xDot - dotRadius,
              top: yDot - dotRadius,
              child: Container(
                width: dotRadius * 2,
                height: dotRadius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor,
                ),
              ),
            );
          }),
          // 12个时辰字符
          ...List.generate(12, (i) {
            final double angle = -pi / 2 + (i + 0.5) * 2 * pi / 12 - pi / 12;
            final double xChar = center + radius * cos(angle);
            final double yChar = center + radius * sin(angle);
            final bool isActive = i == currentIndex;
            return Positioned(
              left: xChar - 12,
              top: yChar - 12,
              child: Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                child: Text(
                  shichenTitles[i],
                  style: isActive
                      ? AppTextStyles.bodyEmphasized.copyWith(color: activeColor)
                      : AppTextStyles.bodyRegular.copyWith(color: inactiveColor),
                ),
              ),
            );
          }),
          // 指针
          if (currentIndex >= 0)
            _PointerWedge(
              angle: pointerAngle,
              length: pointerLength,
              baseWidth: pointerBase,
              color: activeColor,
              center: center,
            ),
          // 中心点
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: activeColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _PointerWedge extends StatelessWidget {
  final double angle;
  final double length;
  final double baseWidth;
  final Color color;
  final double center;
  const _PointerWedge({
    required this.angle,
    required this.length,
    required this.baseWidth,
    required this.color,
    required this.center,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(center * 2, center * 2),
      painter: _PointerWedgePainter(
        angle: angle,
        length: length,
        baseWidth: baseWidth,
        color: color,
        center: center,
      ),
    );
  }
}

class _PointerWedgePainter extends CustomPainter {
  final double angle;
  final double length;
  final double baseWidth;
  final Color color;
  final double center;
  _PointerWedgePainter({
    required this.angle,
    required this.length,
    required this.baseWidth,
    required this.color,
    required this.center,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double tipWidth = baseWidth * 0.5;
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Offset c = Offset(center, center);
    final double perpAngle = angle + pi / 2;
    final Offset base1 = Offset(
      center + baseWidth / 2 * cos(perpAngle),
      center + baseWidth / 2 * sin(perpAngle),
    );
    final Offset base2 = Offset(
      center - baseWidth / 2 * cos(perpAngle),
      center - baseWidth / 2 * sin(perpAngle),
    );
    final double tipAngle = angle;
    final double tipPerpAngle = angle + pi / 2;
    final Offset top1 = Offset(
      center + length * cos(tipAngle) + tipWidth / 2 * cos(tipPerpAngle),
      center + length * sin(tipAngle) + tipWidth / 2 * sin(tipPerpAngle),
    );
    final Offset top2 = Offset(
      center + length * cos(tipAngle) - tipWidth / 2 * cos(tipPerpAngle),
      center + length * sin(tipAngle) - tipWidth / 2 * sin(tipPerpAngle),
    );
    
    // 创建指针路径
    final Path path = _createRoundedTipPointerPath(base1, base2, top1, top2);
    
    // 绘制阴影
    canvas.drawShadow(path, AppColors.red700.withOpacity(0.4), 3, false);
    
    // 绘制指针
    canvas.drawPath(path, paint);
  }
  
  Path _createRoundedTipPointerPath(Offset base1, Offset base2, Offset top1, Offset top2) {
    const double circleRadius = 2.5;
    
    final Path path = Path();
    
    // 计算顶部边的中点（圆的中心）
    final Offset topCenter = Offset(
      (top1.dx + top2.dx) / 2,
      (top1.dy + top2.dy) / 2,
    );
    
    // 绘制指针主体（梯形）
    path.moveTo(base1.dx, base1.dy);
    path.lineTo(base2.dx, base2.dy);
    path.lineTo(top2.dx, top2.dy);
    path.lineTo(top1.dx, top1.dy);
    path.close();
    
    // 在尖端添加圆
    path.addOval(Rect.fromCircle(center: topCenter, radius: circleRadius));
    
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

extension ShichenDataUI on ShichenData {
  String get meridianTimeText => '$timeTitle时${DateTime.now().minute ~/ 15 + 1}刻';
  String get timeRangeText => hours;
  String get meridianNameFull => meridian.fullName;
}
