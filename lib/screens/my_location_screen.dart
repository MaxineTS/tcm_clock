import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../data/province_city.dart';
import '../models/city_info.dart';
import '../widgets/custom_switch.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_radius.dart';
import 'package:provider/provider.dart';
import '../models/app_settings.dart';
import '../widgets/app_icons.dart';

class MyLocationScreen extends StatefulWidget {
  const MyLocationScreen({super.key});

  @override
  State<MyLocationScreen> createState() => _MyLocationScreenState();
}

class _MyLocationScreenState extends State<MyLocationScreen> {
  int? selectedIndex;
  List<List<String>> savedLocations = [
    ['北京', '北京'],
  ];
  Map<String, List<String>>? provinceCityMap;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProvinceCityData();
    // 默认选中北京
    selectedIndex = 0;
  }

  Future<void> _loadProvinceCityData() async {
    try {
      final data = await loadProvinceCityMap();
      setState(() {
        provinceCityMap = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<String>?> _showAddLocationPicker() async {
    if (provinceCityMap == null) return null;
    
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => ProvinceCityPicker(provinceCityMap: provinceCityMap!),
    );
    if (result != null && result.length == 2) {
      return result;
    }
    return null;
  }

  void _showLocationSwitchPicker(int index) async {
    if (provinceCityMap == null) return;
    final appSettings = Provider.of<AppSettings>(context, listen: false);
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => ProvinceCityPicker(provinceCityMap: provinceCityMap!),
    );
    if (result != null && result.length == 2) {
      setState(() {
        savedLocations[index] = [result[0], result[1]];
      });
      // 查找 solarOffsetMinutes
      final cityInfo = await findCityInfo(result[0], result[1]);
      appSettings.updateLocation(result[0], result[1], cityInfo?.solarOffsetMinutes ?? 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.gray50,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final appSettings = Provider.of<AppSettings>(context);
    bool useCurrentLocation = appSettings.currentProvince == '定位' || appSettings.currentCity == '定位';
    List<List<String>> savedLocations = appSettings.savedLocations;
    // 自动同步selectedIndex
    int? globalSelectedIndex = savedLocations.indexWhere((loc) =>
      loc[0] == appSettings.currentProvince && loc[1] == appSettings.currentCity);
    selectedIndex = globalSelectedIndex >= 0 ? globalSelectedIndex : null;
    // 如果没有选中项，自动选中北京
    if (selectedIndex == null) {
      final beijingIndex = savedLocations.indexWhere((loc) => loc[0] == '北京' && loc[1] == '北京');
      if (beijingIndex >= 0) {
        selectedIndex = beijingIndex;
        appSettings.updateLocation('北京', '北京', 0);
      }
    }

    // 计算当前展示的城市（用于设置页等）
    String displayLocation;
    if (useCurrentLocation && savedLocations.isNotEmpty) {
      displayLocation = '定位';
    } else if (!useCurrentLocation && selectedIndex != null) {
      displayLocation = '${savedLocations[selectedIndex!][0]} ${savedLocations[selectedIndex!][1]}';
    } else {
      displayLocation = '北京市';
    }

    List<BorderRadius?> itemRadii = List.generate(savedLocations.length, (i) {
      if (savedLocations.length == 1) {
        return BorderRadius.circular(10);
      } else if (i == 0) {
        return const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        );
      } else if (i == savedLocations.length - 1) {
        return const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        );
      }
      return null;
    });

    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部标题区
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.s32, bottom:AppSpacing.s24),
                child: Row(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        onTap: () => Navigator.of(context).pop(displayLocation),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.s8),
                          child: AppIcons.chevronLeft24(color: AppColors.gray700),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.s8),
                    Text(
                      '我的位置',
                      style: AppTextStyles.title2Emphasized.copyWith(
                        color: AppColors.gray700,
                        letterSpacing: 2.4,
                      ),
                    ),
                  ],
                ),
              ),
              // 内容区
              SizedBox(height: 0),
              Expanded(
                child: ListView(
                  children: [
                    // 获取当前位置开关
                    // _LocationCard(
                    //   borderColor: AppColors.gray100,
                    //   showShadow: true,
                    //   disabled: false,
                    //   child: _LocationSwitchItem(
                    //     title: '获取当前位置',
                    //     value: useCurrentLocation,
                    //     onChanged: (v) {
                    //       setState(() {
                    //         useCurrentLocation = v;
                    //         if (v) {
                    //           selectedIndex = null;
                    //           // 更新全局设置为定位
                    //           appSettings.updateLocation('定位', '定位', 0);
                    //         } else {
                    //           // 如果关闭定位，默认选中北京
                    //           selectedIndex = 0;
                    //           appSettings.updateLocation('北京', '北京', 0);
                    //         }
                    //       });
                    //     },
                    //   ),
                    // ),
                // 已保存位置列表
                    if (savedLocations.isNotEmpty)
                      _LocationCard(
                        borderColor: useCurrentLocation ? AppColors.gray300 : AppColors.gray100,
                        showShadow: !useCurrentLocation,
                        disabled: useCurrentLocation,
                        child: Column(
                          children: [
                            for (int i = 0; i < savedLocations.length; i++) ...[
                              // 判断圆角
                              AbsorbPointer(
                                absorbing: useCurrentLocation,
                                child: Dismissible(
                                  key: ValueKey('${savedLocations[i][0]}-${savedLocations[i][1]}'),
                                  direction: (useCurrentLocation || savedLocations[i][0] == '北京') ? DismissDirection.none : DismissDirection.endToStart,
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    color: AppColors.burgandy700,
                                    padding: const EdgeInsets.only(right: 24),
                                    child: Icon(Icons.delete, color: Colors.white, size: 24),
                                  ),
                                  onDismissed: (direction) {
                                   setState(() {
                                     savedLocations.removeAt(i);
                                     // 如果删除的是当前选中项，则重置 Provider 状态为默认
                                     if (selectedIndex == i) {
                                       appSettings.updateLocation('北京', '北京', 0);
                                     }
                                   });
                                  },
                                  child: _LocationListItem(
                                    province: savedLocations[i][0],
                                    city: savedLocations[i][1],
                                    onEdit: savedLocations[i][0] == '北京' ? null : () async {
                                      if (!useCurrentLocation) {
                                        final appSettings = Provider.of<AppSettings>(context, listen: false);
                                        final result = await showModalBottomSheet<List<String>>(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (context) => ProvinceCityPicker(provinceCityMap: provinceCityMap!),
                                        );
                                        if (result != null && result.length == 2) {
                                          appSettings.updateLocationAt(i, [result[0], result[1]]);
                                          if (selectedIndex == i) {
                                            final cityInfo = await findCityInfo(result[0], result[1]);
                                            appSettings.updateLocation(result[0], result[1], cityInfo?.solarOffsetMinutes ?? 0);
                                          }
                                        }
                                      }
                                    },
                                   selected: !useCurrentLocation && selectedIndex == i,
                                   onTap: useCurrentLocation
                                       ? null
                                       : () async {
                                           setState(() => selectedIndex = i);
                                           // 查找 solarOffsetMinutes
                                           final cityInfo = await findCityInfo(savedLocations[i][0], savedLocations[i][1]);
                                           appSettings.updateLocation(
                                             savedLocations[i][0],
                                             savedLocations[i][1],
                                             cityInfo?.solarOffsetMinutes ?? 0,
                                           );
                                         },
                                    disabled: useCurrentLocation,
                                    showEditButton: savedLocations[i][0] != '北京',
                                    borderRadius: itemRadii[i],
                                  ),
                                ),
                              ),
                              // Add divider between items (except for the last one)
                              if (i < savedLocations.length - 1)
                                Container(
                                  height: 0.5,
                                  color: AppColors.gray200,
                                ),
                            ],
                          ],
                        ),
                      ),
                    if (savedLocations.isNotEmpty) SizedBox(height: AppSpacing.s40),
                    // 添加位置按钮
                    AbsorbPointer(
                      absorbing: useCurrentLocation,
                      child: _LocationCard(
                        child: _AddLocationItem(
                          onTap: useCurrentLocation ? null : () async {
                            final result = await _showAddLocationPicker();
                            if (result != null && result.length == 2) {
                              setState(() {
                                savedLocations.add([result[0], result[1]]);
                              });
                            }
                          },
                          disabled: useCurrentLocation,
                        ),
                        borderColor: useCurrentLocation ? AppColors.gray300 : AppColors.gray100,
                        showShadow: !useCurrentLocation,
                        disabled: useCurrentLocation,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String displayProvince(String name) {
  if (name.startsWith('广西')) return '广西';
  if (name.startsWith('新疆')) return '新疆';
  if (name.startsWith('宁夏')) return '宁夏';
  return name;
}

class _LocationCard extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final bool showShadow;
  final bool disabled;
  const _LocationCard({required this.child, this.borderColor = AppColors.gray300, this.showShadow = true, this.disabled = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: disabled ? AppColors.gray50 : AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: disabled ? AppColors.gray300 : borderColor, width: 1),
        boxShadow: showShadow ? [
          BoxShadow(
            color: AppColors.gray200.withOpacity(0.5),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: child,
    );
  }
}

class _LocationSwitchItem extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _LocationSwitchItem({required this.title, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyRegular.copyWith(
              color: AppColors.gray700,
              letterSpacing: 0.32,
            ),
          ),
          CustomSwitch(
            value: value,
            onChanged: onChanged,
            trackColor: AppColors.gray200,
          ),
        ],
      ),
    );
  }
}

