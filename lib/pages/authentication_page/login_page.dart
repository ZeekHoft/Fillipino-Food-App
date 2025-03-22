import 'package:firebase_auth/firebase_auth.dart';
import 'package:flilipino_food_app/pages/authentication_page/input_field/credentials.dart';
import 'package:flilipino_food_app/themse/color_themes.dart';
import 'package:flilipino_food_app/widget_designs/forgot_password.dart';
import 'package:flilipino_food_app/widget_designs/sign_in_button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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

      // Dismiss the loading dialog after successful login
      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      // Dismiss the loading dialog before showing error dialog
      if (mounted) {
        Navigator.pop(context);
      }

      if (e.code == 'user-not-found') {
        wrongEmail();
      } else if (e.code == 'wrong-password') {
        wrongPassword();
      }
    }
  }

  void wrongEmail() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("MALI"),
          content: Text("User not found. Please check your email."),
        );
      },
    );
  }

  void wrongPassword() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("Incorrect Password"),
          content: Text("The password you entered is incorrect."),
        );
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
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          const Icon(
            Icons.food_bank,
            size: 100,
          ),
          Credentials(
            controller: usernameController,
            hintText: "Email",
            obscureText: false,
          ),
          const SizedBox(
            height: 10,
          ),
          Credentials(
            controller: passwordController,
            hintText: "Password",
            obscureText: true,
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ForgotPassword(
                  onTap: forgotPassword,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          SignInButton(
            onTap: signInUser,
          ),
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                    child: Divider(
                  thickness: 5,
                  color: AppColors.balckTheme,
                )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("Or sign in another way."),
                ),
                Expanded(
                    child: Divider(
                  thickness: 5,
                  color: AppColors.balckTheme,
                )),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("If not a member,"),
              Text(
                "Register here",
                style: TextStyle(color: Colors.blue),
              )
            ],
          )
        ],
      ),
    ));
  }
}
