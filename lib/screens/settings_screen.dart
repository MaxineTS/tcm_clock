import 'package:flutter/material.dart';
import 'my_location_screen.dart';
import '../widgets/custom_switch.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_radius.dart';
import '../models/city_info.dart';
import '../data/province_city.dart';
import 'package:provider/provider.dart';
import '../models/app_settings.dart';
import '../widgets/app_icons.dart';
import 'about_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);
    // 仅首次进入（无历史选择）时自动重置为北京
    if ((appSettings.currentProvince.isEmpty || appSettings.currentCity.isEmpty) &&
        (appSettings.currentProvince == '' && appSettings.currentCity == '')) {
      appSettings.updateLocation('北京', '北京', 0);
    }
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
                padding: const EdgeInsets.only(top: AppSpacing.s32, bottom: AppSpacing.s24),
                child: Row(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.s8),
                          child: AppIcons.chevronLeft24(color: AppColors.gray700),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.s8),
                    Text(
                      '设置',
                      style: AppTextStyles.title2Emphasized.copyWith(
                        color: AppColors.gray700,
                        letterSpacing: 2.4,
                      ),
                    ),
                  ],
                ),
              ),
              // 内容区
              Expanded(
                child: ListView(
                  children: [
                    // 第一组卡片
                    _SettingsCard(
                      children: [
                        _SettingsItem(
                          title: '我的位置',
                          detail: null,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyLocationScreen(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                appSettings.currentProvince.isNotEmpty ? displayProvince(appSettings.currentProvince) : '北京',
                                style: AppTextStyles.bodyEmphasized.copyWith(color: AppColors.gray800, letterSpacing: 0.32),
                              ),
                              Container(
                                width: 4,
                                height: 4,
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.gray700,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Text(
                                appSettings.currentCity.isNotEmpty ? appSettings.currentCity : '北京',
                                style: AppTextStyles.bodyEmphasized.copyWith(color: AppColors.gray800, letterSpacing: 0.32),
                              ),
                              SizedBox(width: AppSpacing.s4),
                              AppIcons.chevronRight16(color: AppColors.gray700),
                            ],
                          ),
                        ),
                        // Divider between items
                        // Container(
                        //   height: 0.5,
                        //   color: AppColors.gray200,
                        // ),
                        _SettingsSwitchItem(
                          title: '真太阳时',
                          value: appSettings.useSolarTime,
                          onChanged: (v) {
                            appSettings.updateSolarTime(v);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.s40),
                    // 第二组卡片
                    /*
                    _SettingsCard(
                      children: [
                        _SettingsItem(
                          title: '小组件',
                          onTap: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.s40),
                    */
                    // 第三组卡片
                    _SettingsCard(
                      children: [
                        _SettingsItem(
                          title: '关于',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AboutScreen(),
                              ),
                            );
                          },
                          child: AppIcons.chevronRight16(color: AppColors.gray700),
                        ),
                      ],
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

  // 解析 displayLocation 字符串，查找 CityInfo
  Future<CityInfo?> findCityInfoFromDisplay(String display) async {
    final parts = display.split(' ');
    if (parts.length == 2) {
      return await findCityInfo(parts[0], parts[1]);
    }
    return null;
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.gray100, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray200.withOpacity(0.5),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final String title;
  final String? detail;
  final Widget? child;
  final VoidCallback? onTap;
  final bool isSelected;
  const _SettingsItem({required this.title, this.detail, this.child, this.onTap, this.isSelected = false});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.zero,
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        color: isSelected ? AppColors.brown200 : Colors.transparent,
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
            if (child != null)
              child!
            else if (detail != null)
              Text(
                detail!,
                style: AppTextStyles.bodyEmphasized.copyWith(
                  color: AppColors.gray800,
                  letterSpacing: 0.32,
                ),
              ),
            // 右侧箭头等可继续保留
          ],
        ),
      ),
    );
  }
}

class _SettingsSwitchItem extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SettingsSwitchItem({required this.title, required this.value, required this.onChanged});
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
