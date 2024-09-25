import 'package:acadia/src/components/textformfields/field_component.dart';
import 'package:acadia/src/responsive/display_responsive.dart';
import 'package:acadia/src/theme/theme_colors.dart';
import 'package:acadia/src/validations/mixin_validation.dart';
import 'package:animate_do/animate_do.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with ValidationMixinClass {
  final GlobalKey<FormState> _keyForm = GlobalKey();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailRecoveryController = TextEditingController();
  final client = Supabase.instance.client;

  // Variável para controlar a visibilidade da senha
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            child: ListView(
              shrinkWrap: false,
              scrollDirection: Axis.vertical,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Container(
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FadeInDown(
                                                duration: const Duration(milliseconds: 600),
                                                child: Image.asset('assets/images/a_logo.png', width: 150),
                                              ),
                                              FadeInUp(
                                                duration: const Duration(milliseconds: 600),
                                                child: const Text(
                                                  'Bem-vindo(a) à Acadia',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              FadeInUp(
                                                duration: const Duration(milliseconds: 400),
                                                child: const Text(
                                                  'Sua nova plataforma de aprendizado e gerenciamento acadêmico.',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              FadeInUp(
                                                duration: const Duration(milliseconds: 450),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Divider(
                                                        color: ColorSchemeManagerClass.colorPrimary,
                                                      ),
                                                    ),
                                                    const Padding(
                                                      padding: EdgeInsets.all(8.0),
                                                      child: Text(
                                                        "Entrar",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Divider(
                                                        color: ColorSchemeManagerClass.colorPrimary,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              FadeInUp(
                                                duration: const Duration(milliseconds: 500),
                                                child: TextFormFieldComponent(
                                                  obscure: false,
                                                  controller: emailController,
                                                  inputType: TextInputType.emailAddress,
                                                  labelText: 'Email',
                                                  validator: (value) =>
                                                      EmailValidator.validate(value.toString()) ? null : "Email inválido",
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              FadeInUp(
                                                duration: const Duration(milliseconds: 600),
                                                child: TextFormFieldComponent(
                                                  controller: passwordController,
                                                  inputType: TextInputType.text,
                                                  labelText: 'Senha',
                                                  iconSuffix: IconButton(
                                                    onPressed: () {
                                                      // Alterna a visibilidade da senha
                                                      setState(() {
                                                        _isPasswordVisible = !_isPasswordVisible;
                                                      });
                                                    },
                                                    icon: Icon(
                                                      _isPasswordVisible
                                                          ? Icons.visibility
                                                          : Icons.visibility_off,
                                                    ),
                                                  ),
                                                  validator: (value) =>
                                                      combine([
                                                    () => isNotEmpyt(value),
                                                    () => hasSixChars(value),
                                                  ]),
                                                  obscure: !_isPasswordVisible,
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.centerRight,
                                                child: FadeInUp(
                                                  duration: const Duration(milliseconds: 600),
                                                  child: TextButton(
                                                    onPressed: (){
                                                      QuickAlert.show(
                                                        context: context, 
                                                        type: QuickAlertType.info,
                                                        title: 'Recuperação de senha',
                                                        text: 'Digite o email registrado para enviar uma recuperação?',
                                                        cancelBtnText: 'Cancelar',
                                                        showCancelBtn: true,
                                                        confirmBtnText: 'Confirmar',
                                                        onConfirmBtnTap: (){
                                                          client.auth.resetPasswordForEmail(
                                                            emailRecoveryController.value.text,
                                                            redirectTo: ''
                                                          );
                                                        },
                                                        confirmBtnColor: ColorSchemeManagerClass.colorPrimary,
                                                        widget: Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                                                          child: TextFormFieldComponent(
                                                            iconPrefix: const Icon(Icons.email),
                                                            controller: emailRecoveryController, 
                                                            labelText: 'Email registrado', 
                                                            inputType: TextInputType.emailAddress, 
                                                            obscure: false
                                                          ),
                                                        )
                                                      );
                                                    },
                                                    style: const ButtonStyle(
                                                      padding: WidgetStatePropertyAll(EdgeInsets.zero)
                                                    ),
                                                    child: const Text(
                                                      'Esqueci minha senha',
                                                      style: TextStyle(
                                                        decoration: TextDecoration.underline,
                                                        fontWeight: FontWeight.w500
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 35),
                                              FadeInUp(
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      if (_keyForm.currentState!.validate()) {
                                                        final sm = ScaffoldMessenger.of(context);
                                                        final navigation = Navigator.of(context);
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
                                                          final response = await client.auth.signInWithPassword(
                                                              password: passwordController.value.text,
                                                              email: emailController.value.text);
                                                          if (response.user != null) {
                                                            sm.showSnackBar(
                                                              SnackBar(
                                                                backgroundColor: ColorSchemeManagerClass.colorCorrect,
                                                                content: const Text('Login concluído!'),
                                                                duration: const Duration(seconds: 3),
                                                              ),
                                                            );
                                                            await navigation.pushReplacementNamed('/home');
                                                          }
                                                        } catch (e) {
                                                          sm.showSnackBar(
                                                            SnackBar(
                                                              backgroundColor: ColorSchemeManagerClass.colorDanger,
                                                              content: const Text('Email ou senha Inválidos!'),
                                                              duration: const Duration(seconds: 3),
                                                            ),
                                                          );
                                                        } finally {
                                                          navigation.pop();
                                                        }
                                                        _keyForm.currentState!.reset();
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
                                                      'Conectar',
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
                          ),
                        ),
                        (responsive.isMobile ||
                                responsive.isTablet ||
                                responsive.isTabletLarge)
                            ? const SizedBox.shrink()
                            : Expanded(
                                child: SizedBox(
                                  child: Image.asset(
                                    'assets/images/background_login.jpg',
                                    fit: BoxFit.cover,
                                    height: constraints.maxHeight,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
