import 'package:acadia/src/components/drawer/drawer_component.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _imageUrl;
  
  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }
  
  Future<void> _loadAvatar() async {
    final client = Supabase.instance.client;
    final userId = client.auth.currentUser!.id;
    final response = await client.from('secretaria').select('avatar').eq('id', userId).single();
    
    setState(() {
      _imageUrl = response['avatar'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;
    return Scaffold(
      drawer: DrawerComponent(
        imageUrl: _imageUrl,
        onUpload: (imageUrl) async {
          setState(() {
            _imageUrl = imageUrl;
          });
          final userId = client.auth.currentUser!.id;
          await client.from('secretaria').update({'avatar': imageUrl}).eq('id', userId);
        },
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/acadia_write.png',
          width: 150,
          height: 30,
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await client.auth.signOut();
            await Navigator.pushNamedAndRemoveUntil(context, '/', (router) => false);
          },
          child: const Text('Sair'),
        ),
      ),
    );
  }
}
