// ignore_for_file: constant_identifier_names

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

// enum DietaryRestrictionsFilter {
//   none,
//   vegan,
//   vegetarian,
//   lactoseIntolerant,
//   kosher,
//   wheatAllergies,
//   nutAllergies,
//   fishAllergies,
//   soyAllergies,
// }


// enum DietaryRestrictionsFilter {
//   none,
//   vegan,
//   vegetarian,
//   lactoseIntolerant,
//   kosher,
//   wheatAllergies,
//   nutAllergies,
//   fishAllergies,
//   soyAllergies,
// }


// const List<(DietaryRestrictionsFilter, String)> dietaryRestrictionOPtions =
//     <(DietaryRestrictionsFilter, String)>[
//   (DietaryRestrictionsFilter.none, "none"),
//   (DietaryRestrictionsFilter.vegan, "vegan"),
//   (DietaryRestrictionsFilter.vegetarian, "vegetarian"),
//   (DietaryRestrictionsFilter.lactoseIntolerant, "lactoseIntolerant"),
//   (DietaryRestrictionsFilter.kosher, "kosher"),
//   (DietaryRestrictionsFilter.wheatAllergies, "wheatAllergies"),
//   (DietaryRestrictionsFilter.nutAllergies, "nutAllergies"),
//   (DietaryRestrictionsFilter.fishAllergies, "fishAllergies"),
//   (DietaryRestrictionsFilter.soyAllergies, "soyAllergies"),
// ];







enum DietaryRestrictionsFilter {
  none,
  pork,
  shrimp,
  beef,
  fish,
  chicken,
  coconut,
  rice,
  egg,
  garlic,
  onion,
  ginger,
  vinegar,
  soySauce,
  fishSauce,
  shrimpPaste,
  chili,
  peanut,
  gluten,
  dairy,
  msg
}


const List<(DietaryRestrictionsFilter, String)> dietaryRestrictionOPtions =
    <(DietaryRestrictionsFilter, String)>[
  (DietaryRestrictionsFilter.none, "None"),
  (DietaryRestrictionsFilter.pork, "Pork"),
  (DietaryRestrictionsFilter.shrimp, "Shrimp"),
  (DietaryRestrictionsFilter.beef, "Beef"),
  (DietaryRestrictionsFilter.fish, "Fish"),
  (DietaryRestrictionsFilter.chicken, "Chicken"),
  (DietaryRestrictionsFilter.coconut, "Coconut"),
  (DietaryRestrictionsFilter.rice, "Rice"),
  (DietaryRestrictionsFilter.egg, "Egg"),
  (DietaryRestrictionsFilter.garlic, "Garlic"),
  (DietaryRestrictionsFilter.onion, "Onion"),
  (DietaryRestrictionsFilter.ginger, "Ginger"),
  (DietaryRestrictionsFilter.vinegar, "Vinegar"),
  (DietaryRestrictionsFilter.soySauce, "Soy Sauce"),
  (DietaryRestrictionsFilter.fishSauce, "Fish Sauce"),
  (DietaryRestrictionsFilter.shrimpPaste, "Shrimp Paste"),
  (DietaryRestrictionsFilter.chili, "Chili"),
  (DietaryRestrictionsFilter.peanut, "Peanut"),
  (DietaryRestrictionsFilter.gluten, "Gluten"),
  (DietaryRestrictionsFilter.dairy, "Dairy"),
  (DietaryRestrictionsFilter.msg, "MSG"),
];







// const List<(BasicIngredientsFilter, String)> basicIngredientsOptions =
//     <(BasicIngredientsFilter, String)>[
//   (BasicIngredientsFilter.oil, "oil"),
//   (BasicIngredientsFilter.rice, "rice"),
//   (BasicIngredientsFilter.garlic, "garlic"),
//   (BasicIngredientsFilter.onions, "onions"),
//   (BasicIngredientsFilter.tomatoes, "tomatoes"),
//   (BasicIngredientsFilter.soy_sauce, "soy_sauce"),
//   (BasicIngredientsFilter.vinegar, "vinegar"),
//   (BasicIngredientsFilter.pork, "pork"),
//   (BasicIngredientsFilter.chicken, "chicken"),
//   (BasicIngredientsFilter.fish, "fish"),
//   (BasicIngredientsFilter.bay_leaves, "obay_leavesil"),
//   (BasicIngredientsFilter.black_peppercorns, "black_peppercorns"),
//   (BasicIngredientsFilter.ginger, "ginger"),
//   (BasicIngredientsFilter.green_onions, "green_onions"),
// ];



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
