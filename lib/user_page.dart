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

                    Expanded(
                        child: FutureBuilder<List<ParseObject>>(
                            future: getTodo(),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  return Center(
                                    child: Container(
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
                                          final varTodo = snapshot.data?[index];
                                          final varTitle =
                                              varTodo?.get<String>('title') ??
                                                  '';
                                          final varDueDate = varTodo
                                                  ?.get<String>('due_date') ??
                                              '';
                                          final varCompleted =
                                              varTodo?.get<bool>('completed') ??
                                                  false;

                                          return Card(
                                            // surfaceTintColor: Colors.amber,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: ListTile(
                                                        title: Text(
                                                            capitalizeTaskTitle(
                                                                varTitle),
                                                            style: TextStyle(
                                                                color:
                                                                    bgColor)),
                                                        subtitle: Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .calendar_month,
                                                              size: 20,
                                                              color: bgColor,
                                                            ), // Calendar icon
                                                            const SizedBox(
                                                                width:
                                                                    5), // Spacer
                                                            Text(
                                                              varDueDate,
                                                              style: TextStyle(
                                                                  color:
                                                                      bgColor),
                                                            ), // Actual subtitle text
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Checkbox(
                                                        activeColor: bgColor,
                                                        value:
                                                            varCompleted, // Set initial checkbox value here
                                                        onChanged:
                                                            (value) async {
                                                          await updateTodo(
                                                              varTodo
                                                                  ?.objectId!,
                                                              value!);
                                                          setState(() {
                                                            //Refresh UI
                                                          });
                                                        }),
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
                                                      child:
                                                          const Text('Delete'),
                                                      onPressed: () async {
                                                        await deleteTodo(
                                                            varTodo?.objectId!);
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

  Future<void> saveTodo(String title, String dueDate) async {
    final todo = ParseObject('Tasks')
      ..set('title', title)
      ..set('due_date', dueDate)
      ..set('completed', false);
    await todo.save();
  }

  Future<List<ParseObject>> getTodo() async {
    QueryBuilder<ParseObject> queryTodo =
        QueryBuilder<ParseObject>(ParseObject('Tasks'));
    final ParseResponse apiResponse = await queryTodo.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<void> updateTodo(String? id, bool done) async {
    var todo = ParseObject('Tasks')
      ..objectId = id
      ..set('done', done);
    await todo.save();
  }

  Future<void> deleteTodo(String? id) async {
    var todo = ParseObject('Tasks')..objectId = id;
    await todo.delete();
  }
}
