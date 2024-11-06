import 'package:acadia/src/components/appbar/appbar_component.dart';
import 'package:acadia/src/pages/student/components/anamnese/anamnese_componente.dart';
import 'package:acadia/src/pages/student/components/contrato/contrato_component.dart';
import 'package:acadia/src/pages/student/components/responsible/responsible_component.dart';
import 'package:acadia/src/pages/student/components/student/student_component.dart';
import 'package:acadia/src/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterStudentPage extends StatefulWidget {
  const RegisterStudentPage({super.key});

  @override
  State<RegisterStudentPage> createState() => _RegisterStudentPageState();
}

class _RegisterStudentPageState extends State<RegisterStudentPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controladores para os campos do ResponsibleComponent
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController rgController = TextEditingController();
  final TextEditingController celularController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController ufController = TextEditingController();
  final TextEditingController complementoController = TextEditingController();
  //aluno
  final TextEditingController nameStudentController = TextEditingController();
  final TextEditingController emailStudentController = TextEditingController();
  final TextEditingController cpfStudentController = TextEditingController();
  final TextEditingController rgStudentController = TextEditingController();
  final TextEditingController celularStudentController = TextEditingController();
  final TextEditingController enderecoStudentController = TextEditingController();
  final TextEditingController numeroStudentController = TextEditingController();
  final TextEditingController cepStudentController = TextEditingController();
  final TextEditingController bairroStudentController = TextEditingController();
  final TextEditingController cidadeStudentController = TextEditingController();
  final TextEditingController ufStudentController = TextEditingController();
  final TextEditingController complementoStudentController = TextEditingController();
  final TextEditingController dataNacimentoStudentController = TextEditingController();
  final TextEditingController raStudentController = TextEditingController();
  final TextEditingController escolaAnteriorController = TextEditingController();
  final TextEditingController sexoStudentController = TextEditingController();
  final GlobalKey<FormState> _formKeyR = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyS = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Dispose de todos os controladores ao finalizar a página
    _tabController.dispose();
    nameController.dispose();
    emailController.dispose();
    cpfController.dispose();
    rgController.dispose();
    celularController.dispose();
    enderecoController.dispose();
    numeroController.dispose();
    cepController.dispose();
    bairroController.dispose();
    cidadeController.dispose();
    ufController.dispose();
    complementoController.dispose();
    super.dispose();
  }

  void _nextTab() {
    if (_tabController.index < 3) {
      _tabController.animateTo(_tabController.index + 1);
    }
  }

  void _previousTab() {
    if (_tabController.index > 0) {
      _tabController.animateTo(_tabController.index - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBarComponent(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.adaptive.arrow_back),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(6),
            child: Container(
              height: 6,
              color: ColorSchemeManagerClass.colorPrimary,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ignore pointer use to disable tabs
            TabBar(
              controller: _tabController,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              tabAlignment: TabAlignment.center,
              dividerColor: Colors.transparent,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Responsável'),
                Tab(text: 'Aluno'),
                Tab(text: 'Anamnese'),
                Tab(text: 'Contrato'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ResponsibleComponent(
                    formKey: _formKeyR,
                    nameController: nameController,
                    emailController: emailController,
                    cpfController: cpfController,
                    rgController: rgController,
                    celularController: celularController,
                    enderecoController: enderecoController,
                    numeroController: numeroController,
                    cepController: cepController,
                    bairroController: bairroController,
                    cidadeController: cidadeController,
                    ufController: ufController,
                    complementoController: complementoController,
                  ),
                  StudentComponent(
                    formKey: _formKeyS,
                    nameStudentController: nameStudentController,
                    emailStudentController: emailStudentController,
                    cpfStudentController: cpfStudentController,
                    rgStudentController: rgStudentController,
                    celularStudentController: celularStudentController,
                    enderecoStudentController: enderecoStudentController,
                    numeroStudentController: numeroStudentController,
                    cepStudentController: cepStudentController,
                    bairroStudentController: bairroStudentController,
                    cidadeStudentController: cidadeStudentController,
                    ufStudentController: ufStudentController,
                    complementoStudentController: complementoStudentController,
                    dataNacimentoStudentController: dataNacimentoStudentController,
                    escolaAnteriorController: escolaAnteriorController,
                    raStudentController: raStudentController,
                    sexoStudentController: sexoStudentController,
                    cpfResponsavelController: cpfController,
                    nomeResponsavelController: nameController,
                  ),
                  const HealthFormComponent(),
                  const PdfView()
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _tabController.index == 0
                ? const SizedBox.shrink()
                : ButtonComponent(
                    onpress: () {
                      _previousTab();
                    },
                    text: 'Anterior',
                  ),
            ButtonComponent(
              onpress: () {
                if (_formKeyR.currentState!.validate()) {
                  _nextTab();
                }
              },
              text: _tabController.index == 3
                  ? 'Gerar contrato e finalizar'
                  : 'Avançar',
            ),
            ElevatedButton(
              onPressed: (){
                final String nome = nameController.text;
                final String email = emailController.text;
                final String cpf = cpfController.text;
                final String rg = rgController.text;
                final String celular= celularController.text;
                final String endereco = enderecoController.text;
                final String numero = numeroController.text;
                final String bairro = bairroController.text;
                final String cidade = cidadeController.text;
                final String uf = ufController.text;
                final String cep = cepController.text;
                final String complemento = complementoController.text;
                createResponsible(
                  cep: cep,
                  nome: nome, 
                  email: email, 
                  cpf: cpf, 
                  rg: rg, 
                  celular: celular, 
                  endereco: endereco, 
                  numero: numero,
                  bairro: bairro, 
                  cidade: cidade, 
                  uf: uf, 
                  complemento: complemento
                );
              }, 
              child: const Text('Enviar')
            ),
          ],
        ),
      ),
    );
  }
  Future<void> createResponsible(
      {required String nome,
      required String email,
      required String cpf,
      required String rg,
      required String celular,
      required String endereco,
      required String numero,
      required String bairro,
      required String cidade,
      required String uf,
      required String cep,
      required String complemento,}) async {
    try {
      final newUser = await Supabase.instance.client.from('responsavel').insert({
          'nome': nome,
          'email': email,
          'cpf_responsavel': cpf,
          'rg': rg,
          'cep': cep,
          'celular': celular,
          'endereco': endereco,
          'numero_residencia': numero,
          'bairro': bairro,
          'cidade': cidade,
          'uf_estado': uf,
          'complemento': complemento,
        });
        if (newUser.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Postagem criada com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Erro ao criar postagem: ${newUser.error!.message}')),
        );
      }
    }catch(e){
      // ignore: avoid_print
      print(e);
    }
  }
}

class ButtonComponent extends StatelessWidget {
  final VoidCallback onpress;
  final String text;
  const ButtonComponent({super.key, required this.onpress, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: ColorSchemeManagerClass.colorWhite,
        backgroundColor: ColorSchemeManagerClass.colorPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      onPressed: onpress,
      child: Row(
        children: [
          Text(text),
        ],
      ),
    );
  }
}
