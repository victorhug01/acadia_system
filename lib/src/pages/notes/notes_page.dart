import 'package:acadia/src/components/appbar/appbar_component.dart';
import 'package:acadia/src/components/textformfields/field_component.dart';
import 'package:acadia/src/responsive/display_responsive.dart';
import 'package:acadia/src/theme/theme_colors.dart';
import 'package:acadia/src/validations/mixin_validation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> with ValidationMixinClass {
  final GlobalKey<FormState> _keyForm = GlobalKey();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Future<void> _sendNote({required String title, required String description}) async {
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
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        // ignore: avoid_print
        print('Nenhum usuário autenticado.');
        return;
      }
      final userId = user.id;

      final response = await Supabase.instance.client.from('agenda').insert([
        {'fk_id_secretario': userId, 'descricao': description, 'titulo': title}
      ]);

      if (response.error != null) {
        // ignore: avoid_print
        print('Erro ao inserir na agenda: ${response.error!.message}');
      } else {
        // ignore: avoid_print
        print('Nota inserida com sucesso!');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao acessar o usuário: $e');
    } finally {
      navigation.pop();
    }
  }

  List<Color> colors = const [
    Color(0xffFDF3B4),
    Color(0xffD1EAED),
    Color(0xffFFDADB),
    Color(0xffFFD4AA),
    Color.fromARGB(255, 207, 248, 188),
  ];
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBarComponent(),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 50.0),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Minhas anotações',
              style: TextStyle(fontSize: 25, color: ColorSchemeManagerClass.colorBlack),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: responsive.isDesktop || responsive.isTabletLarge ? 4 : 5),
              itemCount: 16,
              itemBuilder: (BuildContext context, index) {
                Color cardColor = colors[index % colors.length];
                return index == 0
                    ? InkWell(
                        onTap: _createNote,
                        child: Card(
                          color: ColorSchemeManagerClass.colorPrimary,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: ColorSchemeManagerClass.colorWhite,
                                size: 45.0,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Adicionar',
                                style: TextStyle(color: ColorSchemeManagerClass.colorWhite, fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Card(
                        color: cardColor,
                        child: const Text('sjfh'),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _createNote({String? title, String? description}) {
    final navigation = Navigator.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: ColorSchemeManagerClass.colorWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width / 2,
            height: 700,
            child: Form(
              key: _keyForm,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(4.0),
                          width: double.maxFinite,
                          child: Text(
                            'Nova anotação',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: ColorSchemeManagerClass.colorBlack,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormFieldComponent(
                          validator: isNotEmpyt,
                          hintText: 'Título da anotação',
                          filled: true,
                          paddingLeftInput: 5.0,
                          fillColor: const Color(0xffF5F4F4),
                          autofocus: true,
                          maxLines: 1,
                          controller: titleController,
                          colorBorderInput: Colors.transparent,
                          inputBorderType: const OutlineInputBorder(),
                          inputType: TextInputType.text,
                          obscure: false,
                          sizeInputBorder: 2.0,
                        ),
                        TextFormFieldComponent(
                          minLines: 10,
                          validator: isNotEmpyt,
                          hintText: 'Descrição',
                          filled: true,
                          paddingLeftInput: 5.0,
                          maxLines: null,
                          fillColor: const Color(0xffF5F4F4),
                          autofocus: true,
                          controller: descriptionController,
                          colorBorderInput: ColorSchemeManagerClass.colorGrey,
                          inputBorderType: const OutlineInputBorder(),
                          inputType: TextInputType.multiline,
                          obscure: false,
                          sizeInputBorder: 2.0,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                          elevation: 0.0,
                          backgroundColor: ColorSchemeManagerClass.colorPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () async {
                          String title = titleController.value.text;
                          String description = descriptionController.value.text;
                          if (_keyForm.currentState!.validate()) {
                            await _sendNote(description: description, title: title);
                            titleController.clear();
                            descriptionController.clear();
                            navigation.pop();
                          }
                        },
                        child: Text(
                          'Adicionar',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w800,
                            color: ColorSchemeManagerClass.colorWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
