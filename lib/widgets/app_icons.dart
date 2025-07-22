import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcons {
  // 16px icons
  static Widget chevronRight16({Color? color, double? size}) {
    return SvgPicture.asset(
      'assets/icons/16_chevron-right.svg',
      width: size ?? 16,
      height: size ?? 16,
      colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget chevronLeft16({Color? color, double? size}) {
    return SvgPicture.asset(
      'assets/icons/16_chevron-left.svg',
      width: size ?? 16,
      height: size ?? 16,
      colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget check16({Color? color, double? size}) {
    return SvgPicture.asset(
      'assets/icons/16_check.svg',
      width: size ?? 16,
      height: size ?? 16,
      colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget edit16({Color? color, double? size}) {
    return SvgPicture.asset(
      'assets/icons/16_edit.svg',
      width: size ?? 16,
      height: size ?? 16,
      colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget plus16({Color? color, double? size}) {
    return SvgPicture.asset(
      'assets/icons/16_plus.svg',
      width: size ?? 16,
      height: size ?? 16,
      colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget navigation16({Color? color, double? size}) {
    return SvgPicture.asset(
      'assets/icons/16_navigation.svg',
      width: size ?? 16,
      height: size ?? 16,
      colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  // 24px icons
  static Widget settings24({Color? color, double? size}) {
    return SvgPicture.asset(
      'assets/icons/24_setting.svg',
      width: size ?? 24,
      height: size ?? 24,
      colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget chevronLeft24({Color? color, double? size}) {
    return SvgPicture.asset(
      'assets/icons/24_chevron-left.svg',
      width: size ?? 24,
      height: size ?? 24,
      colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  // 32px meridian icons
  static Widget meridianIcon(String meridianName, {Color? color, double? size}) {
    String iconPath = 'assets/icons/32_${_getMeridianIconName(meridianName)}.svg';
    return SvgPicture.asset(
      iconPath,
      width: size ?? 32,
      height: size ?? 32,
      colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static String _getMeridianIconName(String meridianName) {
    switch (meridianName) {
      case '肺经':
        return 'lungs';
      case '大肠经':
        return 'largeIntestine';
      case '胃经':
        return 'stomach';
      case '脾经':
        return 'spleen';
      case '心经':
        return 'heart';
      case '小肠经':
        return 'smallIntestine';
      case '膀胱经':
        return 'bladder';
      case '肾经':
        return 'kidney';
      case '心包经':
        return 'pericardium';
      case '三焦经':
        return 'tripleBurner';
      case '胆经':
        return 'gallbladder';
      case '肝经':
        return 'liver';
      default:
        return 'heart'; // 默认图标
    }
  }
} 