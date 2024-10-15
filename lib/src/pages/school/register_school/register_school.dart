import 'package:acadia/src/components/appbar/appbar_component.dart';
import 'package:acadia/src/responsive/display_responsive.dart';
import 'package:acadia/src/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class RegisterSchool extends StatefulWidget {
  const RegisterSchool({super.key});

  @override
  State<RegisterSchool> createState() => _RegisterSchoolState();
}

class _RegisterSchoolState extends State<RegisterSchool> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              SizedBox(
                height: 80.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Escolas',
                          style: TextStyle(
                              color: ColorSchemeManagerClass.colorPrimary,
                              fontWeight: FontWeight.w900,
                              fontSize: 20.0),
                        ),
                        Text(
                          'Veja todas as escolas cadastradas no sistema',
                          style: TextStyle(
                              color: ColorSchemeManagerClass.colorPrimary,
                              fontWeight: FontWeight.w400,
                              fontSize: 16.0),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15.0),
                        elevation: 0.0,
                        backgroundColor: ColorSchemeManagerClass.colorPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: Dialog(
                                child: SizedBox(
                                  width: responsive.width * 1.2,
                                  height: 400,
                                  child: const Column(),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            HugeIcons.strokeRoundedAdd01,
                            color: ColorSchemeManagerClass.colorWhite,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Novo escola',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w800,
                              color: ColorSchemeManagerClass.colorWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.maxFinite,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                    color: ColorSchemeManagerClass.colorPrimary,
                    width: 3.0,
                    style: BorderStyle.solid,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
