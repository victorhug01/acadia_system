import 'package:acadia/src/theme/theme_colors.dart';
import 'package:flutter/material.dart';

class TextFormFieldComponent extends StatefulWidget {
  final String? labelText;
  final Widget? iconPrefix;
  final IconButton? iconSuffix;
  final bool obscure;
  final bool autofocus;
  final String? Function(String?)? validator;
  final TextInputType inputType;
  final TextEditingController controller;
  final InputBorder inputBorderType;
  final double sizeInputBorder;
  final Color? colorBorderInput;
  final double? paddingLeftInput;

  const TextFormFieldComponent({
    super.key,
    required this.controller,
    this.labelText,
    this.validator,
    required this.inputType,
    required this.obscure,
    this.iconPrefix,
    this.iconSuffix,
    required this.autofocus,
    required this.inputBorderType,
    required this.sizeInputBorder,
    this.colorBorderInput,
    this.paddingLeftInput,
  });

  @override
  State<TextFormFieldComponent> createState() => _TextFormFieldComponentState();
}

class _TextFormFieldComponentState extends State<TextFormFieldComponent> {
  @override
  Widget build(BuildContext context) {
    final borderSideStyle = widget.inputBorderType.copyWith(
      borderSide: BorderSide(
        color: widget.colorBorderInput ?? ColorSchemeManagerClass.colorPrimary,
        width: widget.sizeInputBorder,
      ),
    );
    return TextFormField(
      autofocus: widget.autofocus,
      keyboardType: widget.inputType,
      obscureText: widget.obscure,
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: widget.iconPrefix,
        suffixIcon: widget.iconSuffix,
        labelText: widget.labelText,
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: widget.paddingLeftInput ?? 0.0),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
        enabledBorder: borderSideStyle,
        focusedBorder: borderSideStyle,
        border: borderSideStyle,
        errorStyle: const TextStyle(height: 1.1),
        helperText: ' '
      ),
      validator: widget.validator,
    );
  }
}
