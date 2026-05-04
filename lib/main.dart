import 'package:flutter/material.dart';
import 'core/constants/constants.dart';
import 'core/router/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '온기',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: OngiColor.primary),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
