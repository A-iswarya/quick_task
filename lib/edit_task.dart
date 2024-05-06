import 'package:flutter/material.dart';
import 'helpers.dart';

class EditTask extends StatelessWidget {
  final TextEditingController updateTitleController;
  final TextEditingController updateDueDateController;
  final String title;
  final String dueDate;
  final String? taskId;
  final Function(String?) updateTask;

  const EditTask(
      {required this.updateTitleController,
      required this.updateDueDateController,
      required this.title,
      required this.dueDate,
      required this.taskId,
      required this.updateTask,
      super.key});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text('Edit'),
      onPressed: () {
        updateTitleController.text = title;
        updateDueDateController.text = dueDate;
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                      child: Text('Edit Task',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold))),
                  TextFormField(
                    controller: updateTitleController,
                    // initialValue:
                    //     title,
                    decoration: const InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(fontSize: 15)),
                  ),
                  TextFormField(
                    controller: updateDueDateController,
                    // initialValue:
                    //     dueDate,
                    decoration: InputDecoration(
                        labelText: 'Due Date',
                        labelStyle: const TextStyle(fontSize: 15),
                        helperText: 'Must be in the format: dd/mm/yyyy',
                        helperStyle: TextStyle(color: bgColor)),
                  ),
                  const SizedBox(height: 16),
                  Center(
                      child: ElevatedButton(
                    onPressed: () {
                      updateTask(taskId);
                      Navigator.pop(context); // Close the modal
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(bgColor)),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ))
                ],
              ),
            ); // Pass the task to the modal
          },
        );
      },
    );
  }
}
