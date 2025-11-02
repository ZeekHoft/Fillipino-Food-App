import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Encapsulates all the favorited post details into a single, cohesive object
// Previous approach was a data in parallel list which means deleting items on specific index
//woudn't mean deleting all instances on those indexs on other list, this apporach deletes all
class SocialPost {
  final String postId;
  final String ingredient;
  final String processSteps;
  final String description;
  final int calories;

  SocialPost({
    required this.postId,
    required this.ingredient,
    required this.processSteps,
    required this.description,
    required this.calories,
  });
}

class FavoriteSocialProvider extends ChangeNotifier {
  final List<SocialPost> _favoritePosts =
      []; // replace the 5 parallel list into one list that contains all data
  List<SocialPost> get favoritePost => _favoritePosts;

  List<String> get socialFavoriteId =>
      _favoritePosts.map((p) => p.postId).toList();
  List<String> get postIngredients =>
      _favoritePosts.map((p) => p.ingredient).toList();
  List<String> get postProcessSteps =>
      _favoritePosts.map((p) => p.processSteps).toList();
  List<int> get postCalories => _favoritePosts.map((p) => p.calories).toList();
  List<String> get postDescription =>
      _favoritePosts.map((p) => p.description).toList();

  Future<void> _storeSocialFavoriteInFireBase(
      String postId, bool isAdding) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.email == null) {
      //check if user is logged in
      if (kDebugMode) {
        print(
            "User not logged in or email not available in DBA, user: $currentUser ");
      }
      return;
    }

    try {
      final userDocQuery = await FirebaseFirestore.instance
          .collection('users_data')
          .where('email', isEqualTo: currentUser.email)
          .limit(1)
          .get();

      //check if user found
      if (userDocQuery.docs.isEmpty) {
        if (kDebugMode) {
          print("User data document not found for email: ${currentUser.email}");
        }
        // You might want to create a user data document if it doesn't exist
        return;
      }

      final userDocRef =
          userDocQuery.docs.first.reference; //user has been found

      if (isAdding) {
        //adding
        // Add the recipe ID from social to the 'favorites' array field
        await userDocRef.update({
          'favorites_social': FieldValue.arrayUnion([postId]),
        });
        if (kDebugMode) {
          print(
              "Added $postId to Firestore favorites for ${currentUser.email}");
        }
      } else {
        // removing
        // Remove the recipe ID from the 'favorites' array field
        await userDocRef.update({
          'favorites_social': FieldValue.arrayRemove([postId]),
        });
        if (kDebugMode) {
          print(
              "Removed $postId from Firestore favorites for ${currentUser.email}"); // improve error handling
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in updating firesoter: $e");
      }
    }
  }

  void loadSocialFavorites() async {
    _favoritePosts.clear();

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.email == null) {
      if (kDebugMode) {
        print("User not logged in. Cannot load favorites from Firestore.");
      }
      notifyListeners(); // Notify listeners even if no user, to clear state
      return;
    }
    try {
      final userDocQuery = await FirebaseFirestore.instance
          .collection('users_data')
          .where('email', isEqualTo: currentUser.email)
          .limit(1)
          .get();

      if (userDocQuery.docs.isNotEmpty) {
        final userDocRef =
            userDocQuery.docs.first.reference; // Reference to the user document
        final userData = userDocQuery.docs.first.data();
        final List<dynamic> firestoreSocialFavorites =
            userData['favorites_social'] ?? [];
        // this is located in the documents field

        final socialRecipeCollection = FirebaseFirestore.instance.collection(
            'social_data'); // Use a list to track IDs that need to be removed from the user's document

        final List<String> favoriteIds = firestoreSocialFavorites
            .map((e) => e.toString())
            .toList(); // we'll fetch the full recipe detail for each favorited ID in its specific document

        final List<String> missingIds = [];
        if (firestoreSocialFavorites.isNotEmpty) {
          // convert dyanmic lists of IDs to list<String> so it can be easily read

          for (String docId in favoriteIds) {
            try {
              DocumentSnapshot doc =
                  await socialRecipeCollection.doc(docId).get();
              if (doc.exists) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                final String ingredients =
                    (data['ingredients'] as List<dynamic>? ?? []).join(', ');
                final String processSteps =
                    (data['processSteps'] as List<dynamic>? ?? []).join(', ');
                final int calories = (data['calories'] is int
                    ? data['calories']
                    : int.tryParse(data['calories'].toString()) ?? 0);
                final String description =
                    (data['postDescription']?.toString() ?? '');

                // Add the complete post object to the list
                _favoritePosts.add(SocialPost(
                  postId: docId,
                  ingredient: ingredients,
                  processSteps: processSteps,
                  description: description,
                  calories: calories,
                ));
              } else {
                // Handle cases where a favorited recipe might have been deleted from Firebase
                if (kDebugMode) {
                  print('Document widh ID ${docId} not found in Firebase DBA');
                }
                missingIds.add(
                    docId); //deletes the ID thats missing whenver the system gets restarted
              }
            } catch (e) {
              if (kDebugMode) {
                print('Error fetching document $docId: $e');
              }
            }
          }
          if (missingIds.isNotEmpty) {
            await userDocRef.update({
              'favorites_social': FieldValue.arrayRemove(missingIds),
            });
            if (kDebugMode) {
              print(
                  'Cleaned up ${missingIds.length} stale favorite IDs from user document.');
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in getting user data: $e");
      }
    } finally {
      notifyListeners();
    }
  }

  void toggleSocialFavorite(String postId, String ingredient, String process,
      String description, int calories) {
    // Check if the post is already a favorite using the single list
    final existingIndex =
        _favoritePosts.indexWhere((post) => post.postId == postId);

    if (existingIndex != -1) {
      // Post is a favorite, remove it
      _favoritePosts.removeAt(existingIndex);
      _storeSocialFavoriteInFireBase(postId, false);
    } else {
      // Post is not a favorite, create and add the full SocialPost object
      final newPost = SocialPost(
        postId: postId,
        ingredient: ingredient,
        processSteps: process,
        description: description,
        calories: calories,
      );
      _favoritePosts.add(newPost);
      _storeSocialFavoriteInFireBase(postId, true);
    }
    notifyListeners();
  }

  bool isSocialExist(String postId) {
    return _favoritePosts.any((post) => post.postId == postId);
  }
}
