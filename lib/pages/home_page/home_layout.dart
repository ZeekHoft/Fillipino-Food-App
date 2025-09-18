import 'package:firebase_auth/firebase_auth.dart';
import 'package:flilipino_food_app/pages/camera/cam_ai.dart';
import 'package:flilipino_food_app/pages/favorite/favorite_page.dart';
import 'package:flilipino_food_app/pages/home_page/home_page.dart';
import 'package:flilipino_food_app/pages/settings/settings_page.dart';
import 'package:flilipino_food_app/pages/home_page/home_widgets/search_recipe.dart';
import 'package:flilipino_food_app/pages/social/social_page.dart';
import 'package:flilipino_food_app/util/profile_set_up_util.dart';
import 'package:flutter/material.dart';

class HomeLayout extends StatefulWidget {
  final ProfileSetUpUtil? userProfile;
  const HomeLayout({super.key, this.userProfile});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  final user = FirebaseAuth.instance.currentUser!;
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("DAPPLI"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SearchRecipe()));
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RecipeGeneratorScreen()));
        },
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: CircleBorder(
          side: BorderSide(
            width: 3,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        tooltip: "Capture Ingredients",
        child: Icon(
          Icons.center_focus_weak_outlined,
          size: 36,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: _currentPageIndex,
        onDestinationSelected: (index) => setState(() {
          _currentPageIndex = index;
        }),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.people), label: "Social"),
          NavigationDestination(icon: Icon(Icons.bookmarks), label: "Saved"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Settings")
        ],
      ),
      body: [
        const HomePage(),
        const SocialPage(),
        const FavoritePage(),
        const SettingsPage(),
      ][_currentPageIndex],
    );
  }
}
