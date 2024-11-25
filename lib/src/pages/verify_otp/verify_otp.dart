import 'package:acadia/src/theme/theme_colors.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
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
  textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
  decoration: BoxDecoration(
    border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
    borderRadius: BorderRadius.circular(8),
  ),
);

final focusedPinTheme = defaultPinTheme.copyDecorationWith(
  border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
  borderRadius: BorderRadius.circular(20),
);

final submittedPinTheme = defaultPinTheme.copyWith();

class _VerifyOTPPageState extends State<VerifyOTPPage> {
  final supabase = Supabase.instance.client;
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  // bool showError = false;
  @override
  Widget build(BuildContext context) {
    final navigation = Navigator.of(context);
    const length = 6;
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      decoration: BoxDecoration(
        color: ColorSchemeManagerClass.colorSecondary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
                                        FadeInUp(
                                duration: const Duration(milliseconds: 450),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Alterar senha",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: ColorSchemeManagerClass.colorPrimary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 80),
                                  ],
                                ),
                              ),
          Center(
            child: SizedBox(
              height: 68,
              child: Pinput(
                length: length,
                controller: controller,
                focusNode: focusNode,
                defaultPinTheme: defaultPinTheme,
                onCompleted: (pin) async {
                  debugPrint(pin);
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
                    await supabase.auth.verifyOTP(
                      email: widget.emailRecoveryController!.text.trim(),
                      token: pin,
                      type: OtpType.recovery,
                    );
                  } catch (e) {
                    debugPrint(e.toString());
                  } finally {
                    navigation.pop();
                  }
                  navigation.pushReplacementNamed('/alter_password');
                },
                focusedPinTheme: defaultPinTheme.copyWith(
                  height: 50,
                  width: 50,
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(
                      color: ColorSchemeManagerClass.colorPrimary,
                    ),
                  ),
                ),
                errorPinTheme: defaultPinTheme.copyWith(
                  decoration: BoxDecoration(
                    color: ColorSchemeManagerClass.colorDanger,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
