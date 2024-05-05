import 'package:flutter/material.dart';

String capitalizeName(String name) {
  List<String> nameParts = name.split(' ');
  List<String> capitalizedParts = nameParts.map((part) {
    if (part.isEmpty) {
      return ''; // Handle empty parts
    }
    return part.substring(0, 1).toUpperCase() + part.substring(1);
  }).toList();
  return capitalizedParts.join(' ');
}

Color bgColor = const Color.fromRGBO(1, 20, 52, 1);
Color headerTextColor = const Color.fromARGB(255, 232, 227, 214);
