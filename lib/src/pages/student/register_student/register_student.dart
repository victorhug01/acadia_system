import 'package:acadia/src/components/appbar/appbar_component.dart';
import 'package:acadia/src/pages/student/components/responsible/responsible_component.dart';
import 'package:acadia/src/theme/theme_colors.dart';
import 'package:flutter/material.dart';

class RegisterStudentPage extends StatefulWidget {
  const RegisterStudentPage({super.key});

  @override
  State<RegisterStudentPage> createState() => _RegisterStudentPageState();
}

class _RegisterStudentPageState extends State<RegisterStudentPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController controller = TextEditingController();

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
    _tabController.dispose();
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
                children:  [
                  ResponsibleComponent(controller: controller),
                  const Icon(Icons.directions_transit),
                  const Icon(Icons.directions_bike),
                  const Icon(Icons.menu),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
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
                _nextTab();
              },
              text: _tabController.index == 3 ? 'Gerar contrato e finalizar' : 'Avançar',
            ),
          ],
        ),
      ),
    );
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
          Text(text.toString()),
        ],
      ),
    );
  }
}