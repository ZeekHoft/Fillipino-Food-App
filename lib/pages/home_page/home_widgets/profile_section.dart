import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flilipino_food_app/pages/home_page/home_page.dart';
import 'package:flilipino_food_app/pages/home_page/home_widgets/recipe_feed.dart';
import 'package:flilipino_food_app/pages/home_page/home_widgets/recipe_feed_item.dart';
import 'package:flutter/material.dart';
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

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return FutureBuilder(
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
          final dynamic calories = userData["calories"]?.toString() ?? "N/A";
          final int caloriesValue = userData["calories"] ?? 0;
          final allergies =
              (userData["allergies"] as List<dynamic>? ?? []).join(", ");

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RecipeFeed(
                        userData: caloriesValue,
                      )));
          //display data
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text("Profile", style: textTheme.displaySmall),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      child: Icon(
                        Icons.person_outline_rounded,
                        size: 35,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(username, style: textTheme.headlineLarge),
                        Opacity(
                            opacity: 0.8,
                            child: Text(email, style: textTheme.bodyLarge))
                      ],
                    )
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.fastfood_outlined),
                title: const Text("Calorie Limit"),
                subtitle: Text(calories),
              ),
              ListTile(
                leading: const Icon(Icons.emergency_outlined),
                title: const Text("Dietary Restrictions"),
                subtitle: Text(allergies),
              ),
              const Divider(),
              const ListTile(
                  leading: Icon(Icons.edit_outlined),
                  title: Text("Edit Profile")),
              const ListTile(
                  leading: Icon(Icons.history_outlined),
                  title: Text("History")),
              const ListTile(
                  leading: Icon(Icons.settings_outlined),
                  title: Text("Settings")),
              const Divider(),
              const ListTile(
                leading: Icon(Icons.help_outline),
                title: Text("Help"),
              ),
              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text("About"),
              ),
              ListTile(
                onTap: signOut,
                leading: const Icon(Icons.logout_outlined),
                title: const Text("Log Out"),
              ),
            ],
          );
        });
  }
}

void passValues(String caloriesValue) {}
