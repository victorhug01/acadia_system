import 'package:acadia/src/theme/theme_colors.dart';
import 'package:flutter/material.dart';

class ConfettiPage extends StatefulWidget {
  final TextEditingController? nameStudentController;
  const ConfettiPage({super.key, this.nameStudentController});

  @override
  State<ConfettiPage> createState() => _ConfettiPageState();
}

class _ConfettiPageState extends State<ConfettiPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  // Função para simular o delay
  void _startLoading() {
    setState(() {
      _isLoading = true; // Resetando para o início
    });
    final navigation = Navigator.of(context);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) { // Verifica se a tela ainda está montada
        setState(() {
          _isLoading = false; // Quando o tempo expirar, desativa o gif
        });
        navigation.pushReplacementNamed('/options_student');
      }
    });
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
            child: Center(
              child: _isLoading
                  ? Image.asset('assets/gifs/progress.gif') // Exibe o gif enquanto carrega
                  : Container(), // Após o delay, o gif é substituído
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
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
