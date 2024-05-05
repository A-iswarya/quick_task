import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:quick_task/header.dart';
import 'message.dart';
import 'sign_up_page.dart';
import 'reset_password_page.dart';
import 'user_page.dart';
import 'helpers.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  bool isLoggedIn = false;

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
                child: Text('Login',
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
                    enabled: !isLoggedIn,
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
                  controller: controllerPassword,
                  enabled: !isLoggedIn,
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
                  onPressed: isLoggedIn ? null : () => doUserLogin(),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              InkWell(
                onTap: () => navigateToResetPassword(),
                child: const Center(
                    child: Text(
                  'Forgot Username?',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                )),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                  child: Center(
                child: Text(
                  "Don't have an account yet?",
                  style: TextStyle(color: bgColor, fontSize: 15),
                ),
              )),
              InkWell(
                onTap: isLoggedIn ? null : () => navigateToSignUp(),
                child: const Center(
                    child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Color.fromARGB(255, 238, 187, 5),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }

  void doUserLogin() async {
    final username = controllerUsername.text.trim();
    final password = controllerPassword.text.trim();

    final user = ParseUser(username, password, null);

    var response = await user.login();

    if (response.success) {
      navigateToUser();
    } else {
      Message.showError(context: context, message: response.error!.message);
    }
  }

  void navigateToUser() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const UserPage()),
      (Route<dynamic> route) => false,
    );
  }

  void navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  void navigateToResetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResetPasswordPage()),
    );
  }
}
