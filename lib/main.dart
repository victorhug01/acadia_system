import 'package:acadia/src/app/myapp.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://awamsrvpvsysyhflmvei.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF3YW1zcnZwdnN5c3loZmxtdmVpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjM2NTM5MjQsImV4cCI6MjAzOTIyOTkyNH0.-VaduMrkDitGXYhxYzVZSe51qL1Nr1Prt6bmvlcXOEw',
  );
  runApp(const MyApp());
}
