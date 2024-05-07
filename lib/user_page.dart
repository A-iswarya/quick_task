import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:quick_task/edit_task.dart';
import 'package:quick_task/task_details.dart';

import 'message.dart';
import 'login_page.dart';
import 'helpers.dart';
import 'home_header_row.dart';
import 'header.dart';
import 'add_new_task_button.dart';

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
  final updateTitleController = TextEditingController();
  final updateDueDateController = TextEditingController();

  ParseUser? currentUser;

  void addNewTask() async {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Title is empty!"),
        duration: Duration(seconds: 2),
      ));
      titleController.text = '';
      dueDateController.text = '';
      return;
    }

    if (!isValidDateFormat(dueDateController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid due date!"),
        duration: Duration(seconds: 2),
      ));
      titleController.text = '';
      dueDateController.text = '';
      return;
    }
    await saveNewTask(titleController.text, dueDateController.text);
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
                    HeaderRow(userName: '${snapshot.data!.username}'),
                    AddNewTaskButton(
                        titleController: titleController,
                        dueDateController: dueDateController,
                        addNewTask: addNewTask),
                    // const SizedBox(height: 10),
                    Expanded(
                        child: FutureBuilder<List<ParseObject>>(
                            future: getTasks(),
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
                                  if (snapshot.hasError) {
                                    return const Center(
                                      child: Text("Something went wrong!"),
                                    );
                                  }
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                        // padding: EdgeInsets.only(top: 10.0),
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) {
                                          final task = snapshot.data?[index];
                                          final title =
                                              task?.get<String>('title') ?? '';
                                          final dueDate =
                                              task?.get<String>('due_date') ??
                                                  '';
                                          final completed =
                                              task?.get<bool>('completed') ??
                                                  false;

                                          return Card(
                                            color: completed
                                                ? const Color.fromARGB(
                                                    255, 196, 231, 203)
                                                : const Color.fromARGB(
                                                    255, 255, 255, 255),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                TaskDetails(
                                                    title: title,
                                                    dueDate: dueDate,
                                                    completed: completed,
                                                    taskId: task?.objectId!,
                                                    handleCheckboxChange:
                                                        handleCheckboxChange),
                                                Row(
                                                  children: <Widget>[
                                                    EditTask(
                                                        updateTitleController:
                                                            updateTitleController,
                                                        updateDueDateController:
                                                            updateDueDateController,
                                                        title: title,
                                                        dueDate: dueDate,
                                                        taskId: task?.objectId!,
                                                        updateTask: updateTask),
                                                    const Spacer(),
                                                    TextButton(
                                                      child:
                                                          const Text('Delete'),
                                                      onPressed: () async {
                                                        await deleteTask(
                                                            task?.objectId!);
                                                        setState(() {
                                                          const snackBar =
                                                              SnackBar(
                                                            content: Text(
                                                                "Task is deleted!"),
                                                            duration: Duration(
                                                                seconds: 2),
                                                          );
                                                          ScaffoldMessenger.of(
                                                              context)
                                                            ..removeCurrentSnackBar()
                                                            ..showSnackBar(
                                                                snackBar);
                                                        });
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  } else {
                                    return const Center(
                                      child: Text(" "),
                                    );
                                  }
                              }
                            }))
                  ]);
              }
            }));
  }

  Future<void> saveNewTask(String title, String dueDate) async {
    final task = ParseObject('Tasks')
      ..set('title', title)
      ..set('due_date', dueDate)
      ..set('completed', false)
      ..set('user_id', currentUser?.objectId);

    await task.save();
  }

  Future<List<ParseObject>> getTasks() async {
    QueryBuilder<ParseObject> queryTask =
        QueryBuilder<ParseObject>(ParseObject('Tasks'));
    queryTask
      ..whereContains('user_id', currentUser?.objectId ?? '')
      ..orderByDescending('createdAt');
    final ParseResponse apiResponse = await queryTask.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<void> updateCompleted(String? id, bool completed) async {
    var task = ParseObject('Tasks')
      ..objectId = id
      ..set('completed', completed);
    await task.save();
  }

  Future<void> updateTask(String? id) async {
    final title = updateTitleController.text.trim();
    final dueDate = updateDueDateController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Title is empty!"),
        duration: Duration(seconds: 2),
      ));
      return;
    }

    if (!isValidDateFormat(dueDate)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid due date!"),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    final task = ParseObject('Tasks')
      ..objectId = id
      ..set('title', title)
      ..set('due_date', dueDate)
      ..set('user_id', currentUser?.objectId);

    await task.save();
    setState(() {
      titleController.clear();
      dueDateController.clear();
    });
  }

  Future<void> deleteTask(String? id) async {
    var task = ParseObject('Tasks')..objectId = id;
    await task.delete();
  }

  void handleCheckboxChange(bool? value, String? taskId) async {
    if (taskId != null) {
      await updateCompleted(taskId, value ?? false);
      setState(() {
        // Refresh UI
      });
    }
  }
}
