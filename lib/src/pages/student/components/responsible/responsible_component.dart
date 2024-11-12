import 'package:acadia/src/components/textformfields/field_component.dart';
import 'package:acadia/src/theme/theme_colors.dart';
import 'package:acadia/src/validations/mixin_validation.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class ResponsibleComponent extends StatelessWidget with ValidationMixinClass {
  final bool? enablecpfResponsible;
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
    required this.formKey, this.enablecpfResponsible,
  });


  Widget buildField(String label, TextEditingController controller, dynamic validator, String asterisco, bool enable, {int flex = 1}) {
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
          buildField(field['label'], field['controller'], field['validations'], field['asterisco'] ?? '',field['enable'] ?? true, flex: field['flex'] ?? 1),
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
                    {'label': 'Nome completo', 'controller': nameController, 'validations': isNotEmpyt, 'asterisco': '*'},
                    {
                      'label': 'Email',
                      'controller': emailController,
                      'asterisco': '*',
                      'validations': (value) => combine([
                            () => isNotEmpyt(value),
                            () => EmailValidator.validate(value.toString()) ? null : "Email inválido",
                          ]),
                    },
                  ]),
                  buildRow([
                    {
                      'label': 'CPF',
                      'controller': cpfController,
                      'asterisco': '*',
                      'enable': enablecpfResponsible,
                      'validations': (value) => combine([
                            () => isNotEmpyt(value),
                            () => isNumber(value),
                            () => isValidCPF(value),
                          ]),
                    },
                    {
                      'label': 'RG',
                      'controller': rgController,
                      'asterisco': '*',
                      'validations': (value) => combine([
                            () => isNotEmpyt(value),
                            () => isNumber(value),
                          ]),
                    },
                    {
                      'label': 'Celular',
                      'controller': celularController,
                      'asterisco': '*',
                      'validations': (value) => combine([
                            () => isNotEmpyt(value),
                            () => isNumber(value),
                          ]),
                    },
                  ]),
                  buildRow([
                    {
                      'label': 'CEP',
                      'controller': cepController,
                      'asterisco': '*',
                      'validations': (value) => combine([
                            () => isNotEmpyt(value),
                            () => isNumber(value),
                          ]),
                    },
                    {
                      'label': 'Número',
                      'controller': numeroController,
                      'asterisco': '*',
                      'validations': (value) => combine([
                            () => isNotEmpyt(value),
                            () => isNumber(value),
                          ]),
                    },
                    {'label': 'Endereço', 'controller': enderecoController, 'flex': 4, 'validations': isNotEmpyt, 'asterisco': '*'},
                  ]),
                  buildRow([
                    {'label': 'Bairro', 'controller': bairroController, 'validations': isNotEmpyt, 'asterisco': '*'},
                    {'label': 'Cidade', 'controller': cidadeController, 'validations': isNotEmpyt, 'asterisco': '*'},
                    {'label': 'UF', 'controller': ufController, 'validations': isNotEmpyt, 'asterisco': '*'},
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
