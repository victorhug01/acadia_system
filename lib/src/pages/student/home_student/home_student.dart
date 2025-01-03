import 'package:acadia/src/components/appbar/appbar_component.dart';
import 'package:acadia/src/pages/student/components/anamnese/anamnese_componente.dart';
import 'package:acadia/src/pages/student/components/contrato/contrato_component.dart';
import 'package:acadia/src/pages/student/components/responsible/responsible_component.dart';
import 'package:acadia/src/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeStudent extends StatefulWidget {
  final String? idStudent;
  const HomeStudent({super.key, this.idStudent});

  @override
  State<HomeStudent> createState() => _HomeStudentState();
}

class _HomeStudentState extends State<HomeStudent> with SingleTickerProviderStateMixin {
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
  // final GlobalKey<FormState> _formKeyS = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyA = GlobalKey<FormState>();
  //anamnese
  final TextEditingController diseaseController = TextEditingController();
  final TextEditingController seriousIllnessController = TextEditingController();
  final TextEditingController surgeryController = TextEditingController();
  final TextEditingController allergyController = TextEditingController();
  final TextEditingController respiratoryController = TextEditingController();
  final TextEditingController dietaryRestrictionController = TextEditingController();
  final TextEditingController allergicReactionController = TextEditingController();
  final TextEditingController vaccineController = TextEditingController();
  final TextEditingController medicalMonitoringController = TextEditingController();
  final TextEditingController dailyMedicationController = TextEditingController();
  final TextEditingController emergencyMedicationController = TextEditingController();
  final TextEditingController emergencyParentescoController = TextEditingController();
  final TextEditingController emergencyPhoneController = TextEditingController();
  final TextEditingController emergencyNameController = TextEditingController();
  final TextEditingController healthPlanController = TextEditingController();

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
                  // StudentComponent(
                  //   formKey: _formKeyS,
                  //   nameStudentController: nameStudentController,
                  //   emailStudentController: emailStudentController,
                  //   cpfStudentController: cpfStudentController,
                  //   rgStudentController: rgStudentController,
                  //   celularStudentController: celularStudentController,
                  //   enderecoStudentController: enderecoStudentController,
                  //   numeroStudentController: numeroStudentController,
                  //   cepStudentController: cepStudentController,
                  //   bairroStudentController: bairroStudentController,
                  //   cidadeStudentController: cidadeStudentController,
                  //   ufStudentController: ufStudentController,
                  //   complementoStudentController: complementoStudentController,
                  //   dataNacimentoStudentController: dataNacimentoStudentController,
                  //   escolaAnteriorController: escolaAnteriorController,
                  //   raStudentController: raStudentController,
                  //   sexoStudentController: sexoStudentController,
                  //   cpfResponsavelController: cpfController,
                  //   nomeResponsavelController: nameController,
                  // ),
                  HealthFormComponent(
                    formKey: _formKeyA,
                    allergicReactionController: allergicReactionController,
                    allergyController: allergyController,
                    dailyMedicationController: dailyMedicationController,
                    dietaryRestrictionController: dietaryRestrictionController,
                    diseaseController: diseaseController,
                    emergencyMedicationController: emergencyMedicationController,
                    emergencyNameController: emergencyNameController,
                    emergencyParentescoController: emergencyParentescoController,
                    emergencyPhoneController: emergencyPhoneController,
                    healthPlanController: healthPlanController,
                    medicalMonitoringController: medicalMonitoringController,
                    respiratoryController: respiratoryController,
                    seriousIllnessController: seriousIllnessController,
                    surgeryController: surgeryController,
                    vaccineController: vaccineController,
                  ),
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
            _tabController.index == 3
                ? const SizedBox.shrink()
                : ButtonComponent(
                    onpress: () {
                      _nextTab();
                    },
                    text: 'Avancar',
                  ),
            // ElevatedButton(
            //   onPressed: (){
            //     final String nome = nameController.text;
            //     final String email = emailController.text;
            //     final String cpf = cpfController.text;
            //     final String rg = rgController.text;
            //     final String celular= celularController.text;
            //     final String endereco = enderecoController.text;
            //     final String numero = numeroController.text;
            //     final String bairro = bairroController.text;
            //     final String cidade = cidadeController.text;
            //     final String uf = ufController.text;
            //     final String cep = cepController.text;
            //     final String complemento = complementoController.text;
            //     createResponsible(
            //       cep: cep,
            //       nome: nome,
            //       email: email,
            //       cpf: cpf,
            //       rg: rg,
            //       celular: celular,
            //       endereco: endereco,
            //       numero: numero,
            //       bairro: bairro,
            //       cidade: cidade,
            //       uf: uf,
            //       complemento: complemento
            //     );
            //   },
            //   child: const Text('Enviar')
            // ),

            //--------------------anamnese------------------------------------

