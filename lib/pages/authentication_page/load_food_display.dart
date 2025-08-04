// In a new file: onboarding_gate.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flilipino_food_app/pages/authentication_page/profile_setup.dart';
import 'package:flilipino_food_app/pages/authentication_page/registered_or_login.dart';
import 'package:flilipino_food_app/pages/home_page/home_layout.dart';
import 'package:flutter/material.dart';

class LoadFoodDisplay extends StatelessWidget {
  const LoadFoodDisplay({super.key});

  //THIS WHOLE CODE IS JUST FOR DISPLAYING DATA FOOD
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // This should ideally not be reached if Authenticate is working correctly
      return const RegisteredOrLogin();
    }

    // Use a FutureBuilder to check for the user's profile document
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users_data')
          .doc(user.uid)
          .get(),
      builder: (context, snapshot) {
        // Show a loading indicator while we wait for the data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // If an error occurred, show an error message
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('An error occurred'),
            ),
          );
        }

        // If the snapshot has data AND the document exists, the user has a profile
        if (snapshot.hasData && snapshot.data!.exists) {
          // Profile exists, go to the main app layout
          return const HomeLayout();
        } else {
          // Profile does not exist, navigate to the setup pages
          // We need to pass user info to the setup page
          return ProfileSetup(
            uid: user.uid,
            email: user.email,
            username: user.displayName,
          );
        }
      },
    );
  }
}
