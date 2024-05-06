import 'package:flutter/material.dart';
import 'helpers.dart';

class HeaderRow extends StatelessWidget {
  final String userName;
  const HeaderRow({required this.userName, super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Tasks',
              style: TextStyle(
                  fontSize: 20, color: bgColor, fontWeight: FontWeight.bold),
            )),
        const Spacer(),
        Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Icon(
                  Icons.person_2_outlined,
                  color: bgColor,
                ),
                Text(
                  capitalizeName(userName),
                  style: TextStyle(color: bgColor),
                )
              ],
            ))
      ],
    );
  }
}
