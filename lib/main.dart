import 'package:flilipino_food_app/pages/authentication_page/authenticate.dart';
import 'package:flilipino_food_app/pages/favorite/favorite_provider.dart';
import 'package:flilipino_food_app/pages/favorite/favorite_social_provider.dart';
import 'package:flilipino_food_app/themes/app_theme.dart';
import 'package:flilipino_food_app/util/profile_data_storing.dart';
import 'package:flilipino_food_app/util/recipe_stream_builder.dart';
import 'package:flilipino_food_app/util/social_data_storing.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  // IMPORTANT: Initialize Flutter binding FIRST
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: "assets/dotenv");

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),

        //ChangeNotifierProvider just gives access to FavoriteProvider in the tree
        //it's the bridge that makes your FavoriteProvider accessible and reactive throughout the app.
        ChangeNotifierProvider(create: (_) => FavoriteSocialProvider()),

        ChangeNotifierProvider(
            create: (context) => ProfileDataStoring()..fetchUserData()),

        ChangeNotifierProvider(
            create: (context) => SocialDataStoring()..fetchUserPost('')),

        ChangeNotifierProvider(
            create: (context) => SocialDataStoring()..countUserPost('')),
      ],
      child: RecipeStreamBuilder(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          theme: AppTheme.light,
          // darkTheme: AppTheme.dark,
          home: const Authenticate(),

          // home: ProfileSetup(
          //   uid: '',
          //   email: '',
          //   username: '',
          // ),
        ),
      ),
    ),
  );
}