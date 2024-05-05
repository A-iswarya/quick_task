import 'package:flutter/material.dart';
import 'package:quick_task/helpers.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> actions;
  const Header({this.actions = const [], super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(
          'Quick Task',
          style: TextStyle(color: headerTextColor),
        ),
        backgroundColor: bgColor,
        actions: actions);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