            // ElevatedButton(
            //   onPressed: (){
            //     final String doencaCronica = diseaseController.text == '' ? 'Não informado' : diseaseController.text;
            //     final String doencaGrave = seriousIllnessController.text == '' ? 'Não informado' : seriousIllnessController.text;
            //     final String cirurgia = surgeryController.text == '' ? 'Não informado' : surgeryController.text;
            //     final String problemasRespiratorios = respiratoryController.text == '' ? 'Não informado' : respiratoryController.text;
            //     final String reacaoAlergicaSevera = allergicReactionController.text == '' ? 'Não informado' : allergicReactionController.text;
            //     final String vacinas = vaccineController.text == '' ? 'Não informado' : vaccineController.text;
            //     final String acompanhamentoMedico = medicalMonitoringController.text == '' ? 'Não informado' : medicalMonitoringController.text;
            //     final String medicamentoPeriodico = dailyMedicationController.text == '' ? 'Não informado' : dailyMedicationController.text;
            //     final String medicamentosEmergenciais = emergencyMedicationController.text == '' ? 'Não informado' : emergencyMedicationController.text;
            //     final String nomeParentesco = emergencyNameController.text == '' ? 'Não informado' : emergencyNameController.text;
            //     final String restricaoAlimentar = dietaryRestrictionController.text == '' ? 'Não informado' : dietaryRestrictionController.text;
            //     final int telefone = emergencyPhoneController.value.text == '' ? 00000000000 : int.parse(emergencyPhoneController.text);
            //     final String parentesco = emergencyParentescoController.text == '' ? 'Não informado' : emergencyParentescoController.text;
            //     final String qualPlano = healthPlanController.text == '' ? 'Não informado' : healthPlanController.text;
            //     final String alergia = allergyController.text == '' ? 'Não informado' : allergyController.text;
            //     createAnaminese(
            //       acompanhamentoMedico: acompanhamentoMedico,
            //       alergia: alergia,
            //       cirurgia: cirurgia,
            //       doencaCronica: doencaCronica,
            //       doencaGrave: doencaGrave,
            //       medicamentoPeriodico: medicamentoPeriodico,
            //       medicamentosEmergenciais: medicamentosEmergenciais,
            //       nomeParentesco: nomeParentesco,
            //       parentesco: parentesco,
            //       problemasRespiratorios: problemasRespiratorios,
            //       reacaoAlergicaSevera: reacaoAlergicaSevera,
            //       restricaoAlimentar: restricaoAlimentar,
            //       telefone: telefone,
            //       qualPlano: qualPlano,
            //       vacinas: vacinas
            //     );
            //   },
            //   child: const Text('Enviar')
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> createResponsible({
    required String nome,
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
    required String complemento,
  }) async {
    try {
      final sm = ScaffoldMessenger.of(context);
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
        sm.showSnackBar(
          const SnackBar(content: Text('Postagem criada com sucesso!')),
        );
      } else {
        sm.showSnackBar(
          SnackBar(content: Text('Erro ao criar postagem: ${newUser.error!.message}')),
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

//------------------------------------------------------------------

  // Future<void> createAnaminese({
  //     required String doencaCronica,
  //     required String doencaGrave,
  //     required String cirurgia,
  //     required String problemasRespiratorios,
  //     required String reacaoAlergicaSevera,
  //     required String vacinas,
  //     required String acompanhamentoMedico,
  //     required String medicamentoPeriodico,
  //     required String medicamentosEmergenciais,
  //     required String nomeParentesco,
  //     required String restricaoAlimentar,
  //     required int telefone,
  //     required String parentesco,
  //     required String qualPlano,
  //     required String alergia,
  //   }) async {
  //   try {
  //     final sm = ScaffoldMessenger.of(context);
  //     final newAnamnese = await Supabase.instance.client.from('Anamnese').insert({
  //         'fk_id_aluno': 2,
  //         'doenca_cronica': doencaCronica,
  //         'doenca_grave': doencaGrave,
  //         'cirurgia': cirurgia,
  //         'problemas_respiratorios': problemasRespiratorios,
  //         'restricao_alimentar': restricaoAlimentar,
  //         'reacao_alergica_severa': reacaoAlergicaSevera,
  //         'vacinas': vacinas,
  //         'acompanhamento_medico': acompanhamentoMedico,
  //         'medicamento_periodico': medicamentoPeriodico,
  //         'medicamentos_emergenciais': medicamentosEmergenciais,
  //         'nome_parentesco': nomeParentesco,
  //         'telefone': telefone,
  //         'parentesco': parentesco,
  //         'qual_plano': qualPlano,
  //         'alergia': alergia,
  //       });
  //       if (newAnamnese.error == null) {
  //       sm.showSnackBar(
  //         const SnackBar(content: Text('Anamnese criada com sucesso!')),
  //       );
  //     } else {
  //       sm.showSnackBar(
  //         SnackBar(
  //             content:
  //               Text('Erro ao criar Anamnese: ${newAnamnese.error!.message}')
  //           ),
  //       );
  //     }
  //   }catch(e){
  //     // ignore: avoid_print
  //     print(e);
  //   }
  // }
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
