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
    this.colorBorderInput, this.paddingLeftInput,
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
        labelText: widget.labelText,
        isDense:  true,
        contentPadding: EdgeInsets.only(top: 0, left: widget.paddingLeftInput ?? 00.0, bottom: 5, right: 5),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
        enabledBorder: widget.inputBorderType.copyWith(
          borderSide: BorderSide(
            color: widget.colorBorderInput ?? ColorSchemeManagerClass.colorGrey,
            width: widget.sizeInputBorder,
          ),
        ),
        focusedBorder: widget.inputBorderType.copyWith(
          borderSide: BorderSide(
            color:
                widget.colorBorderInput ?? ColorSchemeManagerClass.colorPrimary,
            width: widget.sizeInputBorder,
          ),
        ),
        errorBorder: widget.inputBorderType.copyWith(
          borderSide: BorderSide(
            color: ColorSchemeManagerClass.colorDanger,
            width: widget.sizeInputBorder,
          ),
        ),
        focusedErrorBorder: widget.inputBorderType.copyWith(
          borderSide: BorderSide(
            color: ColorSchemeManagerClass.colorDanger,
            width: widget.sizeInputBorder,
          ),
        ),
      ),
      validator: widget.validator,
    );
  }
}
