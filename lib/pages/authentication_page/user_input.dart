import 'package:flilipino_food_app/pages/authentication_page/allergy_and_dietary/filter_chips_enums.dart';
import 'package:flutter/material.dart';

class UserInput extends StatefulWidget {
  //create a connection from the parent class
  final Function(Set<DietaryRestrictionsFilter>) onFilterChanged;

  const UserInput({super.key, required this.onFilterChanged});

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
      <DietaryRestrictionsFilter>{DietaryRestrictionsFilter.vegan};

  // final Set<BasicIngredientsFilter> _basicIngredientsFilters =
  //     <BasicIngredientsFilter>{};

  @override
  Widget build(BuildContext context) {
    return Column(
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
              selected: _dietaryRestrictionsFilters.contains(restriction.$1),
              onSelected: (bool selected) {
                setState(() {
                  // Needs logic to make 'none' option exclusive from other options
                  if (selected) {
                    _dietaryRestrictionsFilters.add(restriction.$1);
                    print(_dietaryRestrictionsFilters.toString());

                    for (var item in _dietaryRestrictionsFilters.toList()) {
                      if (item == DietaryRestrictionsFilter.none) {
                        _dietaryRestrictionsFilters.clear();
                        _dietaryRestrictionsFilters
                            .add(DietaryRestrictionsFilter.none);
                        print(_dietaryRestrictionsFilters.toString());
                      }
                    }
                  } else {
                    _dietaryRestrictionsFilters.remove(restriction.$1);
                  }
                  // instant update in the list to send back to SignUpPage
                  widget.onFilterChanged(_dietaryRestrictionsFilters);
                });
              },
            );
          }).toList(),
        ),

        // const SizedBox(height: 48),
        // TextButton(
        //     onPressed: () {
        //       print(_dietaryRestrictionsFilters.toString());
        //     },
        //     child: Text("click"))

        // Ingredients section
        // const Text('Ingredients'),
        // const SizedBox(height: 8),
        // Wrap(
        //   spacing: 4,
        //   runSpacing: 8,
        //   children: basicIngredientsOptions.map((ingredient) {
        //     return FilterChip(
        //       label: Text(ingredient.$2),
        //       selected: _basicIngredientsFilters.contains(ingredient.$1),
        //       onSelected: (selected) {
        //         setState(() {
        //           if (selected) {
        //             _basicIngredientsFilters.add(ingredient.$1);
        //           } else {
        //             _basicIngredientsFilters.remove(ingredient.$1);
        //           }
        //         });
        //       },
        //     );
        //   }).toList(),
        // ),
      ],
    );
  }
}
