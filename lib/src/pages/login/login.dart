import 'package:acadia/src/components/textformfields/field_component.dart';
import 'package:acadia/src/pages/verify_otp/verify_otp.dart';
import 'package:acadia/src/responsive/display_responsive.dart';
import 'package:acadia/src/theme/theme_colors.dart';
import 'package:acadia/src/validations/mixin_validation.dart';
import 'package:animate_do/animate_do.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final navigation = Navigator.of(context);
    return Scaffold(
      body: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
            signIn();
          }
        },
        child: LayoutBuilder(
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
                          (responsive.isMobile || responsive.isTablet || responsive.isTabletLarge)
                              ? const SizedBox.shrink()
                              : Expanded(
                                  child: Container(
                                    width: constraints.maxWidth,
                                    height: constraints.maxHeight,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [ColorSchemeManagerClass.colorBlack, const Color(0xff4c1a78)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Image.asset(
                                      'assets/images/brand_acadia.png',
                                      width: responsive.width / 3,
                                    ),
                                  ),
                                ),
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
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                FadeInDown(
                                                  duration: const Duration(milliseconds: 600),
                                                  child: Image.asset('assets/images/acadia_write.png', width: 150),
                                                ),
                                                const SizedBox(height: 60),
                                                FadeInUp(
                                                  duration: const Duration(milliseconds: 450),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Divider(
                                                          color: ColorSchemeManagerClass.colorPrimary,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(
                                                          "Entrar",
                                                          style: TextStyle(
                                                            color: ColorSchemeManagerClass.colorPrimary,
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
                                                    inputBorderType: const UnderlineInputBorder(),
                                                    sizeInputBorder: 2.0,
                                                    autofocus: true,
                                                    obscure: false,
                                                    controller: emailController,
                                                    inputType: TextInputType.emailAddress,
                                                    labelText: 'Email',
                                                    validator: (value) => EmailValidator.validate(value.toString()) ? null : "Email inválido",
                                                  ),
                                                ),
                                                const SizedBox(height: 15),
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
                                                    validator: (value) => combine([
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
                                                      onPressed: () {
                                                        QuickAlert.show(
                                                          context: context,
                                                          type: QuickAlertType.custom,
                                                          customAsset: 'assets/images/background.jpg',
                                                          title: 'Recuperação de senha',
                                                          text: 'Digite o email registrado para enviar uma recuperação?',
                                                          cancelBtnText: 'Cancelar',
                                                          showCancelBtn: true,
                                                          confirmBtnText: 'Confirmar',
                                                          onConfirmBtnTap: () async {
                                                            debugPrint(emailRecoveryController.text.trim());
                                                            try {
                                                              await client.auth.resetPasswordForEmail(
                                                                emailRecoveryController.text.trim(),
                                                              );
                                                              navigation.pop(); // Fecha o diálogo após a solicitação
                                                              QuickAlert.show(
                                                                // ignore: use_build_context_synchronously
                                                                context: context,
                                                                type: QuickAlertType.success,
                                                                title: 'Sucesso!',
                                                                text: 'Instruções de recuperação de senha enviadas!',
                                                                barrierDismissible: false,
                                                                confirmBtnText: 'Avançar',
                                                                onConfirmBtnTap: () {
                                                                  navigation.push(
                                                                    MaterialPageRoute(
                                                                      builder: (_) => VerifyOTPPage(emailRecoveryController: emailRecoveryController),
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            } catch (e) {
                                                              navigation.pop(); // Fecha o diálogo
                                                              debugPrint("Erro ao enviar o email: $e"); // Log do erro
                                                              QuickAlert.show(
                                                                // ignore: use_build_context_synchronously
                                                                context: context,
                                                                barrierDismissible: false,
                                                                type: QuickAlertType.error,
                                                                title: 'Erro!',
                                                                text: 'Falha ao enviar o email de recuperação. Verifique se o email está correto ou tente novamente.',
                                                              );
                                                              emailRecoveryController.clear();
                                                            }
                                                          },
                                                          confirmBtnColor: ColorSchemeManagerClass.colorPrimary,
                                                          widget: Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 30.0),
                                                            child: TextFormFieldComponent(inputBorderType: const UnderlineInputBorder(), sizeInputBorder: 2.0, autofocus: true, iconPrefix: const Icon(Icons.email), controller: emailRecoveryController, labelText: 'Email registrado', inputType: TextInputType.emailAddress, obscure: false),
                                                          ),
                                                        );
                                                      },
                                                      style: const ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.zero)),
                                                      child: const Text(
                                                        'Esqueci minha senha',
                                                        style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.w500),
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
                                                        await signIn();
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
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future signIn() async {
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
        final response = await client.auth.signInWithPassword(password: passwordController.value.text, email: emailController.value.text);
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
        _keyForm.currentState!.reset();
        passwordController.clear();
        emailController.clear();
      }
      _keyForm.currentState!.reset();
      emailController.clear();
      passwordController.clear();
    }
  }
}
