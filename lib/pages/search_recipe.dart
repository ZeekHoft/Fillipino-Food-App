import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flilipino_food_app/themse/color_themes.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class SearchRecipe extends StatefulWidget {
  const SearchRecipe({super.key});

  @override
  State<SearchRecipe> createState() => _SearchRecipeState();
}

class _SearchRecipeState extends State<SearchRecipe> {
  //storing all results
  List _allResult = [];

  //search list
  List _resutlList = [];

  final TextEditingController _searchController = TextEditingController();

  //getting recipes
  @override
  void initState() {
    getRecipesStream();
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    print(_searchController.text);
    searchResultList();
  }

  //might need fixing here for the search parameter to take more than just 1 ingredients
  searchResultList() {
    var showResults = [];
    if (_searchController.text != "") {
      //split the search querry to take more than 1 value
      List<String> searchIngredients = _searchController.text
          .toLowerCase()
          .split(',')
          //trim all spaces so it can be read as a list in the FBA
          .map((ingredient) => ingredient.trim())
          .toList();

      for (var recipesSnapShot in _allResult) {
        var ingredients =
            recipesSnapShot['ingredients'].toString().toLowerCase();
        //check if all thats being search is present
        bool containsAllIngredients = searchIngredients
            .every((ingredient) => ingredients.contains(ingredient));

        if (containsAllIngredients) {
          showResults.add(recipesSnapShot);
        }
      }
    } else {
      showResults = List.from(_allResult);
    }

    setState(() {
      _resutlList = showResults;
    });
    searchResultList();
  }

  //getting values base on the fields
  getRecipesStream() async {
    var data = await FirebaseFirestore.instance
        .collection('recipes')
        .orderBy('ingredients')
        .get();

    setState(() {
      _allResult = data.docs;
    });
  }

  //making a button to claer all
  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged());
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getRecipesStream();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blueTheme,
        title: CupertinoSearchTextField(
          controller: _searchController,
          placeholder: "Enter ingredients...",
        ),
      ),
      body: ListView.builder(
          // itemCount: _allResult.length, show all the results being retrieved
          itemCount: _resutlList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_resutlList[index]['name']),
              subtitle: Text(_resutlList[index]['ingredients']),
            );
          }),
    );
  }
}
