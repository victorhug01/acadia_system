import 'package:acadia/src/components/textformfields/field_component.dart';
import 'package:acadia/src/theme/theme_colors.dart';
import 'package:acadia/src/validations/mixin_validation.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentUpdateComponente extends StatefulWidget {
  final String? imageUrl;
  final String? userName;
  final bool isLoading;
  final void Function(String imageUrl) onUpload;
  final GlobalKey<FormState> formKey;
  final ValueNotifier<String?> turmaAlunoNotifier;
  final ValueNotifier<String?> serieAlunoNotifier;
  final ValueNotifier<String?> escolaAlunoNotifier;
  final TextEditingController nameStudentController;
  final TextEditingController emailStudentController;
  final TextEditingController cpfStudentController;
  final TextEditingController rgStudentController;
  final TextEditingController celularStudentController;
  final TextEditingController enderecoStudentController;
  final TextEditingController numeroStudentController;
  final TextEditingController cepStudentController;
  final TextEditingController bairroStudentController;
  final TextEditingController cidadeStudentController;
  final TextEditingController ufStudentController;
  final TextEditingController complementoStudentController;
  final TextEditingController dataNacimentoStudentController;
  final TextEditingController raStudentController;
  final TextEditingController escolaAnteriorController;
  final TextEditingController sexoStudentController;
  final TextEditingController nomeResponsavelController;
  final TextEditingController cpfResponsavelController;

  const StudentUpdateComponente({
    super.key,
    required this.nameStudentController,
    required this.emailStudentController,
    required this.cpfStudentController,
    required this.rgStudentController,
    required this.celularStudentController,
    required this.enderecoStudentController,
    required this.numeroStudentController,
    required this.cepStudentController,
    required this.bairroStudentController,
    required this.cidadeStudentController,
    required this.ufStudentController,
    required this.complementoStudentController,
    required this.formKey,
    required this.dataNacimentoStudentController,
    required this.raStudentController,
    required this.escolaAnteriorController,
    required this.sexoStudentController,
    required this.nomeResponsavelController,
    required this.cpfResponsavelController,
    required this.turmaAlunoNotifier, 
    required this.escolaAlunoNotifier, 
    required this.serieAlunoNotifier, this.imageUrl, this.userName, required this.isLoading, required this.onUpload,
  });

  @override
  State<StudentUpdateComponente> createState() => _StudentUpdateComponenteState();
}

class _StudentUpdateComponenteState extends State<StudentUpdateComponente> with ValidationMixinClass {
  String? selectedSchool;
  String? selectedSerie;
  String? selectedTurma;
  int? selectedTypeSerie;
  bool isUploading = false;
  List<Map<String, dynamic>> schools = [];
  List<String> typeEnsino = [];
  List<String> turmas = [];
  List<String> series = [];
  int? selectedSchoolId;
  int? selectedSerieId;
  List<Map<String, dynamic>> seriesResponse = [];
  List<Map<String, dynamic>> tipoEnsino = [];

  @override
  void initState() {
    super.initState();
    _loadSchoolNames();
  }

  Future<void> _loadSchoolNames() async {
    try {
      final List<dynamic> response = await Supabase.instance.client.from('escola').select('id_escola, nome');

      // ignore: avoid_print
      print('Escolas carregadas: $response');

      setState(() {
        schools = List<Map<String, dynamic>>.from(response.map((escola) => {
              'id_escola': escola['id_escola'],
              'nome': escola['nome'],
            }));
      });
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao tentar buscar escolas: $e');
    }
  }

  Future<void> _loadAnosEnsino(int schoolId) async {
    try {
      // ignore: avoid_print
      print('Carregando tipos de ensino para a escola com ID: $schoolId');

      final List<dynamic> response = await Supabase.instance.client.from('tipo_ensino').select('id_tipo_ensino, nome, fk_id_escola').eq('fk_id_escola', schoolId);

      // ignore: avoid_print
      print('Resposta da consulta para tipos de ensino: $response');

      setState(() {
        if (response.isEmpty) {
          // ignore: avoid_print
          print('Nenhum tipo de ensino encontrado para a escola com ID: $schoolId');
        } else {
          tipoEnsino = List<Map<String, dynamic>>.from(response);
        }
      });
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao tentar buscar tipos de ensino: $e');
    }
  }

