import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flilipino_food_app/pages/camera/ingredient_scanner_screen.dart';
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

  void switchToAI() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Initialize cameras
      final cameras = await availableCameras();

      // Close loading dialog
      if (mounted) Navigator.pop(context);

      // Check if cameras are available
      if (cameras.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No cameras found on device')),
          );
        }
        return;
      }

      // Navigate to camera screen
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IngredientScannerScreen(),
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) Navigator.pop(context);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error accessing camera: $e')),
        );
      }
    }
  }

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
          switchToAI();
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
          NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
          // NavigationDestination(
          // icon: Icon(Icons.bookmark_add_rounded), label: "Social Favorite"),
        ],
      ),
      body: [
        const HomePage(),
        const SocialPage(
          showUserPosts: false,
        ),
        const FavoritePage(),
        const SettingsPage(),
        // const FavoriteSocialItem()
        // uncomment the two if u want to see directly only the social favorites
      ][_currentPageIndex],
    );
  }
}
