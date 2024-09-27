import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:acadia/src/theme/theme_colors.dart';

class DrawerComponent extends StatefulWidget {
  const DrawerComponent({super.key});

  @override
  State<DrawerComponent> createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  final client = Supabase.instance.client;
  String? userName;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId != null) {
        final response = await client
            .from('secretaria') // Nome da tabela
            .select('nome') // Campo que deseja buscar
            .eq('id', userId) // Filtra pelo ID do usuário
            .single(); // Retorna apenas um registro

        setState(() {
          userName = response['nome'] ?? 'Nome não encontrado';
          isLoading = false;
        });
      } else {
        setState(() {
          userName = 'Usuário não encontrado';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Erro: $error';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      surfaceTintColor: ColorSchemeManagerClass.colorWhite,
      backgroundColor: ColorSchemeManagerClass.colorWhite,
      child: ListView(
        children: [
          SizedBox(
            height: 250,
            child: DrawerHeader(
              // decoration: const BoxDecoration(
              //   color: Colors.blue,
              // ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 70.0,
                    backgroundImage: AssetImage('assets/images/background.jpg'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (isLoading)
                    const CircularProgressIndicator() // Mostra o indicador de carregamento
                  else if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorSchemeManagerClass.colorPrimary,
                      ),
                    )
                  else
                    Text(
                      userName ?? 'Nome não disponível',
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorSchemeManagerClass.colorPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Text(
                    (client.auth.currentUser!.email).toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorSchemeManagerClass.colorPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ExpansionTile(
            childrenPadding: const EdgeInsets.symmetric(horizontal: 20.0,),
            title: const Text('Cadastrar'),
            children: <Widget>[
              ListTile(
                title: const Text('aluno'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('professor'),
                tileColor: ColorSchemeManagerClass.colorWhite,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('matéria'),
                tileColor: ColorSchemeManagerClass.colorWhite,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('escola'),
                tileColor: ColorSchemeManagerClass.colorWhite,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('série'),
                tileColor: ColorSchemeManagerClass.colorWhite,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('turma'),
                tileColor: ColorSchemeManagerClass.colorWhite,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
