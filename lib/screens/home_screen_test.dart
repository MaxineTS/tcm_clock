import 'package:flutter/material.dart';
import '../models/shichen.dart'; // 只导入数据模型
import '../utils/data_loader.dart'; // 只在这里导入 loadShichenData

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(title: const Text('时辰数据测试')),
      body: Padding(
        padding: const EdgeInsets.only(top: 0, left: AppSpacing.s16, right: AppSpacing.s16),
        child: FutureBuilder<List<Shichen>>(
          future: loadShichenData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('加载失败: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('没有数据'));
            } else {
              final data = snapshot.data!;
              // 只展示前几条数据
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final shichen = data[index];
                  return ListTile(
                    title: Text('${shichen.timeTitle}（${shichen.hours}）'),
                    subtitle: Text('经脉：${shichen.meridian.name}，建议：${shichen.suggestion}'),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
