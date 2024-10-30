import 'package:acadia/src/components/textformfields/field_component.dart';
import 'package:acadia/src/theme/theme_colors.dart';
import 'package:acadia/src/validations/mixin_validation.dart';
import 'package:flutter/material.dart';

class StudentComponent extends StatelessWidget with ValidationMixinClass {
  final GlobalKey<FormState> formKey;
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
  //as
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
  });

  Widget buildField(String label, TextEditingController controller,
      {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label *',
            style: TextStyle(
              color: ColorSchemeManagerClass.colorPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            height: 45,
            constraints: const BoxConstraints(minHeight: 55, maxHeight: 56),
            child: TextFormFieldComponent(
              paddingLeftInput: 8.0,
              colorBorderInput: ColorSchemeManagerClass.colorPrimary,
              inputBorderType: const OutlineInputBorder(),
              sizeInputBorder: 1.5,
              controller: controller,
              inputType: TextInputType.text,
              obscure: false,
              autofocus: true,
              validator: isNotEmpyt,
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
          buildField(field['label'], field['controller'],
              flex: field['flex'] ?? 1),
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
              key: formKey,
              child: Column(
                children: [
                  buildRow([
                    {'label': 'Nome completo', 'controller': nameStudentController},
                    {'label': 'Email', 'controller': emailStudentController},
                  ]),
                  buildRow([
                    {'label': 'Data nascimento', 'controller': dataNacimentoStudentController},
                    {'label': 'RG', 'controller': rgStudentController},
                    {'label': 'CPF', 'controller': cpfStudentController},
                    {'label': 'RA', 'controller': raStudentController},
                  ]),
                  buildRow([
                    {'label': 'Celular', 'controller': celularStudentController},
                    {'label': 'Sexo', 'controller': sexoStudentController},
                    {
                      'label': 'Escola anterior',
                      'controller': escolaAnteriorController,
                      'flex': 4
                    },
                  ]),
                  buildRow([
                    {'label': 'Nome Responsável', 'controller': nomeResponsavelController, 'flex': 2},
                    {'label': 'CPF do responsável', 'controller': cpfResponsavelController},
                  ]),
                  buildRow([
                    {'label': 'CEP', 'controller': cepStudentController},
                    {'label': 'Endereço', 'controller': enderecoStudentController, 'flex': 2},
                    {'label': 'Bairro', 'controller': bairroStudentController},
                  ]),
                  buildRow([
                    {'label': 'Complemento', 'controller': complementoStudentController},
                    {'label': 'Número', 'controller': numeroStudentController},
                    {'label': 'Cidade', 'controller': cidadeStudentController},
                    {'label': 'Uf', 'controller': ufStudentController},
                    
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
