import 'package:acadia/src/components/appbar/appbar_component.dart';
import 'package:acadia/src/pages/student/home_student/home_student.dart';
import 'package:acadia/src/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OptionsStudent extends StatelessWidget {
  const OptionsStudent({super.key});

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
                child: const Row(
                  children: [
                    Expanded(child: TextComponente(title: 'Alunos cadastrados')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextComponente(title: 'Ano'),
                        SizedBox(width: 20),
                        TextComponente(title: 'Registro do aluno'),
                        SizedBox(width: 20),
                        TextComponente(title: 'Turma/curso'),
                        SizedBox(width: 20),
                        TextComponente(title: 'Número de matrícula'),
                      ],
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

                  final students = snapshot.data!;
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
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => HomeStudent(
                                idStudent: student['id_aluno'].toString(),
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
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
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
                                Text(student['id_aluno'].toString())
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
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
      style: TextStyle(
        color: ColorSchemeManagerClass.colorWhite,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
    );
  }
}
