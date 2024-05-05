import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:quick_task/login_page.dart';
import 'message.dart';
import 'user_page.dart';

import 'header.dart';
import 'helpers.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() {
    return _SignUpPageState();
  }
}

class _SignUpPageState extends State<SignUpPage> {
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const Header(),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text('Sign Up',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: bgColor)),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                    height: 50,
                    child: TextField(
                      controller: controllerUsername,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      autocorrect: false,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 242, 204),
                        labelStyle: TextStyle(
                            color: bgColor, fontWeight: FontWeight.w300),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: bgColor),
                        ),
                        labelText: 'Username',
                        prefixIcon: Icon(
                          Icons.person_2_sharp,
                          size: 20,
                          color: bgColor, // Change the color as needed
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    height: 50,
                    child: TextField(
                      controller: controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      autocorrect: false,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 242, 204),
                        labelStyle: TextStyle(
                            color: bgColor, fontWeight: FontWeight.w300),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: bgColor),
                        ),
                        labelText: 'Email',
                        prefixIcon: Icon(
                          Icons.email_sharp,
                          size: 20,
                          color: bgColor, // Change the color as needed
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: controllerPassword,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.none,
                    autocorrect: false,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 242, 204),
                        prefixIcon: Icon(
                          Icons.key_rounded,
                          size: 20,
                          color: bgColor, // Change the color as needed
                        ),
                        labelStyle: TextStyle(
                            color: bgColor, fontWeight: FontWeight.w300),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: bgColor)),
                        labelText: 'Password'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(bgColor),
                    ),
                    onPressed: () => doUserRegistration(),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: () => navigateToLogin(),
                  child: Center(
                      child: Text(
                    'Login',
                    style: TextStyle(
                      color: bgColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                )
              ],
            ),
          ),
        ));
  }

  void doUserRegistration() async {
    final username = controllerUsername.text.trim();
    final email = controllerEmail.text.trim();
    final password = controllerPassword.text.trim();

    final user = ParseUser.createUser(username, password, email);

    var response = await user.signUp();

    if (response.success) {
      Message.showSuccess(
          context: context,
          message: 'User created successfully!',
          onPressed: () async {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const UserPage()),
              (Route<dynamic> route) => false,
            );
          });
    } else {
      Message.showError(context: context, message: response.error!.message);
    }
  }

  void navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
