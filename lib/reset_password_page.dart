import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:quick_task/header.dart';
import 'message.dart';
import 'helpers.dart';
import 'login_page.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() {
    return _ResetPasswordPageState();
  }
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final controllerEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const Header(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 26,
              ),
              Center(
                  child: Text('Reset Password',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: bgColor))),
              const SizedBox(
                height: 16,
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
                height: 40,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(bgColor),
                  ),
                  onPressed: () => doUserResetPassword(),
                  child: const Text(
                    'Reset Password',
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
        ));
  }

  void doUserResetPassword() async {
    final ParseUser user = ParseUser(null, null, controllerEmail.text.trim());
    final ParseResponse parseResponse = await user.requestPasswordReset();
    if (parseResponse.success) {
      Message.showSuccess(
          context: context,
          message: 'Password reset instructions have been sent to email!',
          onPressed: () {
            Navigator.of(context).pop();
          });
    } else {
      Message.showError(
          context: context, message: parseResponse.error!.message);
    }
  }

  void navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
