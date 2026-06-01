import 'package:flutter/material.dart';
import 'package:ongi_app/core/constants/styles.dart';
import 'package:ongi_app/features/guardian/nav/guardian_tab_refresh_notifier.dart';
import 'package:ongi_app/features/guardian/schedule/schedule_view_model.dart';
import 'package:ongi_app/shared/widgets/basic_button.dart';
import 'package:ongi_app/shared/widgets/basic_text_field.dart';
import 'package:ongi_app/shared/widgets/custom_header.dart';

class GuardianScheduleScreen extends StatefulWidget {
  const GuardianScheduleScreen({super.key});

  @override
  State<GuardianScheduleScreen> createState() => _GuardianScheduleScreenState();
}

class _GuardianScheduleScreenState extends State<GuardianScheduleScreen> {
  // 뷰모델 생성
  final ScheduleViewModel _viewModel = ScheduleViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.loadInitialData();
    GuardianTabRefreshNotifier.scheduleSignal.addListener(_refreshSchedule);
  }

  @override
  void dispose() {
    GuardianTabRefreshNotifier.scheduleSignal.removeListener(_refreshSchedule);
    _viewModel.dispose();
    super.dispose();
  }

  void _refreshSchedule() {
    _viewModel.loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFF27A35);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // 1. 상단 타이틀 영역
                  CustomHeader(
                    dateText: _viewModel.todayText,
                    name: _viewModel.memberName,
                    greeting: _viewModel.greeting,
                  ),
                  const SizedBox(height: 32),

                  // 2. '약' 타이틀 및 '추가하기' 버튼 영역
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '약',
                        style: OngiTextStyle.subTitle
                            .copyWith(color: primaryColor),
                      ),
                      GestureDetector(
                        onTap: _showAddMedicationDialog,
                        child: Row(
                          children: [
                            Text(
                              '추가하기',
                              style: OngiTextStyle.subTitle
                                  .copyWith(color: primaryColor),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.add_circle,
                                color: primaryColor, size: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 3. 약 목록 리스트 영역
                  Expanded(
                    child: _buildMedicationListContent(primaryColor),
                  ),

                  // 4. 하단 '약통 열기' 버튼
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: BasicButton(
                      text: '약통 열기',
                      isClickable: true,
                      onPressed: () => _viewModel.openPillBox(),
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

  Widget _buildMedicationListContent(Color primaryColor) {
    if (_viewModel.isMedicationLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.medicationErrorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _viewModel.medicationErrorMessage!,
              style: OngiTextStyle.body15,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _viewModel.loadMedications,
              child: Text(
                '다시 불러오기',
                style: OngiTextStyle.body15.copyWith(color: primaryColor),
              ),
            ),
          ],
        ),
      );
    }

    if (_viewModel.medications.isEmpty) {
      return const Center(child: Text('등록된 약 일정이 없습니다.'));
    }

    return ListView.separated(
      itemCount: _viewModel.medications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final medication = _viewModel.medications[index];
        return _buildMedicationCard(
          index: index + 1,
          medication: medication,
          onDelete: () => _showDeleteMedicationDialog(medication),
        );
      },
    );
  }

  Future<void> _showDeleteMedicationDialog(MedicationModel medication) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('약 삭제', style: OngiTextStyle.button18),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                medication.name,
                style: OngiTextStyle.button18,
              ),
              const SizedBox(height: 6),
              Text(
                '복용 시간 ${medication.time}',
                style: OngiTextStyle.body15.copyWith(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '진짜로 삭제하겠습니까?',
                style: OngiTextStyle.body15,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(
                '삭제',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;
    _viewModel.removeMedication(medication.id);
  }

  Future<void> _showAddMedicationDialog() async {
    final medication = await showDialog<_MedicationInput>(
      context: context,
      builder: (_) => const _AddMedicationDialog(),
    );

    if (medication == null) return;
    _viewModel.addMedication(medication.name, medication.time);
  }

  // 약 리스트의 단일 아이템 카드 빌더
  Widget _buildMedicationCard({
    required int index,
    required MedicationModel medication,
    required VoidCallback onDelete,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // 번호 (예: 1.)
          Text(
            '$index.',
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(width: 16),
          // 약 이름
          Text(
            medication.name,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const Spacer(),
          // 시간
          Text(
            medication.time,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(width: 24),
          // 삭제 버튼
          GestureDetector(
            onTap: onDelete,
            child: const Text(
              '삭제',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddMedicationDialog extends StatefulWidget {
  const _AddMedicationDialog();

  @override
  State<_AddMedicationDialog> createState() => _AddMedicationDialogState();
}

class _AddMedicationDialogState extends State<_AddMedicationDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  bool get _canAdd =>
      _nameController.text.trim().isNotEmpty &&
      _timeController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _nameController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 360,
              maxHeight: 420,
            ),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('약 추가하기', style: OngiTextStyle.button18),
                    const SizedBox(height: 20),
                    BasicTextField(
                      label: '약 이름',
                      hintText: '약 이름을 입력해주세요.',
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    BasicTextField(
                      label: '복용 시간',
                      hintText: '예: 09:00',
                      controller: _timeController,
                      keyboardType: TextInputType.datetime,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 24),
                    BasicButton(
                      text: '추가하기',
                      isClickable: _canAdd,
                      onPressed: _canAdd
                          ? () {
                              Navigator.of(context).pop(
                                _MedicationInput(
                                  name: _nameController.text.trim(),
                                  time: _timeController.text.trim(),
                                ),
                              );
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MedicationInput {
  const _MedicationInput({
    required this.name,
    required this.time,
  });

  final String name;
  final String time;
}