  Future<void> _loadSeries(int idTipoEnsino) async {
    try {
      // ignore: avoid_print
      print('Buscando séries para o tipo de ensino com ID: $idTipoEnsino');

      final response = await Supabase.instance.client.from('serie').select('id_serie, ano').eq('fk_id_tipo_ensino', idTipoEnsino);

      if (response.isEmpty) {
        // ignore: avoid_print
        print('Nenhuma série encontrada para o tipo de ensino com ID: $idTipoEnsino');
        setState(() {
          series = [];
          seriesResponse = []; // Limpa seriesResponse também em caso de resposta vazia
        });
      } else {
        // ignore: avoid_print
        print('Séries encontradas: $response');
        setState(() {
          seriesResponse = List<Map<String, dynamic>>.from(response); // Armazena a resposta completa
          series = List<String>.from(seriesResponse.map((serie) => serie['ano'] ?? 'Valor não encontrado')); // Preenche com os nomes das séries
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao tentar buscar séries: $e');
      setState(() {
        series = []; // Limpa a lista de séries em caso de erro
        seriesResponse = [];
      });
    }
  }

  Future<void> _loadTurmas(int idSerie) async {
    try {
      // ignore: avoid_print
      print('Buscando turmas para a série com ID: $idSerie');

      final List<dynamic> response = await Supabase.instance.client.from('turma').select('grupo, qtdeAlunos').eq('fk_id_serie', idSerie);

      List<String> availableTurmas = [];
      bool isFull = false;

      if (response.isEmpty) {
        // ignore: avoid_print
        print('Nenhuma turma encontrada para a série com ID: $idSerie');
      } else {
        // ignore: avoid_print
        print('Turmas encontradas: $response');

        for (var turma in response) {
          // ignore: avoid_print
          print('Verificando turma: ${turma['grupo']}');
          if (turma['qtdeAlunos'] < 40) {
            availableTurmas.add(turma['grupo']);
          } else {
            isFull = true; // Marque que existe pelo menos uma turma cheia
          }
        }
      }

      if (mounted) {
        setState(() {
          turmas = availableTurmas; // Atualiza o estado com a lista de turmas disponíveis
        });

        // Mostra o diálogo caso todas as turmas estejam cheias e nenhuma disponível
        if (isFull && availableTurmas.isEmpty) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Turmas Cheias"),
                content: const Text("Todas as turmas estão cheias. Por favor, crie uma nova turma."),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao tentar buscar turmas: $e');
      if (mounted) {
        setState(() {
          turmas = []; // Limpa a lista de turmas em caso de erro
        });
      }
    }
  }

  Future<void> _uploadImage() async {
    final client = Supabase.instance.client;
    final sm = ScaffoldMessenger.of(context);
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

     if (image == null) {
      return;
    }

    try {
      final imageExtension = image.path.split('.').last.toLowerCase();
      final imagesBytes = await image.readAsBytes();
      final imagePath = '/${widget.cpfStudentController}/students-profile';

      // Faz o upload da imagem
      await client.storage.from('students-image').uploadBinary(
            imagePath,
            imagesBytes,
            fileOptions: FileOptions(upsert: true, contentType: 'image/$imageExtension'),
          );
      String imageUrl = client.storage.from('students-image').getPublicUrl(imagePath);
      imageUrl = Uri.parse(imageUrl).replace(queryParameters: {'t': DateTime.now().millisecondsSinceEpoch.toString()}).toString();
      await client.from('aluno').update({'imageProfile': imageUrl}).eq('id_aluno', widget.raStudentController);
    } catch (e) {
      sm.showSnackBar(SnackBar(
        backgroundColor: ColorSchemeManagerClass.colorDanger,
        content: Text(e.toString()),
        duration: const Duration(seconds: 3),
      ));
    }
  }

  Widget buildField(String label, TextEditingController controller, bool enable, dynamic validator, String asterisco, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label $asterisco',
            style: TextStyle(
              color: ColorSchemeManagerClass.colorPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            height: 45,
            constraints: const BoxConstraints(minHeight: 55, maxHeight: 56),
            child: TextFormFieldComponent(
              enable: enable,
              paddingLeftInput: 8.0,
              colorBorderInput: ColorSchemeManagerClass.colorPrimary,
              inputBorderType: const OutlineInputBorder(),
              sizeInputBorder: 1.5,
              controller: controller,
              inputType: TextInputType.text,
              obscure: false,
              autofocus: true,
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRow(List<Map<String, dynamic>> fields) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (var field in fields) ...[
          buildField(field['label'], field['controller'], field['enable'] ?? true, field['validations'], field['asterisco'] ?? '', flex: field['flex'] ?? 1),
          const SizedBox(width: 7),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.escolaAlunoNotifier.value = selectedSchool;
    widget.serieAlunoNotifier.value = selectedSerie;
    widget.turmaAlunoNotifier.value = selectedTurma;
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: widget.formKey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: _uploadImage,
                        child: SizedBox(
                          width: 180,
                          height: 220,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                               isUploading
                                ? const CircularProgressIndicator()
                                : const SizedBox.shrink(),
                              if (widget.imageUrl == null)
                                Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo_outlined, size: 55, color: ColorSchemeManagerClass.colorWhite),
                                      const SizedBox(height: 15.0),
                                      Text(
                                        'Adicionar uma foto',
                                        style: TextStyle(color: ColorSchemeManagerClass.colorWhite),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 180,
                        decoration: BoxDecoration(
                          color: ColorSchemeManagerClass.colorPrimary,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: DropdownButtonFormField<String>(
                          validator: isNotEmpyt,
                          value: selectedSchool,
                          dropdownColor: ColorSchemeManagerClass.colorPrimary,
                          borderRadius: BorderRadius.circular(5.0),
                          hint: Text(
                            'Selecionar escola',
                            style: TextStyle(
                              color: ColorSchemeManagerClass.colorWhite,
                            ),
                          ),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8.0),
                            border: InputBorder.none,
                          ),
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          style: TextStyle(color: ColorSchemeManagerClass.colorWhite),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedSchool = newValue;
                              selectedSchoolId = schools.firstWhere((escola) => escola['nome'] == newValue)['id_escola'];
                              selectedTypeSerie = null;
                              selectedTurma = null;
                              selectedSerie = null; // Limpar série ao mudar a escola
                              typeEnsino = [];
                              turmas = [];
                              series = []; // Limpar séries
                            });

                            if (selectedSchoolId != null) {
                              _loadAnosEnsino(selectedSchoolId!);
                            }
                          },
                          items: schools.map<DropdownMenuItem<String>>((Map<String, dynamic> escola) {
                            return DropdownMenuItem<String>(
                              value: escola['nome'],
                              child: Text(escola['nome'], style: TextStyle(color: ColorSchemeManagerClass.colorWhite)),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      selectedSchoolId == null
                          ? Container()
                          : Container(
                              width: 180,
                              decoration: BoxDecoration(
                                color: ColorSchemeManagerClass.colorPrimary,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: DropdownButtonFormField<int>(
                                // Agora espera um int
                                value: selectedTypeSerie,
                                dropdownColor: ColorSchemeManagerClass.colorPrimary,
                                borderRadius: BorderRadius.circular(5.0),
                                hint: Text(
                                  'Selecionar ensino',
                                  style: TextStyle(
                                    color: ColorSchemeManagerClass.colorWhite,
                                  ),
                                ),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 8.0),
                                  border: InputBorder.none,
                                ),
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                style: TextStyle(color: ColorSchemeManagerClass.colorWhite),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    selectedTypeSerie = newValue; // Armazena o id_tipo_ensino que é um int
                                  });
                                  if (newValue != null) {
                                    _loadSeries(newValue); // Passa o id_tipo_ensino como int para carregar as séries
                                  }
                                },
                                items: tipoEnsino.map<DropdownMenuItem<int>>((Map<String, dynamic> tipoEnsinoItem) {
                                  return DropdownMenuItem<int>(
                                    value: tipoEnsinoItem['id_tipo_ensino'], // Passa o id_tipo_ensino
                                    child: Text(tipoEnsinoItem['nome'], style: TextStyle(color: ColorSchemeManagerClass.colorWhite)),
                                  );
                                }).toList(),
                              ),
                            ),
                      const SizedBox(height: 15),
                      selectedSchoolId == null || selectedTypeSerie == null
                          ? Container()
                          : // Atualize o DropdownButtonFormField para usar a lista 'series' de Strings
                          Container(
                              width: 180,
                              decoration: BoxDecoration(
                                color: ColorSchemeManagerClass.colorPrimary,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: DropdownButtonFormField<String>(
                                validator: isNotEmpyt,
                                value: selectedSerie, // Variável que guarda o valor selecionado
                                dropdownColor: ColorSchemeManagerClass.colorPrimary,
                                borderRadius: BorderRadius.circular(5.0),
                                hint: Text(
                                  'Selecionar série',
                                  style: TextStyle(
                                    color: ColorSchemeManagerClass.colorWhite,
                                  ),
                                ),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 8.0),
                                  border: InputBorder.none,
                                ),
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                style: TextStyle(color: ColorSchemeManagerClass.colorWhite),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedSerie = newValue;
                                    selectedTurma = null; // Reseta a turma selecionada ao trocar a série

                                    final selectedSerieMap = seriesResponse.firstWhere(
                                      (serie) => serie['ano'] == newValue,
                                      orElse: () => {},
                                    );

                                    selectedSerieId = selectedSerieMap.isNotEmpty ? selectedSerieMap['id_serie'] : null;
                                  });

                                  if (selectedSerieId != null) {
                                    _loadTurmas(selectedSerieId!); // Recarrega as turmas para a nova série
                                  } else {
                                    setState(() {
                                      turmas = []; // Limpa as turmas caso o id da série não seja encontrado
                                    });
                                  }
                                },
                                items: series.isNotEmpty
                                    ? series.map<DropdownMenuItem<String>>((String serie) {
                                        return DropdownMenuItem<String>(
                                          value: serie, // Exibe o nome da série
                                          child: Text(serie, style: TextStyle(color: ColorSchemeManagerClass.colorWhite)),
                                        );
                                      }).toList()
                                    : [
                                        DropdownMenuItem<String>(
                                          value: null,
                                          child: Text(
                                            'Nenhuma série disponível',
                                            style: TextStyle(color: ColorSchemeManagerClass.colorWhite),
                                          ),
                                        ),
                                      ],
                              ),
                            ),
                      const SizedBox(height: 15),
                      selectedSchoolId == null || selectedTypeSerie == null || selectedSerie == null
                          ? Container()
                          : Container(
                              width: 180,
                              decoration: BoxDecoration(
                                color: ColorSchemeManagerClass.colorPrimary,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: DropdownButtonFormField<String>(
                                validator: isNotEmpyt,
                                value: selectedTurma,
                                dropdownColor: ColorSchemeManagerClass.colorPrimary,
                                borderRadius: BorderRadius.circular(5.0),
                                hint: Text(
                                  'Selecionar turma',
                                  style: TextStyle(
                                    color: ColorSchemeManagerClass.colorWhite,
                                  ),
                                ),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 8.0),
                                  border: InputBorder.none,
                                ),
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                style: TextStyle(color: ColorSchemeManagerClass.colorWhite),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedTurma = newValue;
                                  });
                                },
                                items: turmas.isNotEmpty
                                    ? turmas.map<DropdownMenuItem<String>>((String turma) {
                                        return DropdownMenuItem<String>(
                                          value: turma, // Exibe o nome da turma
                                          child: Text(turma, style: TextStyle(color: ColorSchemeManagerClass.colorWhite)),
                                        );
                                      }).toList()
                                    : [
                                        DropdownMenuItem<String>(
                                          value: null,
                                          child: Text(
                                            'Nenhuma turma disponível',
                                            style: TextStyle(color: ColorSchemeManagerClass.colorWhite),
                                          ),
                                        ),
                                      ],
                              ),
                            ),
                      const SizedBox(height: 5.0),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        buildRow([
                          {'label': 'Nome completo', 'controller': widget.nameStudentController, 'validations': isNotEmpyt, 'asterisco': '*'},
                          {
                            'label': 'Email',
                            'controller': widget.emailStudentController,
                            'asterisco': '*',
                            'validations': (value) => combine([
                                  () => isNotEmpyt(value),
                                  () => EmailValidator.validate(value.toString()) ? null : "Email inválido",
                                ]),
                          },
                        ]),
                        buildRow([
                          {
                            'label': 'Data nascimento',
                            'controller': widget.dataNacimentoStudentController,
                            'asterisco': '*',
                            'validations': (value) => combine([
                                  () => isNotEmpyt(value),
                                  () => isNumber(value),
                                ]),
                          },
                          {
                            'label': 'RG',
                            'controller': widget.rgStudentController,
                            'asterisco': '*',
                            'validations': (value) => combine([
                                  () => isNotEmpyt(value),
                                  () => isNumber(value),
                                ]),
                          },
                          {
                            'label': 'CPF',
                            'controller': widget.cpfStudentController,
                            'asterisco': '*',
                            'validations': (value) => combine([
                                  () => isNotEmpyt(value),
                                  () => isNumber(value),
                                  () => isValidCPF(value),
                                ]),
                          },
                          {
                            'label': 'RA',
                            'controller': widget.raStudentController,
                            'enable': false,
                            'validations': (value) => combine([
                                  () => isNotEmpyt(value),
                                  () => isNumber(value),
                                ]),
                          },
                        ]),
                        buildRow([
                          {
                            'label': 'Celular',
                            'controller': widget.celularStudentController,
                            'asterisco': '*',
                            'validations': (value) => combine([
                                  () => isNotEmpyt(value),
                                  () => isNumber(value),
                                ]),
                          },
                          {
                            'label': 'Sexo',
                            'controller': widget.sexoStudentController,
                            'validations': isNotEmpyt,
                            'asterisco': '*',
                          },
                          {'label': 'Escola anterior', 'controller': widget.escolaAnteriorController, 'flex': 4},
                        ]),
                        buildRow([
                          {
                            'label': 'Nome Responsável',
                            'controller': widget.nomeResponsavelController,
                            'flex': 2,
                            'enable': false,
                            'asterisco': '*',
                          },
                          {
                            'label': 'CPF do responsável',
                            'controller': widget.cpfResponsavelController,
                            'enable': false,
                            'asterisco': '*',
                          },
                        ]),
                        buildRow([
                          {
                            'label': 'CEP',
                            'controller': widget.cepStudentController,
                            'asterisco': '*',
                            'validations': (value) => combine([
                                  () => isNotEmpyt(value),
                                  () => isNumber(value),
                                ])
                          },
                          {
                            'label': 'Endereço',
                            'controller': widget.enderecoStudentController,
                            'flex': 2,
                            'validations': isNotEmpyt,
                            'asterisco': '*',
                          },
                          {
                            'label': 'Bairro',
                            'controller': widget.bairroStudentController,
                            'validations': isNotEmpyt,
                            'asterisco': '*',
                          },
                        ]),
                        buildRow([
                          {'label': 'Complemento', 'controller': widget.complementoStudentController},
                          {
                            'label': 'Número',
                            'controller': widget.numeroStudentController,
                            'asterisco': '*',
                            'validations': (value) => combine([
                                  () => isNotEmpyt(value),
                                  () => isNumber(value),
                                ]),
                          },
                          {
                            'label': 'Cidade',
                            'controller': widget.cidadeStudentController,
                            'validations': isNotEmpyt,
                            'asterisco': '*',
                          },
                          {
                            'label': 'UF',
                            'controller': widget.ufStudentController,
                            'validations': isNotEmpyt,
                            'asterisco': '*',
                          },
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
