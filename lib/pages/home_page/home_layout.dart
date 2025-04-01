import 'package:firebase_auth/firebase_auth.dart';
import 'package:flilipino_food_app/pages/home_page/home_page.dart';
import 'package:flilipino_food_app/pages/search_recipe.dart';
import 'package:flutter/material.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  final user = FirebaseAuth.instance.currentUser!;
  int _currentPageIndex = 0;

  void signOutButton() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "DAAPLI",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SearchRecipe()));
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: signOutButton,
            icon: const Icon(
              Icons.exit_to_app,
            ),
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
          NavigationDestination(icon: Icon(Icons.bookmarks), label: "Saved")
        ],
      ),
      body: [
        const HomePage(),
        const Center(child: Text("TODO")),
      ][_currentPageIndex],
    );
  }
}
