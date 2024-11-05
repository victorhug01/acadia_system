import 'package:flutter/material.dart';

class HealthFormComponent extends StatefulWidget {
  const HealthFormComponent({super.key});

  @override
  State<HealthFormComponent> createState() => _HealthFormComponentState();
}

class _HealthFormComponentState extends State<HealthFormComponent> {
  // Controladores de texto
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
  final TextEditingController emergencyContactController = TextEditingController();
  final TextEditingController emergencyPhoneController = TextEditingController();
  final TextEditingController healthPlanController = TextEditingController();

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

  @override
  void dispose() {
    // Libera os controladores
    diseaseController.dispose();
    seriousIllnessController.dispose();
    surgeryController.dispose();
    allergyController.dispose();
    respiratoryController.dispose();
    dietaryRestrictionController.dispose();
    allergicReactionController.dispose();
    vaccineController.dispose();
    medicalMonitoringController.dispose();
    dailyMedicationController.dispose();
    emergencyMedicationController.dispose();
    emergencyContactController.dispose();
    emergencyPhoneController.dispose();
    healthPlanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Histórico de Saúde", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          buildHealthQuestion("O aluno apresenta alguma doença crônica?", hasDisease, diseaseController, (value) => setState(() => hasDisease = value!)),
          buildHealthQuestion("O aluno já teve alguma doença grave?", hasSeriousIllness, seriousIllnessController, (value) => setState(() => hasSeriousIllness = value!)),
          buildHealthQuestion("O aluno já foi submetido a alguma cirurgia?", hasSurgery, surgeryController, (value) => setState(() => hasSurgery = value!)),
          buildHealthQuestion("O aluno possui alguma alergia?", hasAllergy, allergyController, (value) => setState(() => hasAllergy = value!)),
          buildHealthQuestion("O aluno tem problemas respiratórios?", hasRespiratoryProblems, respiratoryController, (value) => setState(() => hasRespiratoryProblems = value!)),
          buildHealthQuestion("O aluno tem alguma restrição alimentar?", hasDietaryRestriction, dietaryRestrictionController, (value) => setState(() => hasDietaryRestriction = value!)),
          buildHealthQuestion("O aluno já sofreu alguma reação alérgica severa?", hasAllergicReaction, allergicReactionController, (value) => setState(() => hasAllergicReaction = value!)),
          buildHealthQuestion("Vacinas em dia?", isVaccinated, vaccineController, (value) => setState(() => isVaccinated = value!)),
          buildHealthQuestion("O aluno faz acompanhamento médico periódico?", hasMedicalMonitoring, medicalMonitoringController, (value) => setState(() => hasMedicalMonitoring = value!)),
          buildHealthQuestion("O aluno faz uso de algum medicamento no dia a dia?", takesDailyMedication, dailyMedicationController, (value) => setState(() => takesDailyMedication = value!)),
          buildHealthQuestion("O aluno tem alguma condição que exija o uso de medicamentos emergenciais?", needsEmergencyMedication, emergencyMedicationController, (value) => setState(() => needsEmergencyMedication = value!), showExtraHint: true),
          const SizedBox(height: 16),
          const Text("Informações de Emergência", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          buildEmergencyInfoField("Contato de emergência", emergencyContactController),
          buildEmergencyInfoField("Telefone", emergencyPhoneController),
          CheckboxListTile(
            title: const Text("O aluno possui plano de saúde?"),
            value: hasHealthPlan,
            onChanged: (value) => setState(() => hasHealthPlan = value!),
          ),
          if (hasHealthPlan) buildEmergencyInfoField("Se sim, qual o nome do plano?", healthPlanController),
          CheckboxListTile(
            title: const Text("Autoriza a escola a tomar providências médicas em caso de emergência?"),
            value: allowsEmergencyActions,
            onChanged: (value) => setState(() => allowsEmergencyActions = value!),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget buildHealthQuestion(String question, bool checkboxValue, TextEditingController controller, ValueChanged<bool?> onChanged, {bool showExtraHint = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          title: Text(question),
          value: checkboxValue,
          onChanged: onChanged,
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
