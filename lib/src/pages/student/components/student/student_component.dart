import 'package:acadia/src/components/textformfields/field_component.dart';
import 'package:acadia/src/theme/theme_colors.dart';
import 'package:acadia/src/validations/mixin_validation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class StudentComponent extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final dynamic imagemAluno;
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
    this.imagemAluno,
  });

  @override
  State<StudentComponent> createState() => _StudentComponentState();
}

class _StudentComponentState extends State<StudentComponent> with ValidationMixinClass {
  
  // Função para pegar a imagem
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        widget.imagemAlunoNotifier.value = image; // Atualiza a imagem escolhida
      });
    }
  }

  Widget buildField(String label, TextEditingController controller, bool enable, {int flex = 1}) {
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
              enable: enable,
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
          buildField(field['label'], field['controller'], field['enable'] ?? true, flex: field['flex'] ?? 1),
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
                        onTap: _pickImage, // Chama a função para selecionar a imagem
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
                      const SizedBox(height: 5.0),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        buildRow([
                          {'label': 'Nome completo', 'controller': widget.nameStudentController},
                          {'label': 'Email', 'controller': widget.emailStudentController},
                        ]),
                        buildRow([
                          {'label': 'Data nascimento', 'controller': widget.dataNacimentoStudentController},
                          {'label': 'RG', 'controller': widget.rgStudentController},
                          {'label': 'CPF', 'controller': widget.cpfStudentController},
                          {'label': 'RA', 'controller': widget.raStudentController, 'enable': false},
                        ]),
                        buildRow([
                          {'label': 'Celular', 'controller': widget.celularStudentController},
                          {'label': 'Sexo', 'controller': widget.sexoStudentController},
                          {'label': 'Escola anterior', 'controller': widget.escolaAnteriorController, 'flex': 4},
                        ]),
                        buildRow([
                          {'label': 'Nome Responsável', 'controller': widget.nomeResponsavelController, 'flex': 2 , 'enable': false},
                          {'label': 'CPF do responsável', 'controller': widget.cpfResponsavelController, 'enable': false},
                        ]),
                        buildRow([
                          {'label': 'CEP', 'controller': widget.cepStudentController},
                          {'label': 'Endereço', 'controller': widget.enderecoStudentController, 'flex': 2},
                          {'label': 'Bairro', 'controller': widget.bairroStudentController},
                        ]),
                        buildRow([
                          {'label': 'Complemento', 'controller': widget.complementoStudentController},
                          {'label': 'Número', 'controller': widget.numeroStudentController},
                          {'label': 'Cidade', 'controller': widget.cidadeStudentController},
                          {'label': 'Uf', 'controller': widget.ufStudentController},
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
