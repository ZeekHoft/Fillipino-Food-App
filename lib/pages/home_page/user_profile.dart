import 'package:flilipino_food_app/themes/app_theme.dart';
import 'package:flilipino_food_app/util/profile_data_storing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Shows profile of user on top of home screen
class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    //user watch for consistent chagnges such as names, allergies, dietary restriction etc... use read to only fetch the thing that is needed when something is finished

    final profileDataStoring = context.watch<ProfileDataStoring>();

    // add safety for data loading

    if (profileDataStoring.isLoading) {
      return const Center(
        child: DappliProgressIndicator(),
      );
    }

    final username = profileDataStoring.username;
    // final email = profileDataStoring.email;
    // final calories = profileDataStoring.caloriesLimit.toString();
    final allergies = profileDataStoring.allergies;
    // List<String> characters = allergies.split('');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              height: 168,
              color: Theme.of(context).colorScheme.primary,
            ),
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.elliptical(320, 100),
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              child: CircleAvatar(
                radius: 64,
                backgroundColor: Theme.of(context).colorScheme.surface,
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        Center(child: Text(username, style: textTheme.headlineLarge)),
        const SizedBox(height: 16),
        Center(
          child: Text(
            "Allergies",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _convertAllergies(allergies),
        const IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ProfileStat(count: 10, name: "posts"),
              VerticalDivider(indent: 8, endIndent: 8),
              ProfileStat(count: 69, name: "followers"),
              VerticalDivider(indent: 8, endIndent: 8),
              ProfileStat(count: 58, name: "following")
            ],
          ),
        )
      ],
    );
  }

  _convertAllergies(String allergies) {
    List<String> allergyList = allergies.split(',');
    List<Widget> allergyChips = [];
    for (var allergy in allergyList) {
      allergyChips.add(AllergyChip(allergy: allergy));
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        children: allergyChips,
      ),
    );
  }
}

class AllergyChip extends StatelessWidget {
  const AllergyChip({
    super.key,
    required this.allergy,
  });

  final String allergy;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        allergy,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(16),
      ),
      side: BorderSide.none,
    );
  }
}

class ProfileStat extends StatelessWidget {
  const ProfileStat({super.key, required this.count, required this.name});

  final int count;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            count.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            name.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
