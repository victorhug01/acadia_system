import 'package:acadia/src/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DrawerComponent extends StatefulWidget {
  final String? imageUrl;
  final String? userName;
  final bool isLoading;
  final void Function(String imageUrl) onUpload;

  const DrawerComponent({
    super.key,
    this.imageUrl,
    this.userName,
    required this.onUpload,
    required this.isLoading,
  });

  @override
  _DrawerComponentState createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  bool isUploading = false; // Estado para controlar o upload da imagem

  Future<void> _uploadImage() async {
    final sm = ScaffoldMessenger.of(context);
    final client = Supabase.instance.client;
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    setState(() {
      isUploading = true; // Inicia o estado de upload
    });

    try {
      final imageExtension = image.path.split('.').last.toLowerCase();
      final imagesBytes = await image.readAsBytes();
      final userId = client.auth.currentUser!.id;
      final imagePath = '/$userId/profile';

      // Faz o upload da imagem
      await client.storage.from('profiles').uploadBinary(
            imagePath,
            imagesBytes,
            fileOptions: FileOptions(upsert: true, contentType: 'image/$imageExtension'),
          );

      String imageUrl = client.storage.from('profiles').getPublicUrl(imagePath);
      imageUrl = Uri.parse(imageUrl).replace(queryParameters: {
        't': DateTime.now().millisecondsSinceEpoch.toString()
      }).toString();

      widget.onUpload(imageUrl); // Chama o callback passando a nova URL da imagem
    } catch (e) {
      sm.showSnackBar(SnackBar(
        backgroundColor: ColorSchemeManagerClass.colorDanger,
        content: Text(e.toString()),
        duration: const Duration(seconds: 3),
      ));
    } finally {
      setState(() {
        isUploading = false; // Finaliza o estado de upload
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;

    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      surfaceTintColor: ColorSchemeManagerClass.colorWhite,
      backgroundColor: ColorSchemeManagerClass.colorWhite,
      child: ListView(
        children: [
          SizedBox(
            height: 250,
            child: DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 70.0,
                        backgroundImage: widget.imageUrl != null && !isUploading
                            ? NetworkImage(widget.imageUrl!)
                            : null,
                        child: widget.imageUrl == null && !isUploading
                            ? const Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.grey,
                              ) // Ícone exibido quando a imagem não é encontrada
                            : isUploading
                                ? const CircularProgressIndicator() // Mostra o progresso enquanto a imagem é enviada
                                : null,
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: CircleAvatar(
                          child: CircleAvatar(
                            backgroundColor: ColorSchemeManagerClass.colorPrimary,
                            child: IconButton(
                              onPressed: _uploadImage, // Função que faz o upload da imagem
                              icon: Icon(
                                Icons.edit,
                                color: ColorSchemeManagerClass.colorWhite,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (widget.isLoading)
                    const CircularProgressIndicator()
                  else
                    Text(
                      widget.userName ?? 'Nome não disponível',
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
            childrenPadding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('matéria'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('escola'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('série'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('turma'),
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
