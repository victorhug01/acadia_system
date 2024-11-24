import 'package:acadia/src/components/appbar/appbar_component.dart';
import 'package:acadia/src/components/textformfields/field_component.dart';
import 'package:acadia/src/responsive/display_responsive.dart';
import 'package:acadia/src/theme/theme_colors.dart';
import 'package:acadia/src/validations/mixin_validation.dart';
import 'package:animate_do/animate_do.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SecretariesPage extends StatefulWidget {
  const SecretariesPage({super.key});

  @override
  State<SecretariesPage> createState() => _SecretariesPageState();
}

class _SecretariesPageState extends State<SecretariesPage> with ValidationMixinClass {
  final GlobalKey<FormState> _keyForm = GlobalKey();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailRecoveryController = TextEditingController();
  final client = Supabase.instance.client;
  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    final navigation = Navigator.of(context);
    final responsive = Responsive(context);
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBarComponent(),
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
                                        "Cadastrar secretário",
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
                                  controller: nameController,
                                  inputType: TextInputType.text,
                                  labelText: 'Nome',
                                  validator: isNotEmpyt,
                                ),
                              ),
                              const SizedBox(height: 15),
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
                              const SizedBox(height: 35),
                              FadeInUp(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await signIn();
                                      navigation.pop();
                                      navigation.pushReplacementNamed('/view_secretaries');
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
                                      'Cadastrar',
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
        await adminSignUp(
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        sm.showSnackBar(
          SnackBar(
            backgroundColor: ColorSchemeManagerClass.colorCorrect,
            content: const Text('Cadastro concluído!'),
            duration: const Duration(seconds: 3),
          ),
        );

        await navigation.pushReplacementNamed('/secretaries_register');
      } catch (e) {
        if (e.toString().contains("duplicate key value violates unique constraint")) {
          sm.showSnackBar(
            SnackBar(
              backgroundColor: ColorSchemeManagerClass.colorDanger,
              content: const Text('Este email já está em uso.'),
              duration: const Duration(seconds: 3),
            ),
          );
        } else {
          sm.showSnackBar(
            SnackBar(
              backgroundColor: ColorSchemeManagerClass.colorDanger,
              content: Text('Erro ao cadastrar funcionário: $e'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } finally {
        navigation.pop();
        _keyForm.currentState!.reset();
      }
    }
  }

  Future<void> adminSignUp(String email, String password) async {
    try {
      // Cria um SupabaseClient com a Service Role Key
      final adminClient = SupabaseClient(
        'https://awamsrvpvsysyhflmvei.supabase.co', // URL do Supabase já configurada
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF3YW1zcnZwdnN5c3loZmxtdmVpIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcyMzY1MzkyNCwiZXhwIjoyMDM5MjI5OTI0fQ.tj1xn3SpWtyqRrLGTVmjKwNl0LTBuusRWiyKwy8KymQ', // Service Role Key passada como argumento
      );

      // Usa o client admin para criar o usuário
      final response = await adminClient.auth.admin.createUser(
        AdminUserAttributes(
          email: email,
          password: password,
          emailConfirm: true,
          userMetadata: {
            'display_name': nameController.text.trim(), // Define o nome
          },
        ),
      );

      if (response.user != null) {
        final userId = response.user!.id; // Obtém o ID do usuário criado

        // Agora, insira os dados do usuário na tabela secretaria
        final insertResponse = await adminClient
            .from('secretaria') // Nome da tabela
            .insert({
          'id': userId, // Insere o ID do usuário
          'nome': nameController.text.trim(),
          'email': emailController.text.trim(), // Insere o nome
        });

        if (insertResponse.error == null) {
          debugPrint('Usuário criado e dados inseridos na tabela secretaria com sucesso!');
        } else {
          debugPrint('Erro ao inserir dados na tabela secretaria: ${insertResponse.error!.message}');
        }
      } else {
        debugPrint('Erro na criação do usuário: $response');
      }
    } catch (e) {
      debugPrint('Erro no cadastro: $e');
    }
  }
}
