import 'package:acadia/src/components/appbar/appbar_component.dart';
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
  String? userName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Atualizar o método para carregar os dados do usuário
  }

  Future<void> _loadUserData() async {
    final client = Supabase.instance.client;
    final userId = client.auth.currentUser?.id;

    if (userId != null) {
      try {
        // Seleciona o nome e o avatar
        final response = await client
            .from('secretaria')
            .select('nome, avatar')
            .eq('id', userId)
            .single();

        setState(() {
          userName = response['nome'] ?? 'Nome não encontrado';
          _imageUrl = response['avatar']; // Carrega a URL do avatar
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          userName = 'Erro ao carregar os dados';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;

    return Scaffold(
      drawer: DrawerComponent(
        imageUrl: _imageUrl, // Passa a URL da imagem carregada
        userName: userName,
        isLoading: isLoading,
        onUpload: (imageUrl) async {
          setState(() {
            _imageUrl = imageUrl; // Atualiza a URL da imagem no estado
          });

          final userId = client.auth.currentUser?.id;
          if (userId != null) {
            await client.from('secretaria').update(
                    {'avatar': imageUrl}) // Atualiza o avatar no banco de dados
                .eq('id', userId);
          }
        },
      ),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBarComponent(),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final navigation = Navigator.of(context);
            await client.auth.signOut();
            await navigation.pushNamedAndRemoveUntil('/', (router) => false);
          },
          child: const Text('Sair'),
        ),
      ),
    );
  }
}
