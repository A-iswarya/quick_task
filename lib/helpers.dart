import 'package:flutter/material.dart';

// Constants
Color bgColor = const Color.fromRGBO(1, 20, 52, 1);
Color headerTextColor = const Color.fromARGB(255, 232, 227, 214);

// Functions

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

bool isValidDateFormat(String dateString) {
  // Check if the date string matches the format "dd/mm/yyyy"
  final RegExp dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
  if (!dateRegex.hasMatch(dateString)) {
    return false;
  }

  // Split the date string into day, month, and year parts
  List<String> parts = dateString.split('/');
  int day = int.tryParse(parts[0]) ?? 0;
  int month = int.tryParse(parts[1]) ?? 0;
  int year = int.tryParse(parts[2]) ?? 0;

  // Validate day, month, and year ranges
  if (day < 1 || day > 31 || month < 1 || month > 12 || year < 0) {
    return false;
  }

  // Additional validation for February
  if (month == 2) {
    // Leap year check
    bool isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
    if ((isLeapYear && day > 29) || (!isLeapYear && day > 28)) {
      return false;
    }
  }

  // Additional validation for months with 30 days
  if ([4, 6, 9, 11].contains(month) && day > 30) {
    return false;
  }

  // Date string is valid
  return true;
}
