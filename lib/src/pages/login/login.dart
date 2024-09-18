import 'package:acadia/src/components/textformfields/field_component.dart';
import 'package:acadia/src/responsive/display_responsive.dart';
import 'package:acadia/src/theme/theme_colors.dart';
import 'package:acadia/src/validations/mixin_validation.dart';
import 'package:animate_do/animate_do.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with ValidationMixinClass {
  final GlobalKey<FormState> _keyForm = GlobalKey();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
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
                                      width: responsive.isMobile
                                          ? double.infinity
                                          : 450,
                                      child: Form(
                                        key: _keyForm,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(25.0),
                                              child: FadeInDown(
                                                duration: const Duration(milliseconds: 600),
                                                child: Image.asset(
                                                  'assets/images/a_logo.png',
                                                  width: 150,
                                                ),
                                              ),
                                            ),
                                            FadeInUp(
                                              duration: const Duration(
                                                  milliseconds: 600),
                                              child: const Text(
                                                'Bem-vindo(a) à Acadia',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            FadeInUp(
                                              duration: const Duration(
                                                  milliseconds: 400),
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
                                                    color: ColorSchemeManagerClass
                                                        .colorPrimary,
                                                  )),
                                                  const Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text(
                                                      "Entar",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Divider(
                                                      color:
                                                          ColorSchemeManagerClass
                                                              .colorPrimary,
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
                                                inputType:
                                                    TextInputType.emailAddress,
                                                labelText: 'Email',
                                                validator: (value) =>
                                                    EmailValidator.validate(
                                                            value.toString())
                                                        ? null
                                                        : "Email inválido",
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            FadeInUp(
                                              duration: const Duration(milliseconds: 600),
                                              child: TextFormFieldComponent(
                                                controller: passwordController,
                                                inputType: TextInputType.text,
                                                labelText: 'Senha',
                                                validator: (value) => combine([
                                                  () => isNotEmpyt(value),
                                                  () => hasSixChars(value),
                                                ]),
                                                obscure: true,
                                              ),
                                            ),
                                            const SizedBox(height: 35),
                                            FadeInUp(
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  onPressed: () async {},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    elevation: 0.0,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 20,
                                                      horizontal: 10,
                                                    ),
                                                    backgroundColor:
                                                        ColorSchemeManagerClass
                                                            .colorPrimary,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Conectar',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color:
                                                          ColorSchemeManagerClass
                                                              .colorWhite,
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
      }),
    );
  }
}
