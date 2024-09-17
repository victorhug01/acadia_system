import 'package:acadia/src/pages/login/login.dart';
import 'package:acadia/src/theme/theme_colors.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Acadia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ColorSchemeManagerClass.colorPrimary),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}