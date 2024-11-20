import 'package:acadia/src/app/myapp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:window_manager/window_manager.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  Gemini.init(
    apiKey: 'AIzaSyDwDPE34Z8spAke38owElvnwjAjqo4EkWQ',
  );
  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(950, 600),
    size: Size(950, 600),
    center: true,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    windowButtonVisibility: true,
    title: ''
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  await Supabase.initialize(
    url: 'https://awamsrvpvsysyhflmvei.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF3YW1zcnZwdnN5c3loZmxtdmVpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjM2NTM5MjQsImV4cCI6MjAzOTIyOTkyNH0.-VaduMrkDitGXYhxYzVZSe51qL1Nr1Prt6bmvlcXOEw',
  );
  runApp(const MyApp());
}