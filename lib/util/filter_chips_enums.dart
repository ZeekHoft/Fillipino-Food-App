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
