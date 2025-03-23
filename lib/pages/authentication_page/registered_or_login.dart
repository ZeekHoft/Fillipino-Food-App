import 'package:flilipino_food_app/pages/authentication_page/login_page.dart';
import 'package:flilipino_food_app/pages/authentication_page/signup_page.dart';
import 'package:flutter/material.dart';

class RegisteredOrLogin extends StatefulWidget {
  const RegisteredOrLogin({super.key});

  @override
  State<RegisteredOrLogin> createState() => _RegisteredOrLoginState();
}

class _RegisteredOrLoginState extends State<RegisteredOrLogin> {
  bool showLoginPage = true;
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return SignupPage(onTap: togglePages);
    }
  }
}
