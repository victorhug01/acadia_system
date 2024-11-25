import 'dart:async';

import 'package:acadia/src/components/appbar/appbar_component.dart';
import 'package:acadia/src/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:pinput/pinput.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VerifyOTPPage extends StatefulWidget {
  final TextEditingController? emailRecoveryController;
  const VerifyOTPPage({super.key, this.emailRecoveryController});

  @override
  State<VerifyOTPPage> createState() => _VerifyOTPPageState();
}

final defaultPinTheme = PinTheme(
  width: 56,
  height: 56,
  textStyle: TextStyle(fontSize: 20, color: ColorSchemeManagerClass.colorPrimary, fontWeight: FontWeight.w600),
  decoration: BoxDecoration(
    border: Border.all(color: ColorSchemeManagerClass.colorPrimary),
    borderRadius: BorderRadius.circular(8),
  ),
);

final focusedPinTheme = defaultPinTheme.copyDecorationWith(
  border: Border.all(color: ColorSchemeManagerClass.colorPrimary),
  borderRadius: BorderRadius.circular(20),
);

class _VerifyOTPPageState extends State<VerifyOTPPage> {
  final supabase = Supabase.instance.client;
  final controller = TextEditingController();
  final focusNode = FocusNode();

  bool isResendDisabled = true;
  int countdown = 60;
  String resendText = "Reenviar senha (60s)";
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    setState(() {
      isResendDisabled = true;
      resendText = "Reenviar senha (60s)";
    });

    countdown = 60;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return; // Verifica se o widget ainda está montado
      if (countdown == 0) {
        timer.cancel();
        if (mounted) {
          setState(() {
            isResendDisabled = false;
            resendText = "Reenviar senha";
          });
        }
      } else {
        setState(() {
          countdown--;
          resendText = "Reenviar senha ($countdown s)";
        });
      }
    });
  }

  Future<void> _verifyOTP(String pin) async {
    final navigation = Navigator.of(context);

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      await supabase.auth.verifyOTP(
        email: widget.emailRecoveryController!.text.trim(),
        token: pin,
        type: OtpType.recovery,
      );

      if (!mounted) return; // Verifica se o widget ainda está montado
      navigation.pop(); // Fecha o indicador de carregamento
      navigation.pushReplacementNamed('/alter_password');
    } catch (e) {
      if (!mounted) return;
      navigation.pop(); // Fecha o indicador de carregamento
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Erro"),
          content: const Text("Falha ao verificar o código. Tente novamente."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      controller.clear(); // Limpa o PIN digitado
    }
  }

  Future<void> _resendOTP() async {
    final sm = ScaffoldMessenger.of(context);
    try {
      await supabase.auth.resetPasswordForEmail(
        widget.emailRecoveryController!.text.trim(),
      );
      _startCountdown();
      sm.showSnackBar(
        const SnackBar(content: Text("Código reenviado para o e-mail.")),
      );
    } catch (e) {
      if(!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Erro"),
          content: Text("Falha ao reenviar o código. Tente novamente. \nDetalhes: $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel(); // Cancela o timer
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const length = 6;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBarComponent(
          leading: IconButton(
            onPressed: () async {
              final navigation = Navigator.of(context);
              final client = Supabase.instance.client;
              await client.auth.signOut();
              navigation.pop();
            },
            icon: Icon(Icons.adaptive.arrow_back),
          ),
        ),
      ),
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInUp(
              duration: const Duration(milliseconds: 450),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 400,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Alterar senha",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: ColorSchemeManagerClass.colorPrimary),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            FadeInUp(
              child: SizedBox(
                height: 68,
                child: Pinput(
                  length: length,
                  controller: controller,
                  focusNode: focusNode,
                  defaultPinTheme: defaultPinTheme,
                  onCompleted: _verifyOTP,
                ),
              ),
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 450),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: isResendDisabled ? null : _resendOTP,
                    child: Text(
                      resendText,
                      style: TextStyle(
                        color: isResendDisabled ? Colors.grey : Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
