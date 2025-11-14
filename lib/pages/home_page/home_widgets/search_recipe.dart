import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flilipino_food_app/pages/home_page/home_widgets/display_recipe.dart';
import 'package:flilipino_food_app/themes/app_theme.dart';
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
      //below just show results base on firebase input positioning
      // _resutlList = showResults;
      //descending order least to most length
      _resutlList = showResults.reversed.toList();
    });
  }

  //getting values base on the fields
  getRecipesStream() async {
    var data = await FirebaseFirestore.instance
        .collection('recipes')
        .orderBy('ingredients')
        .get();

    if (mounted) {
      //mounted to help you manage state and avoid potential errors that can occur when interacting with a widget that is no longer part of the widget tree
      setState(() {
        _allResult = data.docs;
      });
    }
  }

  //making a button to claer all
  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // didChangeDependencies is not ideal for fetching data every time dependencies change.
  // initState is generally preferred for initial data loading.
  // If you need to re-fetch on certain conditions, consider a specific method call
  // @override
  // void didChangeDependencies() {
  //   getRecipesStream();

  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    if (_allResult.isEmpty) {
      return Center(
        child: DappliProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight * 1.3,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Search a recipe...",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
        ),
      ),
      body: ListView.separated(
        // itemCount: _allResult.length, show all the results being retrieved
        separatorBuilder: (context, index) => const Divider(),
        itemCount: _resutlList.length,
        itemBuilder: (context, index) {
          // give access to the document ID
          String documentId = _resutlList[index].id;
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DisplayRecipe(
                    recipeName: _resutlList[index]['name'],
                    recipeIngredients: _resutlList[index]['ingredients'],
                    recipeProcess: _resutlList[index]['process'],
                    recipeImage: _resutlList[index]['image'],
                    recipeCalories: _resutlList[index]['calories'],
                    documentId: documentId,
                  ),
                ),
              );
            },
            child: ListTile(
              title: Text(_resutlList[index]['name']),
              subtitle: Text(_resutlList[index]['ingredients']),
            ),
          );
        },
      ),
    );
  }
}
