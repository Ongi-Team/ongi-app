import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ongi_app/core/constants/constants.dart';
import 'package:ongi_app/core/constants/styles.dart';

class GuardianHomeScreen extends StatelessWidget {
  const GuardianHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 주황색 포인트 컬러 (사용하시는 브랜드 컬러가 있다면 바꿔주세요)
    const primaryColor = Color(0xFFF27A35);
    final todayText = _formatToday(DateTime.now());

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
              Text(todayText, style: OngiTextStyle.body15),
              const SizedBox(height: 4),
              RichText(
                text: const TextSpan(
                  style:
                      TextStyle(fontSize: 20, color: Colors.black, height: 1.3),
                  children: [
                    TextSpan(
                      text: '홍길동님',
                      style: OngiTextStyle.subTitle,
                    ),
                    TextSpan(text: '의 일정이에요'),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '오늘도 따뜻한 하루 보내세요',
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
                child: Column(
                  children: [
                    _buildMedicationTile('감기약', '08:30',
                        isChecked: false, color: primaryColor),
                    _buildDivider(),
                    _buildMedicationTile('혈압약', '12:00',
                        isChecked: true, color: primaryColor),
                    _buildDivider(),
                    _buildMedicationTile('비타민', '17:00',
                        isChecked: true, color: primaryColor),
                    _buildDivider(),
                    _buildMedicationTile('감기약', '17:00',
                        isChecked: false, color: primaryColor),
                  ],
                ),
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
                  children: [
                    _buildDeviceStatusTile('디바이스 정상 작동', isNormal: true),
                    _buildDeviceStatusTile('네트워크 정상 연결', isNormal: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- 위젯을 간결하게 유지하기 위한 컴포넌트 팩토리 메서드들 ---

  String _formatToday(DateTime date) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final weekday = weekdays[date.weekday - 1];

    return '$year. $month. $day($weekday)';
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
