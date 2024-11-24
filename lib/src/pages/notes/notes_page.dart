import 'dart:convert';
import 'package:acadia/src/components/appbar/appbar_component.dart';
import 'package:acadia/src/components/textformfields/field_component.dart';
import 'package:acadia/src/responsive/display_responsive.dart';
import 'package:acadia/src/theme/theme_colors.dart';
import 'package:acadia/src/validations/mixin_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
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
  final _future = Supabase.instance.client.from('agenda').select('id_agenda, titulo, descricao').eq('fk_id_secretario', Supabase.instance.client.auth.currentUser!.id);

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
        debugPrint('Nenhum usuário autenticado.');
        return;
      }
      final userId = user.id;

      final response = await Supabase.instance.client.from('agenda').insert([
        {'fk_id_secretario': userId, 'descricao': description, 'titulo': title}
      ]);

      if (response.error != null) {
        debugPrint('Erro ao inserir na agenda: ${response.error!.message}');
      } else {
        debugPrint('Nota inserida com sucesso!');
      }
    } catch (e) {
      debugPrint('Erro ao acessar o usuário: $e');
    } finally {
      navigation.pop();
    }
  }

  Future<void> _updateNote({required String title, required String description, required int noteId}) async {
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
      final response = await Supabase.instance.client.from('agenda').update({
        'titulo': title,
        'descricao': description,
      }).eq('id_agenda', noteId);

      if (response.error != null) {
        debugPrint('Erro ao atualizar a agenda: ${response.error!.message}');
      } else {
        debugPrint('Nota atualizada com sucesso!');
      }
    } catch (e) {
      debugPrint('Erro ao acessar o usuário: $e');
    } finally {
      navigation.pop();
    }
  }

  Future<void> _deleteNote(int noteId) async {
    try {
      final response = await Supabase.instance.client.from('agenda').delete().eq('id_agenda', noteId);

      if (response.error != null) {
        debugPrint('Erro ao excluir a anotação: ${response.error!.message}');
      } else {
        debugPrint('Anotação excluída com sucesso!');
        setState(() {});
      }
    } catch (e) {
      debugPrint('Erro ao excluir a anotação: $e');
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
    final navigation = Navigator.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBarComponent(
          leading: IconButton(
            onPressed: () {
              navigation.pushReplacementNamed('/home');
            },
            icon: Icon(Icons.adaptive.arrow_back),
          ),
        ),
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
            child: FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final notes = snapshot.data!;
                return GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: responsive.isDesktop || responsive.isTabletLarge ? 4 : 5,
                  ),
                  itemCount: notes.length + 1,
                  itemBuilder: (BuildContext context, index) {
                    if (index == 0) {
                      return InkWell(
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
                                style: TextStyle(
                                  color: ColorSchemeManagerClass.colorWhite,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    final note = notes[index - 1];
                    Color cardColor = colors[(index - 1) % colors.length];

                    try {
                      final quillDocument = quill.Document.fromJson(jsonDecode(note['descricao']));
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            _editNote(note);
                          },
                          onLongPress: () {
                            final noteId = note['id_agenda'];
                            if (noteId != null) {
                              _showDeleteDialog(noteId);
                            } else {
                              debugPrint('ID da nota não encontrado');
                            }
                          },
                          child: Card(
                            color: cardColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    note['titulo'],
                                    style: const TextStyle(fontSize: 22),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 15),
                                  Expanded(
                                    child: quill.QuillEditor.basic(
                                      controller: quill.QuillController(
                                        document: quillDocument,
                                        selection: const TextSelection.collapsed(offset: 0),
                                      ),
                                      configurations: const quill.QuillEditorConfigurations(
                                        enableInteractiveSelection: false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } catch (e) {
                      debugPrint('Erro ao decodificar JSON: $e');
                      return GestureDetector(
                        onTap: () {
                          _editNote(note);
                        },
                        onLongPress: () {
                          final noteId = note['id_agenda'];
                          if (noteId != null) {
                            _showDeleteDialog(noteId);
                          } else {
                            debugPrint('ID da nota não encontrado');
                          }
                        },
                        child: Card(
                          color: cardColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(note['titulo']),
                                const SizedBox(height: 8),
                                const Text('Erro ao carregar a nota'),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _createNote() {
    final navigation = Navigator.of(context);
    final quillController = quill.QuillController.basic();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: ColorSchemeManagerClass.colorWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width / 1.3,
            height: 700,
            child: Form(
              key: _keyForm,
              child: Stack(
                children: [
                  ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
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
                              controller: titleController,
                              colorBorderInput: Colors.transparent,
                              inputBorderType: const OutlineInputBorder(),
                              inputType: TextInputType.text,
                              obscure: false,
                              sizeInputBorder: 2.0,
                            ),
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 181, 179, 179),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  width: 1.5,
                                  color: ColorSchemeManagerClass.colorGrey,
                                ),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 40,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        quill.QuillToolbar.simple(
                                          controller: quillController,
                                          configurations: const quill.QuillSimpleToolbarConfigurations(
                                            axis: Axis.horizontal,
                                            toolbarIconCrossAlignment: WrapCrossAlignment.center,
                                            toolbarSectionSpacing: 1.0,
                                            showInlineCode: false,
                                            showClipboardCut: false,
                                            showClipboardPaste: false,
                                            showClipboardCopy: false,
                                            showStrikeThrough: false,
                                            showHeaderStyle: false,
                                            showCodeBlock: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    color: ColorSchemeManagerClass.colorWhite,
                                    height: 300,
                                    child: quill.QuillEditor.basic(
                                      controller: quillController,
                                      configurations: const quill.QuillEditorConfigurations(
                                        enableInteractiveSelection: true,
                                        autoFocus: true,
                                        padding: EdgeInsets.all(15.0),
                                        placeholder: 'Escreva aqui',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
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
                          String description = jsonEncode(quillController.document.toDelta().toJson());
                          if (_keyForm.currentState!.validate()) {
                            await _sendNote(
                              description: description,
                              title: title,
                            );
                            titleController.clear();
                            quillController.clear();
                            navigation.pushReplacementNamed('/notes');
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

  void _showDeleteDialog(int noteId) {
    final navigation = Navigator.of(context);
    showDialog(
      barrierColor: Colors.black.withOpacity(0.7),
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Excluir anotação'),
          content: const Text('Tem certeza que deseja excluir esta anotação?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteNote(noteId);
                navigation.pushReplacementNamed('/notes');
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  void _editNote(Map<String, dynamic> note) {
    final navigation = Navigator.of(context);
    final quillController = quill.QuillController(
      document: quill.Document.fromJson(jsonDecode(note['descricao'])),
      selection: const TextSelection.collapsed(offset: 0),
    );
    titleController.text = note['titulo'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: ColorSchemeManagerClass.colorWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width / 1.3,
            height: 700,
            child: Form(
              key: _keyForm,
              child: Stack(
                children: [
                  ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              width: double.maxFinite,
                              child: Text(
                                'Editar anotação',
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
                              controller: titleController,
                              colorBorderInput: Colors.transparent,
                              inputBorderType: const OutlineInputBorder(),
                              inputType: TextInputType.text,
                              obscure: false,
                              sizeInputBorder: 2.0,
                            ),
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 181, 179, 179),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  width: 1.5,
                                  color: ColorSchemeManagerClass.colorGrey,
                                ),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 40,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        quill.QuillToolbar.simple(
                                          controller: quillController,
                                          configurations: const quill.QuillSimpleToolbarConfigurations(
                                            axis: Axis.horizontal,
                                            toolbarIconCrossAlignment: WrapCrossAlignment.center,
                                            toolbarSectionSpacing: 1.0,
                                            showInlineCode: false,
                                            showClipboardCut: false,
                                            showClipboardPaste: false,
                                            showClipboardCopy: false,
                                            showStrikeThrough: false,
                                            showHeaderStyle: false,
                                            showCodeBlock: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    color: ColorSchemeManagerClass.colorWhite,
                                    height: 300,
                                    child: quill.QuillEditor.basic(
                                      controller: quillController,
                                      configurations: const quill.QuillEditorConfigurations(
                                        enableInteractiveSelection: true,
                                        autoFocus: true,
                                        padding: EdgeInsets.all(15.0),
                                        placeholder: 'Escreva aqui',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
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
                          String description = jsonEncode(quillController.document.toDelta().toJson());
                          if (_keyForm.currentState!.validate()) {
                            await _updateNote(
                              description: description,
                              title: title,
                              noteId: note['id_agenda'],
                            );
                            titleController.clear();
                            quillController.clear();
                            navigation.pushReplacementNamed('/notes');
                          }
                        },
                        child: Text(
                          'Salvar alterações',
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
