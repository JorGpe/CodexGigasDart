import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';


import 'package:codexgigas/landing/landing.dart';
import 'package:codexgigas/navigation/navigation.dart';

void main() {
  // Use URL strategy for cleaner URLs (no #/)
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: global_router,
      title: 'Codex Gigas - Analisis Numérico',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      // Removed the direct 'home' property as it's now managed by GoRouter
      // home: SelectableRegion(
      //   selectionControls: materialTextSelectionControls,
      //   child: const LandingPage()
      // ),
    );
  }
}