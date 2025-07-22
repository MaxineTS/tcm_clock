import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.gray50,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.gray700),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('隐私政策 & 服务条款', style: AppTextStyles.title2Emphasized.copyWith(color: AppColors.gray700)),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('隐私政策', style: AppTextStyles.title3Emphasized.copyWith(color: AppColors.brown700)),
              const SizedBox(height: AppSpacing.s16),
              Text(
                '我们非常重视您的隐私。应用仅在必要时收集您的位置信息，用于时辰与经脉推算。所有数据仅保存在本地，不会上传至服务器。详情请参阅完整隐私政策。',
                style: AppTextStyles.bodyRegular.copyWith(color: AppColors.gray800),
              ),
              const SizedBox(height: AppSpacing.s32),
              Text('服务条款', style: AppTextStyles.title3Emphasized.copyWith(color: AppColors.brown700)),
              const SizedBox(height: AppSpacing.s16),
              Text(
                '本应用仅供健康参考，不构成医疗建议。请根据自身情况合理使用，如有健康问题请咨询专业医生。详情请参阅完整服务条款。',
                style: AppTextStyles.bodyRegular.copyWith(color: AppColors.gray800),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 