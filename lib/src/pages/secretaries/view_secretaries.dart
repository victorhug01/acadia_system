import 'package:acadia/src/components/appbar/appbar_component.dart';
import 'package:acadia/src/components/textformfields/field_component.dart';
import 'package:acadia/src/pages/student/update_student/update_student.dart';
import 'package:acadia/src/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewSecretariesPage extends StatefulWidget {
  const ViewSecretariesPage({super.key});

  @override
  State<ViewSecretariesPage> createState() => _ViewSecretariesPageState();
}

class _ViewSecretariesPageState extends State<ViewSecretariesPage> {
  final TextEditingController searchSecretariesController = TextEditingController();
  List<dynamic> secretaries = [];

  // Função de filtro
  List<dynamic> filterSecretaries(String query) {
    if (query.isEmpty) {
      return secretaries;
    }
    return secretaries.where((secretaries) {
      return secretaries['nome'].toLowerCase().contains(query.toLowerCase()) || secretaries['email'].toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final stream = Supabase.instance.client.from('secretaria').stream(primaryKey: ['id']);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBarComponent(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
            icon: Icon(Icons.adaptive.arrow_back),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(6),
            child: Container(
              height: 6,
              color: ColorSchemeManagerClass.colorPrimary,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              SizedBox(
                height: 80.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Secretários',
                          style: TextStyle(color: ColorSchemeManagerClass.colorPrimary, fontWeight: FontWeight.w900, fontSize: 20.0),
                        ),
                        Text(
                          'Veja todos os secretários cadastrados',
                          style: TextStyle(color: ColorSchemeManagerClass.colorPrimary, fontWeight: FontWeight.w400, fontSize: 16.0),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15.0),
                        elevation: 0.0,
                        backgroundColor: ColorSchemeManagerClass.colorPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/secretaries_register');
                      },
                      child: Row(
                        children: [
                          Icon(
                            HugeIcons.strokeRoundedAdd01,
                            color: ColorSchemeManagerClass.colorWhite,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Novo secretário',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w800,
                              color: ColorSchemeManagerClass.colorWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 55,
                  width: 300,
                  child: TextFormFieldComponent(
                    hintText: 'Pesquisar por...',
                    onChanged: (String? value) {
                      setState(() {});
                    },
                    iconPrefix: Icon(
                      Icons.search,
                      color: ColorSchemeManagerClass.colorPrimary,
                    ),
                    autofocus: false,
                    controller: searchSecretariesController,
                    inputBorderType: const OutlineInputBorder(),
                    inputType: TextInputType.text,
                    obscure: false,
                    sizeInputBorder: 2,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                width: double.maxFinite,
                height: 40,
                decoration: BoxDecoration(
                  color: ColorSchemeManagerClass.colorPrimary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: const TextComponente(title: 'Secretários'),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<List<dynamic>>(
                stream: stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar dados: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Nenhum secretário encontrado.'));
                  }

                  secretaries = snapshot.data!;

                  final filteredStudents = filterSecretaries(searchSecretariesController.text);

                  // Exibir mensagem caso não haja alunos filtrados
                  if (filteredStudents.isEmpty) {
                    return const Center(child: Text('Nenhum secretário encontrado para a pesquisa.'));
                  }

                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ColorSchemeManagerClass.colorPrimary,
                        width: 2.0,
                      ),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: filteredStudents.length,
                      itemBuilder: (context, index) {
                        final student = filteredStudents[index];
                        return InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => UpdateStudentPage(
                                idAlunoUpdate: int.parse(student['id'].toString()),
                              ),
                            ),
                          ),
                          child: Container(
                            height: 70,
                            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                            width: double.maxFinite,
                            color: (index % 2) == 1 ? ColorSchemeManagerClass.colorSecondary : Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: student['avatar'] != null ? NetworkImage(student['avatar']) : null,
                                        child: student['avatar'] == null
                                            ? const Icon(Icons.person) // Icone padrão se não houver imagem
                                            : null,
                                      ),
                                      const SizedBox(width: 6),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(student['nome']),
                                          Text(student['email']),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      onPressed: () async {
                                        _showDeleteDialog(student['id'], student['nome']);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: ColorSchemeManagerClass.colorDanger,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  final adminClient = SupabaseClient(
    'https://awamsrvpvsysyhflmvei.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF3YW1zcnZwdnN5c3loZmxtdmVpIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcyMzY1MzkyNCwiZXhwIjoyMDM5MjI5OTI0fQ.tj1xn3SpWtyqRrLGTVmjKwNl0LTBuusRWiyKwy8KymQ',
  );

  void _showDeleteDialog(String idSecretario, String nomeSecretario) {
    showDialog(
      barrierColor: Colors.black.withOpacity(0.7),
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Excluir secretário?'),
          content: RichText(
            text: TextSpan(
              text: 'Tem certeza que deseja excluir: ',
              style: TextStyle(color: ColorSchemeManagerClass.colorBlack),
              children: <TextSpan>[
                TextSpan(
                  text: nomeSecretario,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Fecha o diálogo
                await deleteUser(idSecretario); // Chama a função para deletar
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteUser(String userId) async {
    final sm = ScaffoldMessenger.of(context);
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
      await adminClient.from('secretaria').delete().eq('id', userId);
      await adminDeleteUser(userIdForDelete: userId);

      sm.showSnackBar(
        SnackBar(
          backgroundColor: ColorSchemeManagerClass.colorCorrect,
          content: const Text('Secretário excluído com sucesso!'),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      sm.showSnackBar(
        SnackBar(
          backgroundColor: ColorSchemeManagerClass.colorDanger,
          content: Text('Erro ao excluir secretário: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      navigation.pushReplacementNamed('/view_secretaries');
    }
  }

  Future<void> adminDeleteUser({required String userIdForDelete}) async {
    try {
      await adminClient.auth.admin.deleteUser(userIdForDelete);
      debugPrint('Usuário deletado com sucesso!');
    } catch (e) {
      debugPrint('Erro ao deletar usuário: $e');
      rethrow;
    }
  }
}

class TextComponente extends StatelessWidget {
  final String title;
  const TextComponente({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(color: ColorSchemeManagerClass.colorWhite),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
