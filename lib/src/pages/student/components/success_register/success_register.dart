import 'package:acadia/src/theme/theme_colors.dart';
import 'package:animate_do/animate_do.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class ConfettiPage extends StatefulWidget {
  final TextEditingController? nameStudentController;
  const ConfettiPage({super.key, this.nameStudentController});

  @override
  State<ConfettiPage> createState() => _ConfettiPageState();
}

class _ConfettiPageState extends State<ConfettiPage> {
  bool isPlaying = false;
  final ConfettiController controller = ConfettiController();

  @override
  void initState() {
    final navigation = Navigator.of(context);
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      navigation.pushReplacementNamed('/options_student');
    });
    controller.play();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
          body: SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeInDown(
                  child: const TextComponente(
                    description: 'Cadastro do aluno',
                  ),
                ),
                FadeInUp(
                  child: const TextComponente(
                    description: 'Realizada com sucesso!',
                  ),
                ),
              ],
            ),
          ),
        ),
        ConfettiWidget(
          confettiController: controller,
          shouldLoop: true,
          blastDirectionality: BlastDirectionality.explosive,
          numberOfParticles: 80,
        ),
      ],
    );
  }
}

class TextComponente extends StatelessWidget {
  final String description;
  const TextComponente({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: TextStyle(
        fontSize: 35,
        color: ColorSchemeManagerClass.colorPrimary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
