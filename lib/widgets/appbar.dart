import 'package:flutter/material.dart';
import 'package:lg_pilot/utils/colors.dart';

class AppBarPilot extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppBarPilot({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: ThemeColors.primaryTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: ThemeColors.backgroundColor,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
