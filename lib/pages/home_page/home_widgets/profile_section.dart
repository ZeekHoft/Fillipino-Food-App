import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flilipino_food_app/pages/home_page/home_widgets/username_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key});

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    //getting data ang making it in map format or key value pairs
    final currentUser = FirebaseAuth.instance.currentUser;

    final snapshot = await FirebaseFirestore.instance
        .collection(
            "users_data") // getting data equal to email / find user by email
        .where("email", isEqualTo: currentUser!.email)
        .limit(1)
        .get();

    return snapshot.docs.first; // Return the first matching document
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
            future: getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                ); // waiting for data to be retrieved
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Something went wrong"),
                ); // if other occurs
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(
                  child: Text("User data not found"),
                ); //if users data can't be retrieved
              }

              //user data being set to each variable
              final userData = snapshot.data!
                  .data()!; //all data being retreive and specify them below user the term userData
              final username = userData["username"] ?? "N/A";
              final email = userData["email"] ?? "N/A";
              final calories = userData["calories"]?.toString() ?? "N/A";
              final allergies =
                  (userData["allergies"] as List<dynamic>? ?? []).join(", ");

              //display data
              return Padding(
                padding: const EdgeInsets.all(9),
                child: Column(
                  children: [
                    Text("Username: $username"),
                    const SizedBox(height: 8),
                    Text("Email: $email"),
                    const SizedBox(height: 8),
                    Text("Calorie Limit: $calories"),
                    const SizedBox(height: 8),
                    Text("Allergies: $allergies"),
                  ],
                ),
              );
            })
      ],
    );
  }
}
