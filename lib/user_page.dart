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
  ParseUser? currentUser;
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
                  return Container(
                    alignment: Alignment.topRight,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: RichText(
                              text: TextSpan(
                            text: 'Hi, ',
                            style: const TextStyle(fontSize: 16),
                            children: <TextSpan>[
                              TextSpan(
                                text: capitalizeName(
                                    '${snapshot.data!.username}'),
                                style: const TextStyle(
                                    fontSize: 17,
                                    // fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(238, 24, 0, 1)),
                              )
                            ],
                          )),
                        )
                      ],
                    ),
                  );
              }
            }));
  }
}
