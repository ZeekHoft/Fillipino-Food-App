//lib/pages/home_page/home_widgets/search_recipe.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flilipino_food_app/pages/home_page/home_widgets/display_recipe.dart';
import 'package:flilipino_food_app/themes/app_theme.dart';
import 'package:flutter/material.dart';

class SearchRecipe extends StatefulWidget {
  final List<String>? initialIngredients; // NEW: Accept initial ingredients

  const SearchRecipe({super.key, this.initialIngredients});

  @override
  State<SearchRecipe> createState() => _SearchRecipeState();
}

class _SearchRecipeState extends State<SearchRecipe> {
  List _allResult = [];
  List _resutlList = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // NEW: Set initial ingredients if provided
    if (widget.initialIngredients != null &&
        widget.initialIngredients!.isNotEmpty) {
      _searchController.text = widget.initialIngredients!.join(', ');
    }

    getRecipesStream();
    _searchController.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    print(_searchController.text);
    searchResultList();
  }

  searchResultList() {
    var showResults = [];
    if (_searchController.text != "") {
      List<String> searchIngredients = _searchController.text
          .toLowerCase()
          .split(',')
          .map((ingredient) => ingredient.trim())
          .toList();

      for (var recipesSnapShot in _allResult) {
        var ingredients =
            recipesSnapShot['ingredients'].toString().toLowerCase();

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
      _resutlList = showResults.reversed.toList();
    });
  }

  getRecipesStream() async {
    var data = await FirebaseFirestore.instance
        .collection('recipes')
        .orderBy('ingredients')
        .get();

    if (mounted) {
      setState(() {
        _allResult = data.docs;
      });
      // NEW: Trigger search if initial ingredients were provided
      if (widget.initialIngredients != null &&
          widget.initialIngredients!.isNotEmpty) {
        searchResultList();
      }
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

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
          autofocus: widget.initialIngredients ==
              null, // Only autofocus if no initial ingredients
          decoration: const InputDecoration(
            hintText: "Search a recipe...",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
        ),
      ),
      body: _resutlList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No recipes found',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try different ingredients',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: _resutlList.length,
              itemBuilder: (context, index) {
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
