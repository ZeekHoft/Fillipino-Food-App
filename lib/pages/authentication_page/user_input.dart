import 'package:flilipino_food_app/pages/authentication_page/allergy_and_dietary/filter_chips_enums.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserInput extends StatefulWidget {
  const UserInput({super.key});

  @override
  State<UserInput> createState() => _UserInputState();
}

class _UserInputState extends State<UserInput> {
  final List<bool> _toggleButtonSelectionDietary =
      List.generate(DietaryRestrictionsFilter.values.length, (_) => false);
  final List<bool> _toggleButtonSelectionIngredients =
      List.generate(BasicIngredientsFilter.values.length, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const Text("Restrictions"),
          const SizedBox(height: 10),
          ToggleButtons(
              isSelected: _toggleButtonSelectionDietary,
              onPressed: (int index) {
                setState(() {
                  _toggleButtonSelectionDietary[index] =
                      !_toggleButtonSelectionDietary[index];

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
          const SizedBox(height: 20),
          const Text('Ingredients'),
          const SizedBox(height: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ToggleButtons(
                isSelected: _toggleButtonSelectionIngredients,
                onPressed: (int index) {
                  setState(() {
                    _toggleButtonSelectionIngredients[index] =
                        !_toggleButtonSelectionIngredients[index];
                  });
                },
                constraints:
                    const BoxConstraints(minHeight: 32.0, minWidth: 56.0),
                children: basicIngredientsOptions
                    .map(((BasicIngredientsFilter, String) ingredients) =>
                        Text(ingredients.$2))
                    .toList(),
              )
            ],
          )
        ],
      ),
    );
  }
}
