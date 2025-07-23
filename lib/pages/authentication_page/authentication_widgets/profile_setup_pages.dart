import 'package:flilipino_food_app/pages/authentication_page/authentication_widgets/colored_inputs.dart';
import 'package:flilipino_food_app/pages/authentication_page/user_input.dart';
import 'package:flutter/material.dart';

class UserDetails extends StatelessWidget {
  const UserDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          "Tell us about yourself",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 12),
        const Text("Your height"),
        const ColoredInputNumber(
          hintText: "Enter your height",
          suffixText: "cm",
        ),
        const SizedBox(height: 8),
        const Text("Your weight"),
        const ColoredInputNumber(
          hintText: "Enter your weight",
          suffixText: "kg",
        ),
        const Text("Your gender"),
        const ColoredPlaceholder(
          hintText: "Select your gender",
        ),
        const SizedBox(height: 8),
        const Text("Your birthday"),
        const ColoredPlaceholder(
          hintText: "dd / mm / yyyy",
        ),
      ],
    );
  }
}

class UserGoals extends StatelessWidget {
  const UserGoals({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Text(
          "Select your Goals",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const Text("Select multiple goals"),
        const ColoredCheckbox(
          title: "Gain Muscles",
          icon: Icon(Icons.fitness_center),
        ),
        const ColoredCheckbox(
          title: "Healthy Habits",
          icon: Icon(Icons.self_improvement),
        ),
        const ColoredCheckbox(
          title: "Weight Loss",
          icon: Icon(Icons.monitor_weight),
        ),
        const ColoredCheckbox(
          title: "Gain Weight",
          icon: Icon(Icons.rice_bowl),
        ),
      ],
    );
  }
}

class UserAllergies extends StatelessWidget {
  const UserAllergies({super.key});

  @override
  Widget build(BuildContext context) {
    final userCaloricController = TextEditingController();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Dietary Restrictions & Allergies",
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      Text(
        "We'll tailor an experience based on your allergies, creating a personalized food experience",
        style: Theme.of(context).textTheme.labelLarge,
      ),
      const SizedBox(height: 12),
      const Text("Caloric limit"),
      ColoredInputNumber(
        controller: userCaloricController,
        hintText: "Enter your calorie limit",
      ),
      const SizedBox(height: 24),
      UserInput(
        onFilterChanged: (filters) {
          // setState(() {
          //   selectedDietaryRestrictions = filters;
          // });
        },
      ),
    ]);
  }
}

enum SurveyOption {
  youtube,
  twitter,
  instagram,
  facebook,
  google,
  tiktok,
  friends,
  others,
}

const surveyOptions = <SurveyOption, String>{
  SurveyOption.youtube: "Youtube",
  SurveyOption.twitter: "Twitter",
  SurveyOption.instagram: "Instagram",
  SurveyOption.facebook: "Facebook",
  SurveyOption.google: "Google",
  SurveyOption.tiktok: "Tiktok",
  SurveyOption.friends: "Friends or Colleagues",
  SurveyOption.others: "Others",
};

class UserSurvey extends StatefulWidget {
  const UserSurvey({super.key});

  @override
  State<UserSurvey> createState() => _UserSurveyState();
}

class _UserSurveyState extends State<UserSurvey> {
  SurveyOption? _selectedOption = SurveyOption.youtube;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "How did you hear about us?",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text(
          "Select one",
          style: Theme.of(context).textTheme.labelLarge,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: surveyOptions.length,
            itemBuilder: (context, index) {
              SurveyOption key = surveyOptions.keys.elementAt(index);
              return RadioListTile(
                contentPadding: EdgeInsets.zero,
                value: key,
                title: Text(surveyOptions[key]!),
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value;
                  });
                },
                controlAffinity: ListTileControlAffinity.trailing,
              );
            },
          ),
        ),
      ],
    );
  }
}
