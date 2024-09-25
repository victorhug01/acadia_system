import 'package:acadia/src/theme/theme_colors.dart';
import 'package:flutter/material.dart';

class TextFormFieldComponent extends StatefulWidget {
  final String labelText;
  final Widget? iconPrefix;
  final IconButton? iconSuffix;
  final bool obscure;
  final bool autofocus;
  final String? Function(String?)? validator;
  final TextInputType inputType;
  final TextEditingController controller;
  const TextFormFieldComponent({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    required this.inputType,
    required this.obscure,
    this.iconPrefix,
    this.iconSuffix,
    required this.autofocus,
  });

  @override
  State<TextFormFieldComponent> createState() => _TextFormFieldComponentState();
}

class _TextFormFieldComponentState extends State<TextFormFieldComponent> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: widget.autofocus,
      keyboardType: widget.inputType,
      obscureText: widget.obscure,
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: widget.iconPrefix,
        suffixIcon: widget.iconSuffix,
        border: const UnderlineInputBorder(),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: ColorSchemeManagerClass.colorDanger,
            width: 2,
          ),
        ),
        labelText: widget.labelText,
        labelStyle: const TextStyle(fontWeight: FontWeight.w500),
      ),
      validator: widget.validator,
    );
  }
}
