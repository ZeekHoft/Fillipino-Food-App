import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flilipino_food_app/common_widgets/link_text_button.dart';
import 'package:flilipino_food_app/pages/authentication_page/allergy_and_dietary/filter_chips_enums.dart';
import 'package:flilipino_food_app/pages/authentication_page/authentication_widgets/credential_field.dart';
import 'package:flilipino_food_app/pages/authentication_page/user_input.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  final Function()? onTap;

  const SignupPage({super.key, this.onTap});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final userNameController = TextEditingController();
  final userCaloricController = TextEditingController();
  //temp data storing for list of allergy
  Set<DietaryRestrictionsFilter> selectedDietaryRestrictions = {};

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
      if (passwordController.text.trim() ==
              confirmPasswordController.text.trim() &&
          userCaloricController.text.trim().isNotEmpty) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        addUserDetails(
            emailController.text.trim(),
            userNameController.text.trim(),
            int.parse(userCaloricController.text.trim()));
      } else if (userCaloricController.text.trim().isEmpty ||
          userNameController.text.trim().isEmpty) {
        Navigator.pop(context);

        errorMessage("Empty Inputs");
        return;
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

  Future addUserDetails(String email, String username, int calorie) async {
    await FirebaseFirestore.instance.collection("users_data").add({
      "email": email,
      "username": username,
      "calories": calorie,
      "allergies": selectedDietaryRestrictions.map((e) => e.name).toList()
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 48,
              ),
              Text(
                "Create an account",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                "Let's help you set up your account, it won't take long.",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 24),

              // Email
              CredentialField(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
              ),
              const SizedBox(height: 10),

              // Username
              CredentialField(
                controller: userNameController,
                hintText: "Username",
                obscureText: false,
              ),
              const SizedBox(height: 10),

              // Pass
              CredentialField(
                controller: passwordController,
                hintText: "Password",
                obscureText: true,
              ),
              const SizedBox(height: 10),
              // Confirm Pass
              CredentialField(
                controller: confirmPasswordController,
                hintText: "Confirm Password",
                obscureText: true,
              ),

              const SizedBox(height: 48),

              //Dietary Restriction
              showRestrictions(context),

              const SizedBox(height: 48),

              Center(
                child: ElevatedButton(
                  onPressed: registerUser,
                  child: const Text("Register"),
                ),
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
                  const Text("Already a member? "),
                  LinkTextButton(
                    onTap: widget.onTap,
                    text: 'Login Here',
                  )
                ],
              ),
              const SizedBox(height: 48)
            ],
          ),
        ),
      ),
    ));
  }

  Widget showRestrictions(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Dietary Restrictions & Allergies",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Input your calorie limit and Allergies",
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        const SizedBox(height: 24),
        CredentialFieldNumbers(
          controller: userCaloricController,
          hintText: "Caloric limit",
          obscureText: false,
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerLeft,
          child: UserInput(
            onFilterChanged: (filters) {
              setState(() {
                selectedDietaryRestrictions = filters;
              });
            },
          ),
        ),
      ],
    );
  }
}
