import 'package:firebase_auth/firebase_auth.dart';
import 'package:flilipino_food_app/common_widgets/link_text_button.dart';
import 'package:flilipino_food_app/pages/authentication_page/authentication_widgets/credential_field.dart';
import 'package:flilipino_food_app/pages/authentication_page/profile_setup.dart';
import 'package:flilipino_food_app/util/validators.dart';
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
  // final userCaloricController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //temp data storing for list of allergy
  // Set<DietaryRestrictionsFilter> selectedDietaryRestrictions = {};

  bool isRegistered = false;
  // int _currentRegisterIndex = 0;

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
      // if values not empty
      if (passwordController.text.trim() ==
              confirmPasswordController.text.trim()
          // && userCaloricController.text.trim().isNotEmpty
          ) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        User? newUser = userCredential.user;

        if (newUser != null) {
          if (mounted) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileSetup(
                  uid: newUser.uid,
                  email: newUser.email,
                  username: userNameController.text.trim(),
                ),
              ),
            );
          }
        } else {
          Navigator.pop(context);
          errorMessage("User creation failed. please try again");
        }
      } else {
        Navigator.pop(context);
        errorMessage("Passwords don't match");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      errorMessage(e.code);
    } catch (e) {
      Navigator.pop(context);
      errorMessage("An unexpected error occurred: ${e.toString()}");
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

  // Future addUserDetails(String email, String username, String uid
  //     // int calorie
  //     ) async {
  //   await FirebaseFirestore.instance.collection("users_data").add({
  //     "email": email,
  //     "username": username,
  //     "uid": uid,
  //     // "calories": calorie,
  //     // "allergies": selectedDietaryRestrictions.map((e) => e.name).toList()
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                SizedBox(
                    height: 180,
                    child: Image.asset(
                      "assets/dappli_logo.png",
                    )),
                const SizedBox(height: 8.0),
                Text(
                  "Create an account",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  "Let's help you set up your account, it won't take long.",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 24),

                // Username
                CredentialField(
                  controller: userNameController,
                  labelText: "Name",
                  hintText: "Enter your name",
                  obscureText: false,
                  validator: (value) => Validator.validateEmpty(value),
                ),
                const SizedBox(height: 10),

                // Email
                CredentialField(
                  controller: emailController,
                  labelText: "Email",
                  hintText: "Enter your email",
                  obscureText: false,
                  validator: (value) => Validator.validateEmail(value),
                ),
                const SizedBox(height: 10),

                // Pass
                CredentialField(
                  controller: passwordController,
                  labelText: "Password",
                  hintText: "Enter your password",
                  obscureText: true,
                  validator: (value) => Validator.validateEmpty(value),
                ),
                const SizedBox(height: 10),
                // Confirm Pass
                CredentialField(
                    controller: confirmPasswordController,
                    labelText: "Confirm Password",
                    hintText: "Confirm your password",
                    obscureText: true,
                    validator: (value) => Validator.confirmPassword(
                        value, passwordController.text)),
                const SizedBox(height: 24),

                // Next Button
                ElevatedButton(
                  onPressed: () => setState(() {
                    if (_formKey.currentState!.validate()) {
                      registerUser();
                    }
                  }),
                  child: const Text("Sign Up"),
                ),

                const SizedBox(height: 48),
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
                const SizedBox(height: 24),
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
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
/* OLD CODE
  // First step: account credentials
  Widget _showCredentialForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          SizedBox(
              height: 180,
              child: Image.asset(
                "assets/dappli_logo.png",
              )),
          const SizedBox(height: 8.0),
          Text(
            "Create an account",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            "Let's help you set up your account, it won't take long.",
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 24),

          // Username
          CredentialField(
            controller: userNameController,
            labelText: "Name",
            hintText: "Enter your name",
            obscureText: false,
            validator: (value) => Validator.validateEmpty(value),
          ),
          const SizedBox(height: 10),

          // Email
          CredentialField(
            controller: emailController,
            labelText: "Email",
            hintText: "Enter your email",
            obscureText: false,
            validator: (value) => Validator.validateEmail(value),
          ),
          const SizedBox(height: 10),

          // Pass
          CredentialField(
            controller: passwordController,
            labelText: "Password",
            hintText: "Enter your password",
            obscureText: true,
            validator: (value) => Validator.validateEmpty(value),
          ),
          const SizedBox(height: 10),
          // Confirm Pass
          CredentialField(
              controller: confirmPasswordController,
              labelText: "Confirm Password",
              hintText: "Confirm your password",
              obscureText: true,
              validator: (value) =>
                  Validator.confirmPassword(value, passwordController.text)),
          const SizedBox(height: 24),

          // Next Button
          ElevatedButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileSetup(),
                )),
            // onPressed: () => setState(() {
            //   if (_formKey.currentState!.validate()) {
            //     _currentRegisterIndex = 1;
            //   }
            // }),
            child: const Text("Sign Up"),
          ),

          const SizedBox(height: 48),
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
          const SizedBox(height: 24),
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
        ],
      ),
    );
  }

  // Second step: user details
  Widget _showRestrictions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 48),
        Text(
          "Dietary Restrictions & Allergies",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          "Input your calorie limit and Allergies",
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 24),
        CredentialField(
          controller: userCaloricController,
          hintText: "Caloric limit",
          obscureText: false,
          isNumber: true,
        ),
        const SizedBox(height: 24),
        UserInput(
          onFilterChanged: (filters) {
            setState(() {
              selectedDietaryRestrictions = filters;
            });
          },
        ),
        const SizedBox(height: 48),
        Row(
          children: [
            LinkTextButton(
              onTap: () => setState(() {
                _currentRegisterIndex = 0;
              }),
              text: "Back",
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: registerUser,
              child: const Text("Register"),
            ),
          ],
        ),
      ],
    );
  }
}
*/
