import 'package:acadia/src/components/textformfields/field_component.dart';
import 'package:flutter/material.dart';

class ResponsibleComponent extends StatelessWidget {
  final TextEditingController controller;
  const ResponsibleComponent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800,
      height: 800,
      child: Form(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormFieldComponent(
                  controller: controller,
                  labelText: 'Nome completo *',
                  inputType: TextInputType.text,
                  obscure: false,
                  autofocus: true,
                ),
                TextFormFieldComponent(
                  controller: controller,
                  labelText: 'Email *',
                  inputType: TextInputType.text,
                  obscure: false,
                  autofocus: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextFormFieldComponent(
                      controller: controller,
                      labelText: 'CPF: *',
                      inputType: TextInputType.text,
                      obscure: false,
                      autofocus: true,
                    ),
                    TextFormFieldComponent(
                      controller: controller,
                      labelText: 'RG *',
                      inputType: TextInputType.text,
                      obscure: false,
                      autofocus: true,
                    ),
                    TextFormFieldComponent(
                      controller: controller,
                      labelText: 'Celular *',
                      inputType: TextInputType.number,
                      obscure: false,
                      autofocus: true,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
