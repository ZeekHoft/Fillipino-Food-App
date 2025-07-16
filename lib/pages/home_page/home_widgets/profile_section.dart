import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flilipino_food_app/pages/home_page/home_widgets/recipe_feed_item.dart';
import 'package:flilipino_food_app/util/profile_data_storing.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key});

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final profileDataStoring = context.watch<ProfileDataStoring>();

    // add safety for data loading

    if (profileDataStoring.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final username = profileDataStoring.username;
    final email = profileDataStoring.email;
    final calories = profileDataStoring.caloriesLimit.toString();
    final allergies = profileDataStoring.allergies;

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
          subtitle: Text("Calorie Limit: $calories"),
        ),
        ListTile(
          leading: const Icon(Icons.emergency_outlined),
          title: const Text("Dietary Restrictions"),
          subtitle: Text(allergies),
        ),
        const Divider(),
        const ListTile(
            leading: Icon(Icons.edit_outlined), title: Text("Edit Profile")),
        const ListTile(
            leading: Icon(Icons.history_outlined), title: Text("History")),
        const ListTile(
            leading: Icon(Icons.settings_outlined), title: Text("Settings")),
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
          leading: const Icon(Icons.exit_to_app),
          title: const Text("Exit app"),
        ),
      ],
    );
  }
}
