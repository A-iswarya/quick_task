import 'package:flutter/material.dart';
import 'helpers.dart';

class AddNewTaskButton extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController dueDateController;
  final Function() addNewTask;

  const AddNewTaskButton(
      {required this.titleController,
      required this.dueDateController,
      required this.addNewTask,
      super.key});
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Add Task',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                  TextField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Task Name',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: dueDateController,
                    decoration: InputDecoration(
                        hintText: 'Enter Due Date',
                        helperText: 'Must be in the format: dd/mm/yyyy',
                        helperStyle: TextStyle(color: bgColor)),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Implement add task functionality here
                      addNewTask();
                      Navigator.pop(context); // Close the modal
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(bgColor)),
                    child: const Text(
                      'Add Task',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(Icons.add), Text('Add Task')],
      ),
    );
  }
}
