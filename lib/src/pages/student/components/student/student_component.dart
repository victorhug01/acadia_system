import 'package:acadia/src/components/textformfields/field_component.dart';
import 'package:acadia/src/theme/theme_colors.dart';
import 'package:acadia/src/validations/mixin_validation.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class StudentComponent extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final ValueNotifier<XFile?> imagemAlunoNotifier;
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

  const StudentComponent({
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
    required this.imagemAlunoNotifier,
  });

  @override
  State<StudentComponent> createState() => _StudentComponentState();
}

class _StudentComponentState extends State<StudentComponent> with ValidationMixinClass {
  String? selectedSchool;
List<Map<String, dynamic>> schools = []; // Alterado para armazenar um mapa com nome e id_escola
String? selectedTypeSerie;
List<String> typeSeries = [];
String? selectedTurma;
List<String> turmas = [];
int? selectedSchoolId; // Armazena o ID da escola selecionada

@override
void initState() {
  super.initState();
  _loadSchoolNames(); // Carrega os nomes das escolas no início
}

Future<void> _loadSchoolNames() async {
  try {
    // Carrega as escolas com seus respectivos ids
    final List<dynamic> response = await Supabase.instance.client.from('escola').select('id_escola, nome');
    
    // Verifica a resposta
    print('Escolas carregadas: $response');
    
    // Atualiza a lista de escolas com os nomes e ids
    setState(() {
      schools = List<Map<String, dynamic>>.from(
        response.map((escola) => {
          'id_escola': escola['id_escola'],
          'nome': escola['nome'],
        })
      );
    });
  } catch (e) {
    print('Erro ao tentar buscar escolas: $e');
  }
}

Future<void> _loadAnosSeries(int schoolId) async {
  try {
    // Verificar o ID da escola antes da consulta
    print('Carregando turmas para a escola com ID: $schoolId');
    
    // Carregar as turmas filtradas pelo id da escola
    final List<dynamic> response = await Supabase.instance.client
        .from('tipo_serie')
        .select('id_tipo_serie, nome, fk_id_escola')
        .eq('fk_id_escola', schoolId); // Filtra as turmas pela escola selecionada

    // Verifica a resposta
    print('Resposta da consulta para turmas: $response');
    
    // Atualiza a lista de turmas
    setState(() {
      if (response.isEmpty) {
        // Se a resposta estiver vazia, exibe uma mensagem no console
        print('Nenhuma turma encontrada para a escola com ID: $schoolId');
      } else {
        // Caso contrário, preenche a lista de turmas com os resultados
        typeSeries = List<String>.from(response.map((serie) => serie['nome']));
      }
    });
  } catch (e) {
    print('Erro ao tentar buscar turmas: $e');
  }
}
Future<void> _loadTurmas(int schoolId) async {
  try {
    final List<dynamic> response = await Supabase.instance.client
        .from('turma')
        .select('grupo')
        .eq('fk_id_escola', schoolId); // Filtra pela escola selecionada

    setState(() {
      // Atualiza a lista de turmas (grupos)
      turmas = List<String>.from(response.map((turma) => turma['grupo']));
    });
  } catch (e) {
    print('Erro ao tentar buscar turmas: $e');
  }
}

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        widget.imagemAlunoNotifier.value = image;
      });
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
                        onTap: _pickImage,
                        child: Container(
                          width: 180,
                          height: 220,
                          decoration: BoxDecoration(
                            color: widget.imagemAlunoNotifier.value != null ? Colors.transparent : ColorSchemeManagerClass.colorPrimary,
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(width: 2.0, color: ColorSchemeManagerClass.colorPrimary),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ValueListenableBuilder<XFile?>(
                                valueListenable: widget.imagemAlunoNotifier,
                                builder: (context, image, child) {
                                  return image != null
                                      ? Image.file(
                                          File(image.path),
                                          fit: BoxFit.cover,
                                        )
                                      : const SizedBox.shrink();
                                },
                              ),
                              if (widget.imagemAlunoNotifier.value == null)
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
        selectedTypeSerie = null; // Limpa a seleção do tipo de série
        selectedTurma = null; // Limpa a seleção da turma
        typeSeries = [];
        turmas = []; // Limpa as turmas
      });

      if (selectedSchoolId != null) {
        _loadAnosSeries(selectedSchoolId!); // Carrega turmas com base na escola
        _loadTurmas(selectedSchoolId!); // Carrega turmas da escola
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

// Só mostra o dropdown de tipo de série se uma escola foi selecionada
selectedSchoolId == null
    ? Container()
    : Container(
        width: 180,
        decoration: BoxDecoration(
          color: ColorSchemeManagerClass.colorPrimary,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: DropdownButtonFormField<String>(
          value: selectedTypeSerie,
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
              selectedTypeSerie = newValue; // Atualiza a turma selecionada
            });
          },
          items: typeSeries.isNotEmpty
              ? typeSeries.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: ColorSchemeManagerClass.colorWhite)),
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

const SizedBox(height: 15),

// Só mostra o dropdown de turma se uma escola foi selecionada e um tipo de série
selectedSchoolId == null || selectedTypeSerie == null
    ? Container()
    : Container(
        width: 180,
        decoration: BoxDecoration(
          color: ColorSchemeManagerClass.colorPrimary,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: DropdownButtonFormField<String>(
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
              selectedTurma = newValue; // Atualiza a turma selecionada
            });
          },
          items: turmas.isNotEmpty
              ? turmas.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: ColorSchemeManagerClass.colorWhite)),
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
