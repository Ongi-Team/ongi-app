import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ongi_app/features/guardian/nav/guardian_navigation.dart';

class GuardianShell extends StatelessWidget {
  const GuardianShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: GuardianNavigation(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}
