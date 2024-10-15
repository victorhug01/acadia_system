import 'package:flutter/material.dart';

class AppBarComponent extends StatelessWidget {
  final Widget? leading;
  final PreferredSize? bottom;
  const AppBarComponent({super.key, this.bottom, this.leading});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      centerTitle: true,
      title: Image.asset(
        'assets/images/acadia_write.png',
        width: 150,
        height: 30,
      ),
      bottom: bottom,
    );
  }
}