class _LocationListItem extends StatelessWidget {
  final String province;
  final String city;
  final VoidCallback? onEdit;
  final bool selected;
  final VoidCallback? onTap;
  final bool disabled;
  final bool showEditButton;
  final BorderRadius? borderRadius;
  const _LocationListItem({required this.province, required this.city, this.onEdit, this.selected = false, this.onTap, this.disabled = false, this.showEditButton = true, this.borderRadius});
  @override
  Widget build(BuildContext context) {
    Color textColor = disabled
      ? AppColors.gray300
      : selected
        ? AppColors.black
        : AppColors.gray700;
    Color bgColor = selected ? AppColors.brown200 : Colors.transparent;
    return InkWell(
      borderRadius: borderRadius ?? BorderRadius.zero,
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius ?? BorderRadius.zero,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  if (selected)
                    Container(
                      margin: const EdgeInsets.only(right: AppSpacing.s8),
                      child: AppIcons.check16(color: AppColors.gray700),
                    ),
                  Text(
                    displayProvince(province),
                    style: AppTextStyles.bodyEmphasized.copyWith(
                      color: textColor,
                      letterSpacing: 0.32,
                    ),
                  ),
                  Container(
                    width: 4,
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
                    decoration: BoxDecoration(
                      color: disabled ? AppColors.gray300 : AppColors.gray700,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(
                    '$city',
                    style: AppTextStyles.bodyEmphasized.copyWith(
                      color: textColor,
                      letterSpacing: 0.32,
                    ),
                  ),
                ],
              ),
            ),
            if (showEditButton)
              IconButton(
                icon: AppIcons.edit16(color: disabled ? AppColors.gray300 : AppColors.gray700),
                onPressed: onEdit,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
    );
  }
}

