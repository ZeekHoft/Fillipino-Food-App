import 'package:flilipino_food_app/pages/authentication_page/authenticate.dart';
import 'package:flilipino_food_app/pages/authentication_page/profile_setup.dart';
import 'package:flilipino_food_app/pages/favorite/favorite_provider.dart';
import 'package:flilipino_food_app/themes/app_theme.dart';
import 'package:flilipino_food_app/util/profile_data_storing.dart';
import 'package:flilipino_food_app/util/recipe_stream_builder.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                FavoriteProvider()), //ChangeNotifierProvider just gives access to FavoriteProvider in the tree
        //it’s the bridge that makes your FavoriteProvider accessible and reactive throughout the app.
        ChangeNotifierProvider(
            create: (context) => ProfileDataStoring()..fetchUserData())
      ],
      child: RecipeStreamBuilder(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          theme: AppTheme.light,
          // darkTheme: AppTheme.dark,
          home: Authenticate(),
          // home: ProfileSetup(),
        ),
      ),
    ),
  );
}
