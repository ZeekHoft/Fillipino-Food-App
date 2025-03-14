import 'package:flilipino_food_app/pages/upload_image.dart';
import 'package:flilipino_food_app/pages/recipe_output.dart';
import 'package:flilipino_food_app/pages/search_recipe.dart';
import 'package:flilipino_food_app/util/recipe_stream_builder.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //RecipeStreamBuilder is placed at the top of all widgets or global access
  runApp(RecipeStreamBuilder(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AddImageToPromptWidget(
        height: 110,
        width: 111,
      ),
    ),
  ));
}
