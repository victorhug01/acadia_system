import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async{
            await client.auth.signOut();
            await Navigator.pushNamedAndRemoveUntil(
              context, '/', (router) => false
            );
          },
          child: const Text('Sair'),
        ),
      ),
    );
  }
}
