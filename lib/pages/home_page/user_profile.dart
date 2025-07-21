import 'package:flilipino_food_app/util/profile_data_storing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Profile", style: textTheme.displaySmall),
        const SizedBox(height: 16),
        Row(
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
        ListTile(
          leading: const Icon(Icons.fastfood_outlined),
          subtitle: Text("Calorie Limit: $calories"),
        ),
        ListTile(
          leading: const Icon(Icons.emergency_outlined),
          title: const Text("Dietary Restrictions"),
          subtitle: Text(allergies),
        ),
      ],
    );
  }
}
