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

          if (snapshot.hasError) {
            return const Text("Failed to retrieve data");
          } else if (snapshot.hasData || snapshot.data != null) {
            final recipe = snapshot.data?.docs.reversed.toList();

            for (var recipes in recipe!) {
              final recipeWidget = Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(recipes['name'].toString())),
                  // Expanded(child: Text(recipes['ingredients'].toString())),
                  // Expanded(child: Text(recipes['process'].toString())),
                  // Expanded(
                  //   child: Image.network(recipes['image'].toString()),
                  // ),
                  Expanded(
                    child: GestureDetector(
                      child: Image.network(recipes['image'].toString()),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const DisplayRecipe()));
                      },
                    ),
                  ),
                ],
              );
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
