import 'package:acadia/src/pages/home/home.dart';
import 'package:acadia/src/pages/login/login.dart';
import 'package:acadia/src/pages/notes/notes_page.dart';
import 'package:acadia/src/pages/student/components/success_register/success_register.dart';
import 'package:acadia/src/pages/student/home_student/home_student.dart';
import 'package:acadia/src/pages/student/options_student/options_student.dart';
import 'package:acadia/src/pages/student/register_student/register_student.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'Acadia',
      theme: ThemeData(
        fontFamily: GoogleFonts.lato().fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ColorSchemeManagerClass.colorPrimary,
        ),
        scaffoldBackgroundColor: ColorSchemeManagerClass.colorWhite,
        appBarTheme: AppBarTheme(
          backgroundColor: ColorSchemeManagerClass.colorWhite,
          surfaceTintColor: ColorSchemeManagerClass.colorWhite,
          elevation: 0
        ),
        useMaterial3: true,
      ),
      initialRoute: client.auth.currentSession != null ? '/home' : '/login',
      routes: {
        '/': (context) => const LoginPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/home_student': (context) => const HomeStudent(),
        '/options_student': (context) => const OptionsStudent(),
        '/register_student': (context) => const RegisterStudentPage(),
        '/confetti': (context) => const ConfettiPage(),
        '/notes': (context) => const NotesPage(),
      },
    );
  }
}
