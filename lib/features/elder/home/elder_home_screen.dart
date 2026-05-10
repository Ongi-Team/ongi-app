import 'package:flutter/material.dart';
import 'package:ongi_app/core/constants/constants.dart';

class ElderHomeScreen extends StatelessWidget {
  const ElderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text('홈', style: OngiTextStyle.body15),
            ],
          ),
        ),
      ),
    );
  }
}
