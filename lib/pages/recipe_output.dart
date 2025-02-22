import 'package:flilipino_food_app/themse/color_themes.dart';
import 'package:flilipino_food_app/util/recipe_stream_builder.dart';
import 'package:flilipino_food_app/widget_designs/display_recipe.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeOutput extends StatefulWidget {
  const RecipeOutput({super.key});

  @override
  State<RecipeOutput> createState() => _RecipeOutputState();
}

class _RecipeOutputState extends State<RecipeOutput> {
  @override
  Widget build(BuildContext context) {
    final recipeStream = RecipeStreamBuilder.of(context)!.recipeStream;

    return Scaffold(
      appBar: AppBar(
        title: const Text("DAPPLI"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: recipeStream,
        builder: (context, snapshot) {
          List<Widget> recipeWidgets = [];

          if (snapshot.hasError ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: AppColors.yellowTheme,
            ));
          } else if (snapshot.hasData || snapshot.data != null) {
            final recipe = snapshot.data?.docs.reversed.toList();

            for (var recipes in recipe!) {
              final recipeWidget = RecipeWidget(
                  name: recipes['name'].toString(),
                  imageUrl: recipes['image'].toString(),
                  ingredients: recipes['ingredients'].toString(),
                  process: recipes['process'].toString());
              recipeWidgets.add(recipeWidget);
            }
          }
          return ListView(
            children: recipeWidgets,
          );
        },
      ),
    );
  }
}

class RecipeWidget extends StatelessWidget {
  const RecipeWidget(
      {super.key,
      required this.name,
      required this.imageUrl,
      required this.ingredients,
      required this.process});

  final String name;
  final String imageUrl;
  final String ingredients;
  final String process;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 300,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            clipBehavior: Clip.antiAlias,
            child: GestureDetector(
              child: Image.network(
                imageUrl,
                fit: BoxFit.fitWidth,
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DisplayRecipe(
                      recipeName: name,
                      recipeIngredients: ingredients,
                      recipeProcess: process,
                      recipeImage: imageUrl,
                    ),
                  ),
                );
              },
            ),
          ),
          Opacity(
            opacity: 0.6,
            child: Text(
              process,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
          const SizedBox(height: 24)
        ],
      ),
    );
  }
}
