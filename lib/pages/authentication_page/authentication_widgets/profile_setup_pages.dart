import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flilipino_food_app/pages/authentication_page/authentication_widgets/colored_inputs.dart';
import 'package:flilipino_food_app/pages/authentication_page/user_input.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserProfileData {
  final double height;
  final double weight;
  final String gender;
  final DateTime birthday;
  UserProfileData(
      {required this.height,
      required this.weight,
      required this.gender,
      required this.birthday});
}

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _genderController = TextEditingController();
  final _birthdayController = TextEditingController();
  bool _isFinished = false;

  // UserProfileData getUserData() {
  //   return
  // }

  // Each controller being tracked by the function
  @override
  void initState() {
    super.initState();
    _heightController.addListener(checkIfAllGood);
    _weightController.addListener(checkIfAllGood);
    _genderController.addListener(checkIfAllGood);
    _birthdayController.addListener(checkIfAllGood);
  }

  // Dispose data after finish and remove tracking
  @override
  void dispose() {
    _heightController.removeListener(checkIfAllGood);
    _weightController.removeListener(checkIfAllGood);
    _genderController.removeListener(checkIfAllGood);
    _birthdayController.removeListener(checkIfAllGood);

    _heightController.dispose();
    _weightController.dispose();
    _genderController.dispose();
    _birthdayController.dispose();

    super.dispose();
  }

  void checkIfAllGood() {
    if (_heightController.text.trim().isNotEmpty &&
        _weightController.text.trim().isNotEmpty &&
        _genderController.text.trim().isNotEmpty &&
        _birthdayController.text.trim().isNotEmpty &&
        !_isFinished) {
      _isFinished = true;

      final userData = UserProfileData(
        height: double.tryParse(_heightController.text.trim()) ??
            0.0, // Safely parse double
        weight: double.tryParse(_weightController.text.trim()) ?? 0.0,
        gender: _genderController.text.trim(),
        birthday:
            DateFormat('yyyy-MM-dd').parse(_birthdayController.text.trim()),
      );

      // Using a Future.microtask to prevent a "setState during build" error
      // as the listener might trigger during widget rebuilds.

      Future.microtask(() async {
        await FirebaseFirestore.instance.collection("users_data").add({
          "height": userData.height,
          "weight": userData.weight,
          "gender": userData.gender,
          "birthday": userData.birthday
        });
      });
    }
  }

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
        ColoredInputNumber(
          controller: _heightController,
          hintText: "Enter your height",
          suffixText: "cm",
        ),
        const SizedBox(height: 8),
        const Text("Your weight"),
        ColoredInputNumber(
          controller: _weightController,
          hintText: "Enter your weight",
          suffixText: "kg",
        ),
        const Text("Your gender"),
        TextFormField(
          controller: _genderController,
          decoration: const InputDecoration(
            hintText: "Select your gender",
          ),
        ),
        const SizedBox(height: 8),
        const Text("Your birthday"),
        TextFormField(
          controller: _birthdayController,
          readOnly: true,
          decoration: const InputDecoration(
            hintText: "yyyy/mm/dd",
          ),
          onTap: () async {
            DateTime? pickeddate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
            );

            if (pickeddate != null) {
              setState(() {
                _birthdayController.text =
                    DateFormat('yyyy-MM-dd').format(pickeddate);
              });
            }
          },
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
