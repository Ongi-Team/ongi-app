import 'package:flutter/material.dart';
import 'package:ongi_app/features/elder/home/elder_home_refresh_notifier.dart';
import 'package:ongi_app/features/elder/home/elder_view_model.dart';
import 'package:ongi_app/shared/widgets/custom_header.dart';

class ElderHomeScreen extends StatefulWidget {
  const ElderHomeScreen({super.key});

  @override
  State<ElderHomeScreen> createState() => _ElderHomeScreenState();
}

class _ElderHomeScreenState extends State<ElderHomeScreen> {
  final ElderViewModel viewModel = ElderViewModel();

  @override
  void initState() {
    super.initState();
    _refreshHome();
    ElderHomeRefreshNotifier.signal.addListener(_refreshHome);
  }

  @override
  void dispose() {
    ElderHomeRefreshNotifier.signal.removeListener(_refreshHome);
    viewModel.dispose();
    super.dispose();
  }

  void _refreshHome() {
    viewModel.loadHeaderData();
    viewModel.loadMedicineSchedules();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFF27A35);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            final isActive =
                viewModel.status == MedicationReminderStatus.active;
            final isLoading = viewModel.isScheduleLoading;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  CustomHeader(
                    dateText: viewModel.todayText,
                    name: viewModel.memberName,
                    greeting: viewModel.greeting,
                  ),
                  const SizedBox(height: 40),

                  // --- 복약 알림 위젯 (이미지 핵심 UI) ---
                  Center(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 40, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isActive ? primaryColor : Colors.grey.shade300,
                          width: 2.5, // 강조된 테두리 두께
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isLoading ? '불러오는 중' : viewModel.medicineName,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: isActive
                                  ? primaryColor
                                  : Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            viewModel.scheduleErrorMessage ??
                                (viewModel.currentSchedule == null
                                    ? '복용할 약이 없어요'
                                    : viewModel.reminderMessage),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isActive
                                  ? primaryColor
                                  : Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            viewModel.scheduledTimeText,
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: isActive
                                  ? primaryColor
                                  : Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(height: 32),
                          // '알겠어요' 버튼
                          SizedBox(
                            width: 200,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: isActive
                                  ? () => viewModel.confirmMedication()
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                disabledBackgroundColor: Colors.grey.shade300,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                              child: const Text(
                                '알겠어요',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
