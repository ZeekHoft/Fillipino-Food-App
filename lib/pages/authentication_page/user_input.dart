import 'package:flilipino_food_app/pages/authentication_page/allergy_and_dietary/filter_chips_enums.dart';
import 'package:flutter/material.dart';

class UserInput extends StatefulWidget {
  const UserInput({super.key});

  @override
  State<UserInput> createState() => _UserInputState();
}

class _UserInputState extends State<UserInput> {
  // old variables
  // final List<bool> _toggleButtonSelectionDietary =
  //     List.generate(DietaryRestrictionsFilter.values.length, (_) => false);
  // final List<bool> _toggleButtonSelectionIngredients =
  //     List.generate(BasicIngredientsFilter.values.length, (_) => false);

  // Store filters in a set
  final Set<DietaryRestrictionsFilter> _dietaryRestrictionsFilters =
      <DietaryRestrictionsFilter>{};

  final Set<BasicIngredientsFilter> _basicIngredientsFilters =
      <BasicIngredientsFilter>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Restrictions"),
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              runSpacing: 8,
              children: dietaryRestrictionOPtions.map((restriction) {
                return FilterChip(
                  label: Text(restriction.$2),
                  selected:
                      _dietaryRestrictionsFilters.contains(restriction.$1),
                  onSelected: (selected) {
                    setState(() {
                      // Needs logic to make 'none' option exclusive from other options
                      if (selected) {
                        _dietaryRestrictionsFilters.add(restriction.$1);
                      } else {
                        _dietaryRestrictionsFilters.remove(restriction.$1);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 48),

            // Ingredients section
            const Text('Ingredients'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              runSpacing: 8,
              children: basicIngredientsOptions.map((ingredient) {
                return FilterChip(
                  label: Text(ingredient.$2),
                  selected: _basicIngredientsFilters.contains(ingredient.$1),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _basicIngredientsFilters.add(ingredient.$1);
                      } else {
                        _basicIngredientsFilters.remove(ingredient.$1);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
