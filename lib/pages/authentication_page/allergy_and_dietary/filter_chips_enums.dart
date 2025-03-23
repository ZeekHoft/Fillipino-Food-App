enum BasicIngredientsFilter {
  oil,
  rice,
  garlic,
  onions,
  tomatoes,
  soy_sauce,
  vinegar,
  pork,
  chicken,
  fish,
  bay_leaves,
  black_peppercorns,
  ginger,
  green_onions,
}

enum DietaryRestrictionsFilter {
  none,
  vegan,
  vegetarian,
  lactoseIntolerant,
  kosher,
  wheatAllergies,
  nutAllergies,
  fishAllergies,
  soyAllergies,
}

const List<(BasicIngredientsFilter, String)> basicIngredientsOptions =
    <(BasicIngredientsFilter, String)>[
  (BasicIngredientsFilter.oil, "oil"),
  (BasicIngredientsFilter.rice, "rice"),
  (BasicIngredientsFilter.garlic, "garlic"),
  (BasicIngredientsFilter.onions, "onions"),
  (BasicIngredientsFilter.tomatoes, "tomatoes"),
  (BasicIngredientsFilter.soy_sauce, "soy_sauce"),
  (BasicIngredientsFilter.vinegar, "vinegar"),
  (BasicIngredientsFilter.pork, "pork"),
  (BasicIngredientsFilter.chicken, "chicken"),
  (BasicIngredientsFilter.fish, "fish"),
  (BasicIngredientsFilter.bay_leaves, "obay_leavesil"),
  (BasicIngredientsFilter.black_peppercorns, "black_peppercorns"),
  (BasicIngredientsFilter.ginger, "ginger"),
  (BasicIngredientsFilter.green_onions, "green_onions"),
];

const List<(DietaryRestrictionsFilter, String)> dietaryRestrictionOPtions =
    <(DietaryRestrictionsFilter, String)>[
  (DietaryRestrictionsFilter.none, "none"),
  (DietaryRestrictionsFilter.vegan, "vegan"),
  (DietaryRestrictionsFilter.vegetarian, "vegetarian"),
  (DietaryRestrictionsFilter.lactoseIntolerant, "lactoseIntolerant"),
  (DietaryRestrictionsFilter.kosher, "kosher"),
  (DietaryRestrictionsFilter.wheatAllergies, "wheatAllergies"),
  (DietaryRestrictionsFilter.nutAllergies, "nutAllergies"),
  (DietaryRestrictionsFilter.fishAllergies, "fishAllergies"),
  (DietaryRestrictionsFilter.soyAllergies, "soyAllergies"),
];



// String dietaryRestrictionReadable(DietaryRestrictionsFilter filter) {
//   return switch (filter) {
//     DietaryRestrictionsFilter.vegan => 'vegan',
//     DietaryRestrictionsFilter.vegetarian => 'vegetarian',
//     DietaryRestrictionsFilter.lactoseIntolerant => 'dairy free',
//     DietaryRestrictionsFilter.kosher => 'kosher',
//     DietaryRestrictionsFilter.wheatAllergies => 'wheat allergy',
//     DietaryRestrictionsFilter.nutAllergies => 'nut allergy',
//     DietaryRestrictionsFilter.fishAllergies => 'fish allergy',
//     DietaryRestrictionsFilter.soyAllergies => 'soy allergy',
//   };
// }
