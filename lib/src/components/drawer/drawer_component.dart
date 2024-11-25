import 'package:acadia/src/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
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
  State<DrawerComponent> createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  bool isUploading = false; // Estado para controlar o upload da imagem
  final userClient = Supabase.instance.client.auth.currentUser;

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
      imageUrl = Uri.parse(imageUrl).replace(queryParameters: {'t': DateTime.now().millisecondsSinceEpoch.toString()}).toString();
      widget.onUpload(imageUrl);
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
    final navigation = Navigator.of(context);
    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      surfaceTintColor: ColorSchemeManagerClass.colorWhite,
      backgroundColor: ColorSchemeManagerClass.colorWhite,
      child: Column(
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
                        radius: 65.0,
                        backgroundColor: ColorSchemeManagerClass.colorGrey,
                        backgroundImage: widget.imageUrl != null && !isUploading ? NetworkImage(widget.imageUrl!) : null,
                        child: widget.imageUrl == null && !isUploading
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white, // Placeholder ícone de pessoa
                              )
                            : isUploading
                                ? CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    color: ColorSchemeManagerClass.colorPrimary,
                                  ) // Indicador de progresso durante o upload
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
                                HugeIcons.strokeRoundedPencilEdit01,
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
                        color: ColorSchemeManagerClass.colorBlack,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Text(
                    (client.auth.currentUser!.email).toString(),
                    style: TextStyle(
                      fontSize: 12.5,
                      color: ColorSchemeManagerClass.colorGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            leading: const Icon(HugeIcons.strokeRoundedHome10),
            title: const Text(
              'Home',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            leading: const Icon(HugeIcons.strokeRoundedNote),
            title: const Text(
              'Anotações',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              // navigation.pushNamed('/notes');
              navigation.pushNamed('/verifyotp');
            },
          ),
          ExpansionTile(
            leading: const Icon(HugeIcons.strokeRoundedAssignments),
            childrenPadding: const EdgeInsets.only(left: 40.0, bottom: 20.0),
            title: const Text(
              'Cadastro',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            children: <Widget>[
              ListTileComponent(
                title: 'Aluno',
                onTap: () {
                  navigation.pushNamed('/options_student');
                },
              ),
              userClient!.id == 'cb7fd182-9255-402c-a601-c41f824c9df1' || userClient!.id == '4483096e-367a-4b04-9273-4ae2bd407c9c'
                  ? ListTileComponent(
                      title: 'Secratário(a)',
                      onTap: () {
                        navigation.pushNamed('/view_secretaries');
                      },
                    )
                  : const SizedBox.shrink()
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async {
                final navigation = Navigator.of(context);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
                try {
                  await client.auth.signOut();
                } catch (e) {
                  // ignore: avoid_print
                  print(e);
                } finally {
                  await navigation.pushNamedAndRemoveUntil('/', (router) => false);
                  navigation.pop();
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.exit_to_app,
                    color: ColorSchemeManagerClass.colorPrimary,
                    size: 17.0,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    'Sair',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 16.0,
                      color: ColorSchemeManagerClass.colorPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListTileComponent extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;
  const ListTileComponent({super.key, this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 37.0,
      child: ListTile(
        title: Text(
          title.toString(),
          style: TextStyle(
            color: ColorSchemeManagerClass.colorGrey,
          ),
        ),
        trailing: const Icon(HugeIcons.strokeRoundedArrowRight02),
        onTap: onTap,
      ),
    );
  }
}
