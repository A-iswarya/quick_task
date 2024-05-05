import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'message.dart';
import 'login_page.dart';
import 'helpers.dart';

import 'header.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() {
    return _UserPageState();
  }
}

class _UserPageState extends State<UserPage> {
  final titleController = TextEditingController();
  final dueDateController = TextEditingController();

  ParseUser? currentUser;

  void addToDo() async {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Title is empty!"),
        duration: Duration(seconds: 2),
      ));
      return;
    }

    if (!isValidDateFormat(dueDateController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid due date!"),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    await saveTodo(titleController.text, dueDateController.text);
    setState(() {
      titleController.clear();
      dueDateController.clear();
    });
  }

  Future<ParseUser?> getUser() async {
    currentUser = await ParseUser.currentUser() as ParseUser?;
    return currentUser;
  }

  @override
  Widget build(BuildContext context) {
    void doUserLogout() async {
      var response = await currentUser!.logout();
      if (response.success) {
        Message.showSuccess(
            context: context,
            message:
                'You have been successfully logged out. Thank you for using our app!',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false,
              );
            });
      } else {
        Message.showError(context: context, message: response.error!.message);
      }
    }

    return Scaffold(
        appBar: Header(actions: [
          TextButton(
            child: const Text('Logout',
                style: TextStyle(color: Color.fromARGB(255, 232, 227, 214))),
            onPressed: () => doUserLogout(),
          ),
          const Icon(
            Icons.logout_sharp,
            color: Color.fromARGB(255, 232, 227, 214),
            size: 20,
          ),
          const SizedBox(
            width: 40,
          )
        ]),
        body: FutureBuilder<ParseUser?>(
            future: getUser(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Center(
                    child: SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator()),
                  );
                default:
                  return Column(children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'Tasks',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: bgColor,
                                  fontWeight: FontWeight.bold),
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
                                  capitalizeName('${snapshot.data!.username}'),
                                  style: TextStyle(color: bgColor),
                                )
                              ],
                            ))
                      ],
                    ),
                    OutlinedButton(
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
                                  TextField(
                                    textCapitalization:
                                        TextCapitalization.sentences,
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
                                        helperText:
                                            'Must be in the format: dd/mm/yyyy',
                                        helperStyle: TextStyle(color: bgColor)),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Implement add task functionality here
                                      addToDo();
                                      Navigator.pop(context); // Close the modal
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(bgColor)),
                                    child: const Text(
                                      'Add Task',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
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
                    ),
                    // const SizedBox(height: 10),
                    Center(
                      child: Card(
                        // surfaceTintColor: Colors.amber,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              children: [
                                Expanded(
                                  child: ListTile(
                                    title: Text('Complete Assignment',
                                        style: TextStyle(color: bgColor)),
                                    subtitle: Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          size: 20,
                                          color: bgColor,
                                        ), // Calendar icon
                                        const SizedBox(width: 5), // Spacer
                                        Text(
                                          '11/5/2024',
                                          style: TextStyle(color: bgColor),
                                        ), // Actual subtitle text
                                      ],
                                    ),
                                  ),
                                ),
                                Checkbox(
                                  activeColor: bgColor,
                                  value:
                                      true, // Set initial checkbox value here
                                  onChanged: (bool? value) {
                                    // Handle checkbox state change
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                TextButton(
                                  child: const Text('Edit'),
                                  onPressed: () {/* ... */},
                                ),
                                const Spacer(),
                                TextButton(
                                  child: const Text('Delete'),
                                  onPressed: () {/* ... */},
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]);
              }
            }));
  }

  Future<void> saveTodo(String title, String dueDate) async {
    final todo = ParseObject('Tasks')
      ..set('title', title)
      ..set('due_date', dueDate)
      ..set('completed', false);
    await todo.save();
  }
}
