import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';
import '../widgets/app_icons.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  void _showPolicySheet(BuildContext context, int tabIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.large)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.s24,
            right: AppSpacing.s24,
            top: AppSpacing.s24,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.s24,
          ),
          child: SizedBox(
            height: 360,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: AppSpacing.s16),
                      decoration: BoxDecoration(
                        color: AppColors.gray200,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Future.delayed(const Duration(milliseconds: 200), () {
                          _showPolicySheet(context, 0);
                        });
                      },
                      child: Text(
                        '隐私政策',
                        style: AppTextStyles.bodyEmphasized.copyWith(
                          color: tabIndex == 0 ? AppColors.brown700 : AppColors.gray600,
                          fontSize: 16,
                          decoration: tabIndex == 0 ? TextDecoration.underline : null,
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 16,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      color: AppColors.gray200,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Future.delayed(const Duration(milliseconds: 200), () {
                          _showPolicySheet(context, 1);
                        });
                      },
                      child: Text(
                        '服务条款',
                        style: AppTextStyles.bodyEmphasized.copyWith(
                          color: tabIndex == 1 ? AppColors.brown700 : AppColors.gray600,
                          fontSize: 16,
                          decoration: tabIndex == 1 ? TextDecoration.underline : null,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      tabIndex == 0
                          ? '本应用尊重并保护您的隐私。我们不会收集、存储或上传您的任何个人身份信息。\n\n仅在您授权的情况下，应用会使用您的位置信息，用于推算本地时辰与经脉，仅在本地处理，不会上传至服务器。\n\n您的所有数据仅保存在您的设备本地。我们不会与任何第三方共享您的信息。\n\n如有疑问，请通过设置页中的联系方式与我们取得联系。'
                          : '本应用旨在为用户提供中国传统时辰与经脉相关的健康参考信息，不构成任何医疗建议。\n\n用户应根据自身情况合理使用本应用，如有健康问题请咨询专业医生。\n\n使用本应用即表示您同意本条款。我们有权根据需要对条款内容进行调整，调整后的内容将在应用内公示。\n\n如有疑问，请通过设置页中的联系方式与我们取得联系。',
                      style: AppTextStyles.bodyRegular.copyWith(color: AppColors.gray800, fontSize: 16, height: 1.5),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部栏
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.s24, left: AppSpacing.s16, right: AppSpacing.s16),
              child: Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.s8),
                        child: Transform.rotate(
                          angle: 3.1416, // 180度
                          child: AppIcons.chevronRight16(color: AppColors.gray700),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  Text(
                    '关于',
                    style: AppTextStyles.title2Emphasized.copyWith(
                      color: AppColors.gray700,
                      letterSpacing: 2.4,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 作者介绍
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '来自作者：',
                        style: AppTextStyles.subheadlineEmphasized.copyWith(
                          color: Color(0xFF607A64),
                          fontSize: 14,
                          letterSpacing: 0.28,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    Text(
                      '你好，我是 Maxine，一位热爱中医文化与数字工具的独立开发者。\n\n希望这个小工具能帮助你在日常生活中更好地体会“天人合一”的智慧。',
                      style: AppTextStyles.bodyRegular.copyWith(
                        color: AppColors.gray700,
                        fontSize: 16,
                        height: 1.5,
                        letterSpacing: 0.32,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    // 下方 block 贴底
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '知时 · 十二时辰经脉助手',
                            style: AppTextStyles.bodyEmphasized.copyWith(
                              color: AppColors.black,
                              fontSize: 16,
                              letterSpacing: 0.32,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.s8),
                          Text(
                            '版本号：v1.0.0',
                            style: AppTextStyles.subheadlinerRegular.copyWith(
                              color: AppColors.gray600,
                              fontSize: 14,
                              letterSpacing: 0.28,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.s40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => _showPolicySheet(context, 0),
                                child: Text(
                                  '隐私政策',
                                  style: AppTextStyles.subheadlinerRegular.copyWith(
                                    color: Color(0xFFae8561),
                                    fontSize: 14,
                                    letterSpacing: 0.28,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 12,
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: AppColors.gray200,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _showPolicySheet(context, 1),
                                child: Text(
                                  '服务条款',
                                  style: AppTextStyles.subheadlinerRegular.copyWith(
                                    color: Color(0xFFae8561),
                                    fontSize: 14,
                                    letterSpacing: 0.28,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.s48),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 