import 'package:acadia/src/components/textformfields/field_component.dart';
import 'package:acadia/src/theme/theme_colors.dart';
import 'package:acadia/src/validations/mixin_validation.dart';
import 'package:flutter/material.dart';

class ResponsibleComponent extends StatelessWidget with ValidationMixinClass {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController cpfController;
  final TextEditingController rgController;
  final TextEditingController celularController;
  final TextEditingController enderecoController;
  final TextEditingController numeroController;
  final TextEditingController cepController;
  final TextEditingController bairroController;
  final TextEditingController cidadeController;
  final TextEditingController ufController;
  final TextEditingController complementoController;

  const ResponsibleComponent({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.cpfController,
    required this.rgController,
    required this.celularController,
    required this.enderecoController,
    required this.numeroController,
    required this.cepController,
    required this.bairroController,
    required this.cidadeController,
    required this.ufController,
    required this.complementoController, 
    required this.formKey,
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
                    {'label': 'Nome completo', 'controller': nameController},
                    {'label': 'Email', 'controller': emailController},
                  ]),
                  buildRow([
                    {'label': 'CPF', 'controller': cpfController},
                    {'label': 'RG', 'controller': rgController},
                    {'label': 'Celular', 'controller': celularController},
                  ]),
                  buildRow([
                    {'label': 'Cep', 'controller': cepController},
                    {'label': 'Número', 'controller': numeroController},
                    {
                      'label': 'Endereço',
                      'controller': enderecoController,
                      'flex': 4
                    },
                  ]),
                  buildRow([
                    {'label': 'Bairro', 'controller': bairroController},
                    {'label': 'Cidade', 'controller': cidadeController},
                    {'label': 'Uf', 'controller': ufController},
                    {'label': 'Complemento', 'controller': complementoController},
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
