import 'package:flilipino_food_app/common_widgets/settings_buttons.dart';
import 'package:flilipino_food_app/pages/settings/edit_profile_data.dart';
import 'package:flilipino_food_app/pages/social/social_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child:
              Text("Settings", style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(height: 24),
        ListTile(
            title: SettingsButtons(
                // Reusable widget
                pageRoute: EditProfileData(),
                settingsIcon: const Icon(Icons.edit),
                settingsText: const Text("Edit Profile"))),
        ListTile(
            title: SettingsButtons(
                // Reusable widget
                pageRoute: SocialPage(screenChnage: true),
                settingsIcon: const Icon(Icons.history),
                settingsText: const Text("History Posts"))),
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
