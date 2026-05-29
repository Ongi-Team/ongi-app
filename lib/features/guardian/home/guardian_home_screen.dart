import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ongi_app/core/constants/constants.dart';
import 'package:provider/provider.dart';

import 'guardian_home_view_model.dart';

class GuardianHomeScreen extends StatelessWidget {
  const GuardianHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GuardianHomeViewModel()..loadMedications(),
      child: const _GuardianHomeView(),
    );
  }
}

class _GuardianHomeView extends StatelessWidget {
  const _GuardianHomeView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GuardianHomeViewModel>();
    // 주황색 포인트 컬러 (사용하시는 브랜드 컬러가 있다면 바꿔주세요)
    const primaryColor = Color(0xFFF27A35);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. 상단 아이콘 및 날짜/타이틀 영역
              SvgPicture.asset(
                'assets/logo.svg',
                height: 28,
              ),
              const SizedBox(height: 16),
              Text(vm.todayText, style: OngiTextStyle.body15),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                      fontSize: 20, color: Colors.black, height: 1.3),
                  children: [
                    TextSpan(
                      text: '${vm.memberName}님',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: '의 일정이에요'),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                vm.greeting,
                style: OngiTextStyle.body15
                    .copyWith(color: OngiColor.systemGray03),
              ),
              const SizedBox(height: 32),

              // 2. 어르신 복용 체크 섹션
              const Text(
                '어르신 복용 체크',
                style: OngiTextStyle.button18,
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200, width: 1.5),
                ),
                child: _buildMedicationSectionContent(vm, primaryColor),
              ),
              const SizedBox(height: 32),

              // 3. 디바이스 연결 체크 섹션
              const Text(
                '디바이스 연결 체크',
                style: OngiTextStyle.button18,
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200, width: 1.5),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: vm.deviceStatuses
                      .map((item) => _buildDeviceStatusTile(
                            item.title,
                            isNormal: item.isNormal,
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- 위젯을 간결하게 유지하기 위한 컴포넌트 팩토리 메서드들 ---

  Widget _buildMedicationSectionContent(
    GuardianHomeViewModel vm,
    Color primaryColor,
  ) {
    if (vm.isMedicationLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text('복약 기록을 불러오는 중이에요', style: OngiTextStyle.body15),
        ),
      );
    }

    if (vm.medicationErrorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Center(
          child: Text(
            vm.medicationErrorMessage!,
            style: OngiTextStyle.body15.copyWith(
              color: OngiColor.systemGray03,
            ),
          ),
        ),
      );
    }

    if (vm.medications.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            '오늘 등록된 복약 기록이 없어요',
            style: OngiTextStyle.body15.copyWith(
              color: OngiColor.systemGray03,
            ),
          ),
        ),
      );
    }

    return Column(
      children: _buildSeparatedMedicationTiles(
        vm.medications,
        primaryColor,
      ),
    );
  }

  List<Widget> _buildSeparatedMedicationTiles(
    List<MedicationItem> items,
    Color primaryColor,
  ) {
    return [
      for (var i = 0; i < items.length; i++) ...[
        _buildMedicationTile(
          items[i].title,
          items[i].time,
          isChecked: items[i].isChecked,
          color: primaryColor,
        ),
        if (i < items.length - 1) _buildDivider(),
      ],
    ];
  }

  // 복약 체크 리스트 스타일 빌더
  Widget _buildMedicationTile(String title, String time,
      {required bool isChecked, required Color color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isChecked ? color : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(6),
            ),
            child: isChecked
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
          const SizedBox(width: 16),
          Text(title, style: OngiTextStyle.button18),
          const Spacer(),
          Text(
            time,
            style: OngiTextStyle.button18.copyWith(
                color: isChecked ? Colors.black : Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  // 디바이스 상태 리스트 스타일 빌더
  Widget _buildDeviceStatusTile(String title, {required bool isNormal}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50), // 초록색 체크 배경
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 16),
          Text(title, style: OngiTextStyle.button18),
        ],
      ),
    );
  }

  // 구분선 생성기 (리스트 아이템 사이 여백조절)
  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade100,
      indent: 16,
      endIndent: 16,
    );
  }
}
