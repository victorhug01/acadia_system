import 'package:acadia/src/components/appbar/appbar_component.dart';
import 'package:acadia/src/components/textformfields/field_component.dart';
import 'package:acadia/src/pages/student/update_student/update_student.dart';
import 'package:acadia/src/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OptionsStudent extends StatefulWidget {
  const OptionsStudent({super.key});

  @override
  State<OptionsStudent> createState() => _OptionsStudentState();
}

class _OptionsStudentState extends State<OptionsStudent> {
  final TextEditingController searchStudentController = TextEditingController();
  List<dynamic> students = [];

  // Função de filtro
  List<dynamic> filterStudents(String query) {
    if (query.isEmpty) {
      return students;
    }
    return students.where((student) {
      return student['nome'].toLowerCase().contains(query.toLowerCase()) ||
          student['email'].toLowerCase().contains(query.toLowerCase()) ||
          student['id_aluno'].toString().contains(query) ||
          student['serie'].toLowerCase().contains(query.toLowerCase()) ||
          student['turma'].toLowerCase().contains(query.toLowerCase()) ||
          student['escola'].toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final stream = Supabase.instance.client.from('aluno').stream(primaryKey: ['id_aluno']);

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
                          'Alunos',
                          style: TextStyle(color: ColorSchemeManagerClass.colorPrimary, fontWeight: FontWeight.w900, fontSize: 20.0),
                        ),
                        Text(
                          'Veja todos os alunos cadastrados',
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
                        Navigator.pushNamed(context, '/register_student');
                      },
                      child: Row(
                        children: [
                          Icon(
                            HugeIcons.strokeRoundedAdd01,
                            color: ColorSchemeManagerClass.colorWhite,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Novo aluno',
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
                    controller: searchStudentController,
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
                        child: const TextComponente(title: 'Alunos cadastrados'),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.purple,
                              child: const TextComponente(title: 'Registro do aluno'),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.red,
                              child: const TextComponente(title: 'Série'),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.green,
                              child: const TextComponente(title: 'Turma'),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.cyan,
                              child: const TextComponente(title: 'Escola'),
                            ),
                          ),
                        ],
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
                    return const Center(child: Text('Nenhum aluno encontrado.'));
                  }

                  students = snapshot.data!;

                  final filteredStudents = filterStudents(searchStudentController.text);

                  // Exibir mensagem caso não haja alunos filtrados
                  if (filteredStudents.isEmpty) {
                    return const Center(child: Text('Nenhum aluno encontrado para a pesquisa.'));
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
                                idAlunoUpdate: int.parse(student['id_aluno'].toString()),
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
                                        backgroundImage: student['imageProfile'] != null ? NetworkImage(student['imageProfile']) : null,
                                        child: student['imageProfile'] == null
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          color: Colors.amber,
                                          child: Text(student['id_aluno'].toString()),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          color: Colors.deepOrangeAccent,
                                          child: Text(student['serie'].toString()),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          color: Colors.indigo,
                                          child: Text(student['turma'].toString()),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          color: Colors.lime,
                                          child: Text(
                                            student['escola'].toString(),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
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
