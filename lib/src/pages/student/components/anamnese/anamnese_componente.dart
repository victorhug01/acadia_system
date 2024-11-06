import 'package:acadia/src/theme/theme_colors.dart';
import 'package:flutter/material.dart';

class HealthFormComponent extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController diseaseController;
  final TextEditingController seriousIllnessController;
  final TextEditingController surgeryController;
  final TextEditingController allergyController;
  final TextEditingController respiratoryController;
  final TextEditingController dietaryRestrictionController;
  final TextEditingController allergicReactionController;
  final TextEditingController vaccineController;
  final TextEditingController medicalMonitoringController;
  final TextEditingController dailyMedicationController;
  final TextEditingController emergencyMedicationController;
  final TextEditingController emergencyParentescoController;
  final TextEditingController emergencyPhoneController;
  final TextEditingController emergencyNameController;
  final TextEditingController healthPlanController;
  const HealthFormComponent({
    super.key, 
    required this.diseaseController, 
    required this.seriousIllnessController, 
    required this.surgeryController, 
    required this.allergyController, 
    required this.respiratoryController, 
    required this.dietaryRestrictionController, 
    required this.allergicReactionController, 
    required this.vaccineController, 
    required this.medicalMonitoringController, 
    required this.dailyMedicationController, 
    required this.emergencyMedicationController, 
    required this.emergencyParentescoController, 
    required this.emergencyPhoneController,
    required this.emergencyNameController, 
    required this.healthPlanController, required this.formKey,
    });

  @override
  State<HealthFormComponent> createState() => _HealthFormComponentState();
}

class _HealthFormComponentState extends State<HealthFormComponent> {
  // Controladores de texto

  // Estados para checkboxes
  bool hasDisease = false;
  bool hasSeriousIllness = false;
  bool hasSurgery = false;
  bool hasAllergy = false;
  bool hasRespiratoryProblems = false;
  bool hasDietaryRestriction = false;
  bool hasAllergicReaction = false;
  bool isVaccinated = false;
  bool hasMedicalMonitoring = false;
  bool takesDailyMedication = false;
  bool needsEmergencyMedication = false;
  bool hasHealthPlan = false;
  bool allowsEmergencyActions = false;

  // @override
  // void dispose() {
  //   // Libera os controladores
  //   widget.diseaseController.dispose();
  //   widget.seriousIllnessController.dispose();
  //   widget.surgeryController.dispose();
  //   widget.allergyController.dispose();
  //   widget.respiratoryController.dispose();
  //   widget.dietaryRestrictionController.dispose();
  //   widget.allergicReactionController.dispose();
  //   widget.vaccineController.dispose();
  //   widget.medicalMonitoringController.dispose();
  //   widget.dailyMedicationController.dispose();
  //   widget.emergencyMedicationController.dispose();
  //   widget.emergencyParentescoController.dispose();
  //   widget.emergencyPhoneController.dispose();
  //   widget.healthPlanController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Histórico de Saúde", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            buildHealthQuestion("O aluno apresenta alguma doença crônica?", hasDisease, widget.diseaseController, (value) => setState(() => hasDisease = value!)),
            buildHealthQuestion("O aluno já teve alguma doença grave?", hasSeriousIllness, widget.seriousIllnessController, (value) => setState(() => hasSeriousIllness = value!)),
            buildHealthQuestion("O aluno já foi submetido a alguma cirurgia?", hasSurgery, widget.surgeryController, (value) => setState(() => hasSurgery = value!)),
            buildHealthQuestion("O aluno possui alguma alergia?", hasAllergy, widget.allergyController, (value) => setState(() => hasAllergy = value!)),
            buildHealthQuestion("O aluno tem problemas respiratórios?", hasRespiratoryProblems, widget.respiratoryController, (value) => setState(() => hasRespiratoryProblems = value!)),
            buildHealthQuestion("O aluno tem alguma restrição alimentar?", hasDietaryRestriction, widget.dietaryRestrictionController, (value) => setState(() => hasDietaryRestriction = value!)),
            buildHealthQuestion("O aluno já sofreu alguma reação alérgica severa?", hasAllergicReaction, widget.allergicReactionController, (value) => setState(() => hasAllergicReaction = value!)),
            buildHealthQuestion("Vacinas em dia?", isVaccinated, widget.vaccineController, (value) => setState(() => isVaccinated = value!)),
            buildHealthQuestion("O aluno faz acompanhamento médico periódico?", hasMedicalMonitoring, widget.medicalMonitoringController, (value) => setState(() => hasMedicalMonitoring = value!)),
            buildHealthQuestion("O aluno faz uso de algum medicamento no dia a dia?", takesDailyMedication, widget.dailyMedicationController, (value) => setState(() => takesDailyMedication = value!)),
            buildHealthQuestion("O aluno tem alguma condição que exija o uso de medicamentos emergenciais?", needsEmergencyMedication, widget.emergencyMedicationController, (value) => setState(() => needsEmergencyMedication = value!), showExtraHint: true),
            const SizedBox(height: 16),
            const Text("Informações de Emergência", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 80,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: buildEmergencyInfoField("Parentesco", widget.emergencyParentescoController),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: SizedBox(
                      child: buildEmergencyInfoField("Nome", widget.emergencyNameController),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: SizedBox(
                      child: buildEmergencyInfoField("Telefone", widget.emergencyPhoneController),
                    ),
                  ),
                ],
              ),
            ),
            CheckboxListTile(
              activeColor: ColorSchemeManagerClass.colorPrimary,
              side: BorderSide(
              color: ColorSchemeManagerClass.colorPrimary,
              width: 2.0
              ),
              title: Text(
                "O aluno possui plano de saúde?",
                style: TextStyle(
                color: ColorSchemeManagerClass.colorPrimary,
                fontWeight: FontWeight.w500,
                ),
              ),
              value: hasHealthPlan,
              onChanged: (value) => setState(() => hasHealthPlan = value!),
            ),
            if (hasHealthPlan) 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: buildEmergencyInfoField("Se sim, qual o nome do plano?", widget.healthPlanController),
            ),
            CheckboxListTile(
              activeColor: ColorSchemeManagerClass.colorPrimary,
              side: BorderSide(
              color: ColorSchemeManagerClass.colorPrimary,
              width: 2.0
              ),
              title: Text(
                "Autoriza a escola a tomar providências médicas em caso de emergência?",
                style: TextStyle(
                color: ColorSchemeManagerClass.colorPrimary,
                fontWeight: FontWeight.w500,
                ),
              ),
              value: allowsEmergencyActions,
              onChanged: (value) => setState(() => allowsEmergencyActions = value!),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget buildHealthQuestion(String question, bool checkboxValue, TextEditingController controller, ValueChanged<bool?> onChanged, {bool showExtraHint = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          title: Text(
            question,
            style: TextStyle(
              color: ColorSchemeManagerClass.colorPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          value: checkboxValue,
          onChanged: onChanged,
          activeColor: ColorSchemeManagerClass.colorPrimary,
          side: BorderSide(
            color: ColorSchemeManagerClass.colorPrimary,
            width: 2.0
          ),
        ),
        if (checkboxValue)
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(labelText: showExtraHint ? "Especifique e informe horários:" : "Se sim, qual(is)?"),
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget buildEmergencyInfoField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const UnderlineInputBorder(),
        ),
      ),
    );
  }
}
