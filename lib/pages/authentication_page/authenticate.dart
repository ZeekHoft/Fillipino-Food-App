import 'package:firebase_auth/firebase_auth.dart';
import 'package:flilipino_food_app/pages/authentication_page/registered_or_login.dart';
import 'package:flilipino_food_app/pages/authentication_page/signup_page.dart';
import 'package:flilipino_food_app/pages/home_page/home_layout.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatelessWidget {
  const Authenticate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const HomeLayout();
            } else {
              // return const RegisteredOrLogin();
              return const SignupPage();
            }
          }),
    );
  }
}
