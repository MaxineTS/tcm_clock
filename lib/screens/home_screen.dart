import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/clock_dial.dart';
import 'meridian_details_screen.dart';
import 'settings_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';
import '../services/shichen_repository.dart';
import '../models/shichen_data.dart';
import '../models/app_settings.dart';
import '../widgets/app_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<ShichenData>> _shichenFuture;
  final ShichenRepository _repo = ShichenRepository();

  DateTime _now = DateTime.now();

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _shichenFuture = _repo.loadAll();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        final appSettings = Provider.of<AppSettings>(context, listen: false);
        final now = DateTime.now();
        _now = appSettings.useSolarTime
            ? now.add(Duration(minutes: appSettings.solarOffsetMinutes))
            : now;
      });
    });
  }

  String keToChinese(int ke) {
    const chinese = ['一', '二', '三', '四', '五', '六', '七', '八'];
    return (ke >= 1 && ke <= 8) ? chinese[ke - 1] : ke.toString();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ShichenData>>(
      future: _shichenFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final shichenList = snapshot.data!;
        final currentShichen = _repo.findCurrentShichen(_now, shichenList);
        final ke = currentShichen != null ? _repo.getKeInShichen(_now, currentShichen) : null;
        final shichenProgress = currentShichen != null ? _repo.getShichenProgress(_now, currentShichen) : null;

        return Scaffold(
          backgroundColor: AppColors.gray50,
          appBar: AppBar(
            // title: const Text('子午流注时辰钟', style: AppTextStyles.title2Emphasized),
            backgroundColor: AppColors.gray50,
            foregroundColor: AppColors.black,
            elevation: 0,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: AppSpacing.s8),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.s8),
                      child: AppIcons.settings24(color: AppColors.gray700),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.s16, left: AppSpacing.s16, right: AppSpacing.s16),
            child: Column(
              children: [
                // 时间信息区
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s16),
                  child: Column(
                    children: [
                      Text(
                        '${currentShichen?.timeTitle ?? ''}时${keToChinese(ke ?? 1)}刻',
                        style: AppTextStyles.title1Emphasized.copyWith(color: AppColors.black),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacing.s8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentShichen?.meridian.name ?? '',
                            style: AppTextStyles.bodyRegular.copyWith(color: AppColors.gray700),
                          ),
                          const SizedBox(width: AppSpacing.s12),
                          Container(
                            width: 1,
                            height: 16,
                            color: AppColors.gray200,
                            margin: const EdgeInsets.symmetric(horizontal: 0),
                          ),
                          const SizedBox(width: AppSpacing.s12),
                          Text(
                            currentShichen?.suggestion ?? '',
                            style: AppTextStyles.bodyRegular.copyWith(color: AppColors.gray700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // 表盘区域
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s24),
                  child: Center(
                    child: ClockDial(
                      size: 280,
                      now: _now,
                      shichen: currentShichen,
                      ke: ke,
                      shichenProgress: shichenProgress,
                    ),
                  ),
                ),
                // 自动撑开剩余空间
                const Spacer(),
                // 经脉信息卡片
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s80),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MeridianDetailsScreen(
                            data: MeridianDetailData(
                              meridianNameFull: currentShichen?.meridian.fullName ?? '',
                              meridianFunction: currentShichen?.meridian.function ?? '',
                              functionText: currentShichen?.functionText ?? '',
                              riskText: currentShichen?.riskText ?? '',
                              reference1: currentShichen?.references.isNotEmpty == true ? currentShichen!.references[0].source : '',
                              referenceContent1: currentShichen?.references.isNotEmpty == true ? currentShichen!.references[0].content : '',
                              referenceTranslation1: currentShichen?.references.isNotEmpty == true ? currentShichen!.references[0].translation : '',
                              reference2: currentShichen?.references.length == 2 ? currentShichen!.references[1].source : '',
                              referenceContent2: currentShichen?.references.length == 2 ? currentShichen!.references[1].content : '',
                              referenceTranslation2: currentShichen?.references.length == 2 ? currentShichen!.references[1].translation : '',
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.s16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppRadius.large),
                        border: Border.all(width: 2, color: AppColors.gray100),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gray200.withOpacity(0.5),
                            offset: const Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start, // 关键：顶部对齐
                        children: [
                          // 图标区
                          Container(
                            width: AppSpacing.s48,
                            height: AppSpacing.s48,
                            decoration: BoxDecoration(
                              color: AppColors.brown500,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: AppIcons.meridianIcon(
                                currentShichen?.meridian.name ?? '',
                                color: AppColors.white,
                                size: 32,
                              ),
                            ),
                          ),
                          SizedBox(width: AppSpacing.s16),
                          // 信息区
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // meridian&function
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(currentShichen?.meridianNameFull ?? '', style: AppTextStyles.title3Emphasized.copyWith(color: AppColors.black)),
                                    SizedBox(height: AppSpacing.s4),
                                    Text(currentShichen?.meridian.function ?? '', style: AppTextStyles.bodyRegular.copyWith(color: AppColors.gray700)),
                                  ],
                                ),
                                SizedBox(height: AppSpacing.s4),
                                // 描述区
                                Text(
                                  currentShichen?.meridian.description ?? '',
                                  style: AppTextStyles.bodyRegular.copyWith(color: AppColors.gray700),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: AppSpacing.s16),
                          // 更多按钮
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Text('更多', style: AppTextStyles.subheadlinerRegular.copyWith(color: AppColors.gray700)),
                                  AppIcons.chevronRight16(color: AppColors.gray700),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
