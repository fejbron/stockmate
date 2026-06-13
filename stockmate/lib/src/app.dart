import 'package:flutter/material.dart';

import 'router/app_router.dart';

class StockmateApp extends StatelessWidget {
  const StockmateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Stockmate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1F7A5A)),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
