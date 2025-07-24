import 'package:flilipino_food_app/pages/authentication_page/authentication_widgets/colored_inputs.dart';
import 'package:flilipino_food_app/pages/authentication_page/user_input.dart';
import 'package:flilipino_food_app/util/profile_set_up_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// instead of re itterating this function call back just use typedef to simplify it
// honestly its hard to understand for me to explain any further
typedef UserDetailsCallback = void Function({
  required double? height,
  required double? weight,
  required String? gender,
  required DateTime? birthday,
});

typedef UserGoalsCallback = void Function(List<String> goals);

class UserDetails extends StatefulWidget {
  final UserDetailsCallback onDataChanged;
  //initialData displays pre-existing data instead of blank
  final ProfileSetUpUtil? initialData;
  const UserDetails({super.key, required this.onDataChanged, this.initialData});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _genderController = TextEditingController();
  final _birthdayController = TextEditingController();
  bool _isFinished = false;

  // Pre-fill data using initialData
  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _heightController.text = widget.initialData!.height?.toString() ?? '';
      _weightController.text = widget.initialData!.weight?.toString() ?? '';
      _genderController.text = widget.initialData!.gender ?? '';
      if (widget.initialData!.birthday != null) {
        _birthdayController.text =
            DateFormat('yyyy-MM-dd').format(widget.initialData!.birthday!);
      }
    }
    // Adds listener to check for any changes
    _heightController.addListener(_notifyParentForChange);
    _weightController.addListener(_notifyParentForChange);
    _genderController.addListener(_notifyParentForChange);
    _birthdayController.addListener(_notifyParentForChange);
  }

  // Dispose data after finish and remove tracking
  @override
  void dispose() {
    _heightController.removeListener(_notifyParentForChange);
    _weightController.removeListener(_notifyParentForChange);
    _genderController.removeListener(_notifyParentForChange);
    _birthdayController.removeListener(_notifyParentForChange);
    _heightController.dispose();
    _weightController.dispose();
    _genderController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  void _notifyParentForChange() {
    widget.onDataChanged(
      height: double.tryParse(_heightController.text.trim()),
      weight: double.tryParse(_weightController.text.trim()),
      gender: _genderController.text.trim().isNotEmpty
          ? _genderController.text.trim()
          : null,
      birthday: _birthdayController.text.trim().isNotEmpty
          ? DateFormat('yyyy-MM-dd').parse(_birthdayController.text.trim())
          : null,
    );
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
                _notifyParentForChange(); // Notify parent when date is picked, this is the trigger
              });
            }
          },
        ),
      ],
    );
  }
}

class UserGoals extends StatefulWidget {
  final UserGoalsCallback onDataChanged;
  final List<String>? initialGoals;
  const UserGoals({super.key, required this.onDataChanged, this.initialGoals});

  @override
  State<UserGoals> createState() => _UserGoalsState();
}

class _UserGoalsState extends State<UserGoals> {
  final List<String> _selectedGoals = [];
  final List<String> _availableGoals = [
    "Gain Muscle",
    "Healthy Habits",
    "Weight Loss",
    "Gain Weight"
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialGoals != null) {
      _selectedGoals.addAll(widget.initialGoals!);
    }
  }

  void _onCheckBoxChanged(String goal, bool? isChecked) {
    setState(() {
      if (isChecked == true) {
        if (!_selectedGoals.contains(goal)) {
          _selectedGoals.add(goal);
        }
      } else {
        _selectedGoals.remove(goal);
      }
    });
    widget.onDataChanged(_selectedGoals); //notifyin the parent
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select your goals"),
        const Text("Select multiple goals"),
        ..._availableGoals.map((goal) {
          return ColoredCheckbox(
            title: goal,
            icon: _goalIcons(goal),
            value: _selectedGoals.contains(goal),
            onChanged: (isChecked) => _onCheckBoxChanged(goal, isChecked),
          );
        }).toList()
      ],
    );
  }

  Icon _goalIcons(String goal) {
    switch (goal) {
      case "Gain Muscle":
        return const Icon(Icons.fitness_center_outlined);
      case "Healthy Habits":
        return const Icon(Icons.health_and_safety_outlined);
      case "Weight Loss":
        return const Icon(Icons.monitor_weight_outlined);
      case "Gain Weight":
        return const Icon(Icons.fastfood_outlined);
      default:
        return const Icon(Icons.help_center_outlined);
    }
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

class ColoredCheckbox extends StatelessWidget {
  final String title;
  final Icon icon;
  final bool value; // Renamed from initialValue to just 'value'
  final ValueChanged<bool?> onChanged; // Using bool? for onChanged

  const ColoredCheckbox({
    super.key,
    required this.title,
    required this.icon,
    required this.value, // It's now the *current* value, not just initial
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(title),
      secondary: icon,
      value: value, // The value directly controls the checkbox
      onChanged: onChanged, // Pass the onChanged callback directly
    );
  }
}
