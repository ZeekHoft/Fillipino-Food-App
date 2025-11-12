// In your authenticate.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flilipino_food_app/pages/authentication_page/load_food_display.dart';
import 'package:flilipino_food_app/pages/authentication_page/registered_or_login.dart';
import 'package:flilipino_food_app/themes/app_theme.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatelessWidget {
  const Authenticate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        // Use the correct type hint
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: DappliProgressIndicator());
          }
          if (snapshot.hasData) {
            // User is logged in, now hand off to the loadfoodisplay
            return const LoadFoodDisplay();
          } else {
            // No user is logged in
            return const RegisteredOrLogin();
          }
        },
      ),
    );
  }
}
