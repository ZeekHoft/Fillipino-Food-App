import 'package:firebase_auth/firebase_auth.dart';
import 'package:flilipino_food_app/pages/authentication_page/authentication_widgets/credentials.dart';
import 'package:flilipino_food_app/pages/authentication_page/authentication_widgets/register_login_button_text.dart';
import 'package:flilipino_food_app/themse/color_themes.dart';
import 'package:flilipino_food_app/pages/authentication_page/authentication_widgets/sign_in_log_in_button.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  final Function()? onTap;

  const SignupPage({super.key, this.onTap});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void registerUser() async {
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
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: usernameController.text,
          password: passwordController.text,
        );
      } else {
        Navigator.pop(context);

        errorMessage("Passwords don't match");
        return;
      }
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
        child: Column(
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
              height: 10,
            ),
            Credentials(
              controller: confirmPasswordController,
              hintText: "Confirm Password",
              obscureText: true,
            ),
            const SizedBox(
              height: 20,
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       ForgotPassword(
            //         onTap: forgotPassword,
            //       )
            //     ],
            //   ),
            // ),
            const SizedBox(
              height: 50,
            ),
            SignInLogInButton(
              buttonName: "Register",
              onTap: registerUser,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already a member?"),
                RegisterLoginButtonText(
                  onTap: widget.onTap,
                  someText: ' Login Here',
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
