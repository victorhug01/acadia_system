import 'package:acadia/src/components/appbar/appbar_component.dart';
import 'package:acadia/src/components/drawer/drawer_component.dart';
import 'package:acadia/src/pages/chat/chat_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
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
    _loadUserData();
    super.initState();
    // Atualizar o método para carregar os dados do usuário
  }

  Future<void> _loadUserData() async {
    final client = Supabase.instance.client;
    final userId = client.auth.currentUser?.id;

    if (userId != null) {
      try {
        final response = await client.from('secretaria').select('nome, avatar').eq('id', userId).single();

        if (response['avatar'] != null) {
          // ignore: use_build_context_synchronously
          await precacheImage(NetworkImage(response['avatar']), context);
        }

        setState(() {
          _imageUrl = response['avatar'];
          userName = response['nome'] ?? 'Nome não encontrado';
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

  List<String> imagesCarousel = [
    'assets/images/slide1.png',
    'assets/images/slide2.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;
    if (isLoading) {
      // Exibe um indicador de carregamento enquanto os dados estão sendo carregados
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
            await client.from('secretaria').update({'avatar': imageUrl}) // Atualiza o avatar no banco de dados
                .eq('id', userId);
          }
        },
      ),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBarComponent(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            SizedBox(
              width: double.maxFinite,
              height: 300,
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlayCurve: Curves.easeInOut,
                  autoPlay: true,
                  viewportFraction: 1,
                  aspectRatio: 1,
                ),
                items: <Widget>[
                  Image.asset(
                    'assets/images/slide1.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    width: double.infinity,
                    height: double.maxFinite,
                  ),
                  Image.asset(
                    'assets/images/slide2.jpg',
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: double.maxFinite,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              return  Dialog(
                alignment: Alignment.centerRight,
                insetPadding: const EdgeInsets.all(0),
                child: SizedBox(
                  height: double.maxFinite,
                  width: 450.0,
                  child: ChatPage(
                    avatarUser: _imageUrl.toString(),
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(HugeIcons.strokeRoundedAiChat02),
      ),
    );
  }
}
