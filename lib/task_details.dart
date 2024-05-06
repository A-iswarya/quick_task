import 'package:flutter/material.dart';
import 'helpers.dart';

class TaskDetails extends StatelessWidget {
  final String title;
  final String dueDate;
  final bool completed;
  final String? taskId;
  final Function(bool?, String) handleCheckboxChange;

  const TaskDetails(
      {required this.title,
      required this.dueDate,
      required this.completed,
      required this.taskId,
      required this.handleCheckboxChange,
      super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            title: Text(title, style: TextStyle(color: bgColor)),
            subtitle: Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  size: 20,
                  color: bgColor,
                ), // Calendar icon
                const SizedBox(width: 5), // Spacer
                Text(
                  dueDate,
                  style: TextStyle(color: bgColor),
                ), // Actual subtitle text
              ],
            ),
          ),
        ),
        Checkbox(
            activeColor: bgColor,
            value: completed, // Set initial checkbox value here
            onChanged: (value) => handleCheckboxChange(value!, taskId!)),
      ],
    );
  }
}
