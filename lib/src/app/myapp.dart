import 'package:acadia/src/pages/home/home.dart';
import 'package:acadia/src/pages/login/login.dart';
import 'package:acadia/src/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;
    return MaterialApp(
      title: 'Acadia',
      theme: ThemeData(
        fontFamily: GoogleFonts.lato().fontFamily,
        colorScheme: ColorScheme.fromSeed(
            seedColor: ColorSchemeManagerClass.colorPrimary),
        useMaterial3: true,
      ),
      initialRoute: client.auth.currentSession != null ? '/home' : '/login',
      routes: {
        '/': (context) => const LoginPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}