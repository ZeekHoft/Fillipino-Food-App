import 'package:firebase_auth/firebase_auth.dart';
import 'package:flilipino_food_app/pages/favorite/favorite_page.dart';
import 'package:flilipino_food_app/pages/home_page/home_page.dart';
import 'package:flilipino_food_app/pages/settings/settings_page.dart';
import 'package:flilipino_food_app/pages/home_page/home_widgets/search_recipe.dart';
import 'package:flutter/material.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

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
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: _currentPageIndex,
        onDestinationSelected: (index) => setState(() {
          _currentPageIndex = index;
        }),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.bookmarks), label: "Saved"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Settings")
        ],
      ),
      body: [
        const HomePage(),
        const FavoritePage(),
        const SettingsPage(),
      ][_currentPageIndex],
    );
  }
}
