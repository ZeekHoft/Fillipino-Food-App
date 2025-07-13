import 'package:firebase_auth/firebase_auth.dart';
import 'package:flilipino_food_app/common_widgets/link_text_button.dart';
import 'package:flilipino_food_app/pages/authentication_page/authentication_widgets/credential_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  void signInUser() async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevents dismissing the dialog by tapping outside
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      errorMessage(e.code);
    }
  }

  void errorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Center(
          child: Text(message),
        ));
      },
    );
  }

  void forgotPassword() {
    print("forgot");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Text("DAPPLI", style: Theme.of(context).textTheme.displayLarge),
              const Icon(
                Icons.food_bank,
                size: 100,
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Hello,",
                    style: Theme.of(context).textTheme.headlineMedium),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Welcome back!",
                    style: Theme.of(context).textTheme.headlineLarge),
              ),
              const SizedBox(height: 24),
              CredentialField(
                controller: usernameController,
                hintText: "Email",
                obscureText: false,
              ),
              const SizedBox(height: 8),
              CredentialField(
                controller: passwordController,
                hintText: "Password",
                obscureText: true,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LinkTextButton(
                    onTap: forgotPassword,
                    text: "Forgot Password",
                  )
                ],
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: signInUser,
                child: const Text("Log In"),
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("Or sign in another way."),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  LinkTextButton(
                    onTap: widget.onTap,
                    text: 'Register Here',
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
