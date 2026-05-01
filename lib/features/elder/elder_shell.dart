import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ongi_app/features/elder/nav/elderly_navigation.dart';

class ElderShell extends StatelessWidget {
  const ElderShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: ElderlyNavigation(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}
