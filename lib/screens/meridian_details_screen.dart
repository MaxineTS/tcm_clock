import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';
import '../widgets/app_icons.dart';

// Add the data model
class MeridianDetailData {
  final String? meridianNameFull;
  final String? meridianFunction;
  final String? functionText;
  final String? riskText;
  final String? reference1;
  final String? referenceContent1;
  final String? referenceTranslation1;
  final String? reference2;
  final String? referenceContent2;
  final String? referenceTranslation2;

  MeridianDetailData({
    this.meridianNameFull,
    this.meridianFunction,
    this.functionText,
    this.riskText,
    this.reference1,
    this.referenceContent1,
    this.referenceTranslation1,
    this.reference2,
    this.referenceContent2,
    this.referenceTranslation2,
  });
}

class MeridianDetailsScreen extends StatefulWidget {
  final MeridianDetailData data;
  const MeridianDetailsScreen({super.key, required this.data});

  @override
  State<MeridianDetailsScreen> createState() => _MeridianDetailsScreenState();
}

class _MeridianDetailsScreenState extends State<MeridianDetailsScreen> {
  int _tabIndex = 0;
  final List<String> _tabs = ['简介', '黄帝内经'];

  @override
  Widget build(BuildContext context) {
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
                      widget.data.meridianNameFull ?? '',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTabBar(
                      selectedIndex: _tabIndex,
                      tabs: _tabs,
                      onTap: (i) => setState(() => _tabIndex = i),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: IndexedStack(
                        index: _tabIndex,
                        children: [
                          // 简介 tab
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 主要功能卡片
                                if (widget.data.meridianFunction != null) ...[
                                  Container(
                                    width: 80,
                                    height: 32,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.turquoise100,
                                      borderRadius: BorderRadius.circular(AppRadius.medium),
                                    ),
                                    child: Text(
                                      '主要功能',
                                      style: AppTextStyles.subheadlineEmphasized.copyWith(color: AppColors.turquoise700),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: AppSpacing.s8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.data.meridianFunction!, style: AppTextStyles.bodyRegular.copyWith(color: AppColors.gray700)),
                                        if (widget.data.functionText != null) ...[
                                          SizedBox(height: AppSpacing.s8),
                                          Text(widget.data.functionText!, style: AppTextStyles.bodyRegular.copyWith(color: AppColors.gray700)),
                                        ],
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: AppSpacing.s48),
                                ],
                                // 危害卡片
                                if (widget.data.riskText != null) ...[
                                  Container(
                                    width: 80,
                                    height: 32,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.burgandy100,
                                      borderRadius: BorderRadius.circular(AppRadius.medium),
                                    ),
                                    child: Text(
                                      '危害',
                                      style: AppTextStyles.subheadlineEmphasized.copyWith(color: AppColors.burgandy700),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: AppSpacing.s8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
                                    child: Text(widget.data.riskText!, style: AppTextStyles.bodyRegular.copyWith(color: AppColors.gray700)),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          // 黄帝内经 tab
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (widget.data.reference1 != null) ...[
                                  _ReferenceCard(
                                    title: widget.data.reference1!,
                                    quote: widget.data.referenceContent1 ?? '',
                                    translation: widget.data.referenceTranslation1 ?? '',
                                  ),
                                  SizedBox(height: AppSpacing.s48),
                                ],
                                if (widget.data.reference2 != null) ...[
                                  _ReferenceCard(
                                    title: widget.data.reference2!,
                                    quote: widget.data.referenceContent2 ?? '',
                                    translation: widget.data.referenceTranslation2 ?? '',
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
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

class CustomTabBar extends StatelessWidget {
  final int selectedIndex;
  final List<String> tabs;
  final ValueChanged<int> onTap;
  const CustomTabBar({
    required this.selectedIndex,
    required this.tabs,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isSelected = i == selectedIndex;
          return Row(
            children: [
              GestureDetector(
                onTap: () => onTap(i),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: i == 0 ? 56 : 80, // 简介tab宽度为56，黄帝内经tab宽度为80
                  height: 24,
                  margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.brown400 : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    tabs[i],
                    style: isSelected
                        ? AppTextStyles.subheadlineEmphasized.copyWith(color: Colors.white)
                        : AppTextStyles.subheadlinerRegular.copyWith(color: AppColors.gray800),
                  ),
                ),
              ),
              // Add gap between tabs
              if (i < tabs.length - 1) SizedBox(width: AppSpacing.s24),
            ],
          );
        }),
      ),
    );
  }
}

class _ReferenceCard extends StatelessWidget {
  final String title;
  final String quote;
  final String translation;
  const _ReferenceCard({
    required this.title,
    required this.quote,
    required this.translation,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s8),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.subheadlinerRegular.copyWith(color: AppColors.green600)),
          SizedBox(height: AppSpacing.s16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(quote, style: AppTextStyles.bodyEmphasized.copyWith(color: AppColors.gray800)),
                SizedBox(height: AppSpacing.s16),
                Text(translation, style: AppTextStyles.subheadlinerRegular.copyWith(color: AppColors.gray600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