class _AddLocationItem extends StatelessWidget {
  final VoidCallback? onTap;
  final bool disabled;
  const _AddLocationItem({this.onTap, this.disabled = false});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.zero,
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
                  child: Row(
            children: [
              AppIcons.plus16(color: disabled ? AppColors.gray300 : AppColors.gray700),
              SizedBox(width: AppSpacing.s8),
              Text(
                '添加位置',
                style: AppTextStyles.bodyRegular.copyWith(
                  color: disabled ? AppColors.gray300 : AppColors.gray700,
                  letterSpacing: 0.32,
                ),
              ),
            ],
          ),
      ),
    );
  }
}

// 省市选择器组件
class ProvinceCityPicker extends StatefulWidget {
  final Map<String, List<String>> provinceCityMap;
  
  const ProvinceCityPicker({required this.provinceCityMap, super.key});

  @override
  State<ProvinceCityPicker> createState() => _ProvinceCityPickerState();
}

class _ProvinceCityPickerState extends State<ProvinceCityPicker> {
  int provinceIndex = 0;
  int cityIndex = 0;

  String _displayProvince(String name) {
    if (name.startsWith('广西')) return '广西';
    if (name.startsWith('新疆')) return '新疆';
    if (name.startsWith('宁夏')) return '宁夏';
    return name;
  }

  @override
  Widget build(BuildContext context) {
    final provinces = widget.provinceCityMap.keys.where((p) => p != '北京').toList();
    final cities = widget.provinceCityMap[provinces[provinceIndex]]!;

    return SafeArea(
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: AppColors.gray50,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            // 顶部按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('取消', style: AppTextStyles.subheadlinerRegular.copyWith(color: AppColors.gray500)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, [
                      provinces[provinceIndex],
                      cities[cityIndex]
                    ]);
                  },
                  child: Text('完成', style: AppTextStyles.subheadlinerRegular.copyWith(color: AppColors.gray700, fontWeight: FontWeight.w900)),
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  // 省份Picker
                  Expanded(
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 40,
                      onSelectedItemChanged: (i) {
                        setState(() {
                          provinceIndex = i;
                          cityIndex = 0;
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, i) => Center(
                          child: Text(
                            _displayProvince(provinces[i]),
                            style: i == provinceIndex
                                ? AppTextStyles.bodyEmphasized.copyWith(color: AppColors.gray700)
                                : AppTextStyles.bodyRegular.copyWith(color: AppColors.gray500),
                          ),
                        ),
                        childCount: provinces.length,
                      ),
                    ),
                  ),
                  // 城市Picker
                  Expanded(
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 40,
                      onSelectedItemChanged: (i) {
                        setState(() => cityIndex = i);
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, i) => Center(
                          child: Text(
                            cities[i],
                            style: i == cityIndex
                                ? AppTextStyles.bodyEmphasized.copyWith(color: AppColors.gray700)
                                : AppTextStyles.bodyRegular.copyWith(color: AppColors.gray500),
                          ),
                        ),
                        childCount: cities.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
