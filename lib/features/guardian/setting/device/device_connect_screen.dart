import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:ongi_app/core/constants/constants.dart';
import 'package:ongi_app/core/router/routes.dart';
import 'package:ongi_app/features/guardian/setting/device/device_connect_view_model.dart';
import 'package:ongi_app/shared/widgets/basic_app_bar.dart';
import 'package:ongi_app/shared/widgets/basic_button.dart';
import 'package:ongi_app/shared/widgets/basic_text_field.dart';
import 'package:provider/provider.dart';

class DeviceQrScanScreen extends StatefulWidget {
  const DeviceQrScanScreen({super.key});

  @override
  State<DeviceQrScanScreen> createState() => _DeviceQrScanScreenState();
}

class _DeviceQrScanScreenState extends State<DeviceQrScanScreen> {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [BarcodeFormat.qrCode],
  );

  bool _isNavigating = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _safeStopScanner() async {
    try {
      await _scannerController.stop();
    } on MissingPluginException catch (error) {
      debugPrint('MobileScanner plugin is not registered: $error');
    }
  }

  Future<void> _safeStartScanner() async {
    try {
      await _scannerController.start();
    } on MissingPluginException catch (error) {
      debugPrint('MobileScanner plugin is not registered: $error');
    }
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isNavigating) return;

    String? deviceCode;
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;
      if (value != null && value.trim().isNotEmpty) {
        deviceCode = value.trim();
        break;
      }
    }

    if (deviceCode == null) return;

    _isNavigating = true;
    await _safeStopScanner();

    if (!mounted) return;
    await context.push(
      '${AppRoutes.guardianDeviceWifi}?deviceCode=${Uri.encodeComponent(deviceCode)}',
    );

    if (!mounted) return;
    _isNavigating = false;
    await _safeStartScanner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OngiColor.white50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BasicAppBar(
                title: '디바이스 연결',
                subtitle: '디바이스의 QR 코드를 스캔해주세요',
                onBackButtonPressed: () => context.pop(),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: MobileScanner(
                              controller: _scannerController,
                              onDetect: _onDetect,
                              errorBuilder: (_, error) {
                                return _ScannerMessage(
                                  icon: Icons.videocam_off_rounded,
                                  message: error.errorDetails?.message ??
                                      error.errorCode.message,
                                );
                              },
                              placeholderBuilder: (_) {
                                return const _ScannerMessage(
                                  icon: Icons.qr_code_scanner_rounded,
                                  message: '카메라를 준비하고 있습니다.',
                                );
                              },
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withValues(alpha: 0.08),
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: OngiColor.white50.withValues(
                                        alpha: 0.5,
                                      ),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'QR 코드를 화면 중앙에 맞춰주세요',
                                  textAlign: TextAlign.center,
                                  style: OngiTextStyle.body15.copyWith(
                                    color: OngiColor.white50,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class DeviceWifiInputScreen extends StatelessWidget {
  const DeviceWifiInputScreen({
    super.key,
    this.deviceCode,
  });

  final String? deviceCode;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DeviceConnectViewModel(),
      child: _DeviceWifiInputView(deviceCode: deviceCode),
    );
  }
}

class _DeviceWifiInputView extends StatelessWidget {
  const _DeviceWifiInputView({
    required this.deviceCode,
  });

  final String? deviceCode;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DeviceConnectViewModel>();

    return Scaffold(
      backgroundColor: OngiColor.white50,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        onVerticalDragEnd: (details) {
          if ((details.primaryVelocity ?? 0) > 0) {
            FocusScope.of(context).unfocus();
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BasicAppBar(
                        title: 'Wi-Fi 정보 입력',
                        subtitle: '디바이스가 사용할 Wi-Fi 정보를 입력해주세요',
                        onBackButtonPressed: () => context.pop(),
                      ),
                      const SizedBox(height: 24),
                      if (deviceCode != null) ...[
                        Text(
                          '인식된 디바이스',
                          style: OngiTextStyle.body15.copyWith(
                            color: OngiColor.systemGray03,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Ongi-device",
                          style: OngiTextStyle.button18,
                        ),
                        const SizedBox(height: 24),
                      ],
                      BasicTextField(
                        label: 'Wi-Fi 이름',
                        hintText: 'Wi-Fi 이름을 입력해주세요.',
                        controller: viewModel.ssidController,
                        keyboardType: TextInputType.text,
                        onChanged: (_) => viewModel.onInputChanged(),
                      ),
                      const SizedBox(height: 16),
                      BasicTextField(
                        label: 'Wi-Fi 비밀번호',
                        hintText: 'Wi-Fi 비밀번호를 입력해주세요.',
                        controller: viewModel.passwordController,
                        obscureText: true,
                        onChanged: (_) => viewModel.onInputChanged(),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: BasicButton(
                  text: viewModel.isConnecting ? '연결 중' : '연결하기',
                  isClickable: viewModel.canConnect,
                  onPressed: viewModel.canConnect
                      ? () async {
                          await viewModel.connectDevice();
                          if (!context.mounted) return;
                          context.go(AppRoutes.guardianDeviceSuccess);
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeviceConnectSuccessScreen extends StatelessWidget {
  const DeviceConnectSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OngiColor.white50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  color: OngiColor.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: OngiColor.white50,
                  size: 56,
                ),
              ),
              const SizedBox(height: 24),
              const Text('디바이스 연결 성공', style: OngiTextStyle.subTitle),
              const SizedBox(height: 8),
              Text(
                '디바이스 연결이 완료되었습니다.',
                style: OngiTextStyle.body15.copyWith(
                  color: OngiColor.systemGray03,
                ),
              ),
              const Spacer(),
              BasicButton(
                text: '설정으로 돌아가기',
                isClickable: true,
                onPressed: () => context.go(AppRoutes.guardianSettings),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScannerMessage extends StatelessWidget {
  const _ScannerMessage({
    required this.icon,
    required this.message,
  });

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: OngiColor.white50,
              size: 48,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: OngiTextStyle.body15.copyWith(
                  color: OngiColor.white50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
