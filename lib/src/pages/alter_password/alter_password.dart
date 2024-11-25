import 'package:acadia/src/components/appbar/appbar_component.dart';
import 'package:acadia/src/components/textformfields/field_component.dart';
import 'package:acadia/src/responsive/display_responsive.dart';
import 'package:acadia/src/theme/theme_colors.dart';
import 'package:acadia/src/validations/mixin_validation.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AlterPassword extends StatefulWidget {
  const AlterPassword({super.key});

  @override
  State<AlterPassword> createState() => _AlterPasswordState();
}

class _AlterPasswordState extends State<AlterPassword> with ValidationMixinClass {
  final GlobalKey<FormState> _keyForm = GlobalKey();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final client = Supabase.instance.client;
  bool _isPasswordVisible = false;

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'A senha não pode estar vazia';
    } else if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'A confirmação de senha não pode estar vazia';
    } else if (value != passwordController.text) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final navigation = Navigator.of(context);
    final responsive = Responsive(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBarComponent(
          leading: IconButton(
            onPressed: () async {
              final navigation = Navigator.of(context);
              final client = Supabase.instance.client;
              await client.auth.signOut();
              navigation.pop();
            },
            icon: Icon(Icons.adaptive.arrow_back),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: MediaQuery.sizeOf(context).height,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: Container(
              alignment: Alignment.center,
              height: constraints.maxHeight,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: responsive.isMobile ? double.infinity : 450,
                        child: Form(
                          key: _keyForm,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FadeInUp(
                                duration: const Duration(milliseconds: 450),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Alterar senha",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: ColorSchemeManagerClass.colorPrimary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 80),
                                  ],
                                ),
                              ),
                              FadeInUp(
                                duration: const Duration(milliseconds: 600),
                                child: TextFormFieldComponent(
                                  inputBorderType: const UnderlineInputBorder(),
                                  sizeInputBorder: 2.0,
                                  autofocus: true,
                                  controller: passwordController,
                                  inputType: TextInputType.text,
                                  labelText: 'Senha',
                                  iconSuffix: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible = !_isPasswordVisible;
                                      });
                                    },
                                    icon: Icon(
                                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                    ),
                                  ),
                                  validator: validatePassword,
                                  obscure: !_isPasswordVisible,
                                ),
                              ),
                              const SizedBox(height: 15),
                              FadeInUp(
                                duration: const Duration(milliseconds: 600),
                                child: TextFormFieldComponent(
                                  inputBorderType: const UnderlineInputBorder(),
                                  sizeInputBorder: 2.0,
                                  autofocus: true,
                                  controller: confirmPasswordController,
                                  inputType: TextInputType.text,
                                  labelText: 'Confirmar senha',
                                  iconSuffix: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible = !_isPasswordVisible;
                                      });
                                    },
                                    icon: Icon(
                                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                    ),
                                  ),
                                  validator: validateConfirmPassword,
                                  obscure: !_isPasswordVisible,
                                ),
                              ),
                              const SizedBox(height: 35),
                              FadeInUp(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final sm = ScaffoldMessenger.of(context);
                                      if (_keyForm.currentState?.validate() ?? false) {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return const Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          },
                                        );
                                        try {
                                          await client.auth.updateUser(
                                            UserAttributes(password: passwordController.text.trim()),
                                          );
                                          await client.auth.signOut();
                                          await navigation.pushReplacementNamed('/login');
                                        } catch (e) {
                                          debugPrint(e.toString());
                                          // Display some error to the user, maybe a snackbar
                                          sm.showSnackBar(
                                            const SnackBar(content: Text('Erro ao atualizar a senha (A senha deve ser diferente da antiga)')),
                                          );
                                        } finally {
                                          navigation.pop();
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0.0,
                                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                      backgroundColor: ColorSchemeManagerClass.colorPrimary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: Text(
                                      'Alterar',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: ColorSchemeManagerClass.colorWhite,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
