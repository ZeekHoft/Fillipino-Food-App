import 'package:flilipino_food_app/util/filter_chips_enums.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserInput extends StatefulWidget {
  const UserInput({super.key});

  @override
  State<UserInput> createState() => _UserInputState();
}

class _UserInputState extends State<UserInput> {
  final List<bool> _toggleButtonSelection =
      List.generate(DietaryRestrictionsFilter.values.length, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("Restrictions"),
          const SizedBox(height: 10),
          ToggleButtons(
              isSelected: _toggleButtonSelection,
              onPressed: (int index) {
                setState(() {
                  _toggleButtonSelection[index] =
                      !_toggleButtonSelection[index];

                  DietaryRestrictionsFilter selectedEnum =
                      DietaryRestrictionsFilter.values[index];
                  if (kDebugMode) {
                    print(selectedEnum);
                  }
                });
              },
              constraints: const BoxConstraints(
                minHeight: 32.0,
                minWidth: 56.0,
              ),
              children: dietaryRestrictionOPtions
                  .map(((DietaryRestrictionsFilter, String) restriction) =>
                      Text(restriction.$2))
                  .toList()),
        ],
      ),
    );
  }
}
