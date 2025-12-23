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
  final String username;
  final Timestamp timestamp;

  SocialPost({
    required this.postId,
    required this.ingredient,
    required this.processSteps,
    required this.description,
    required this.calories,
    required this.username,
    required this.timestamp,
  });
  // convert the object to a map in firestore
  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'ingredient': ingredient,
      'processSteps': processSteps,
      'description': description,
      'calories': calories,
      'postUsername': username,

      'timestamp': FieldValue.serverTimestamp(), // Optional but helpful
    };
  }

// Factory constructor to create a SocialPost from a Firestore map
  factory SocialPost.fromMap(Map<String, dynamic> data) {
    return SocialPost(
      // This is for potential handling error
      postId: data['postId'] as String? ?? 'N/A',
      ingredient: data['ingredient'] as String? ?? 'N/A',
      processSteps: data['processSteps'] as String? ?? 'N/A',
      description: data['description'] as String? ?? 'N/A',
      calories: (data['calories'] as num?)?.toInt() ?? 0,
      username: data['postUsername'] as String? ?? 'N/A',
      timestamp: data['timestamp'] as Timestamp,
    );
  }
}

class FavoriteSocialProvider extends ChangeNotifier {
  final List<SocialPost> _favoritePosts = [];
  bool _isLoading = false;

  // replace the 5 parallel list into one list that contains all data
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
  List<String> get postUsername =>
      _favoritePosts.map((p) => p.username).toList();
  bool get isLoading => _isLoading;

  Future<void> _storeSocialFavoriteInFireBase(String postId, bool isAdding,
      {SocialPost? post}) async {
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

      final userDocRef = userDocQuery.docs.first.reference;
      // Reference to the document within the 'social_favorites' sub-collection
      final favoriteRef = userDocRef.collection('social_favorites').doc(postId);
      //user has been found

      if (isAdding) {
        if (post != null) {
          // Store the complete post data in the user's sub-collection
          await favoriteRef.set(post.toMap());
          if (kDebugMode) {
            print(
                "Added $postId to Firestore favorites for ${currentUser.email}");
          }
        }
      } else {
        // Remove the document from the user's sub-collection
        await favoriteRef.delete();
        if (kDebugMode) {
          print(
              "Deleted $postId to Firestore favorites for ${currentUser.email}");
        }
      }
      //   //adding
      //   // Add the recipe ID from social to the 'favorites' array field
      //   await userDocRef.update({
      //     'favorites_social': FieldValue.arrayUnion([postId]),
      //   });
      //   if (kDebugMode) {
      //     print(
      //         "Added $postId to Firestore favorites for ${currentUser.email}");
      //   }
      // } else {
      //   // removing
      //   // Remove the recipe ID from the 'favorites' array field
      //   await userDocRef.update({
      //     'favorites_social': FieldValue.arrayRemove([postId]),
      //   });
      //   if (kDebugMode) {
      //     print(
      //         "Removed $postId from Firestore favorites for ${currentUser.email}"); // improve error handling
      //   }
      // }
    } catch (e) {
      if (kDebugMode) {
        print("Error in updating firesoter: $e");
      }
    }
  }

  void loadSocialFavorites() async {
    _favoritePosts.clear();
    _isLoading = true;

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
        final userDocRef = userDocQuery.docs.first.reference;
        // Reference to the user document

        // this creates a subcollection under the users_data collection of data
        final favoritesSnapshot =
            await userDocRef.collection('social_favorites').get();
        if (kDebugMode) {
          print(
              "Loaded ${favoritesSnapshot.docs.length} favorite posts from sub-collection.");
        }
        //itterate thorugh the docs and build a socialpost object
        for (final doc in favoritesSnapshot.docs) {
          try {
            final data = doc.data();
            _favoritePosts.add(SocialPost(
              postId: data['postId'] as String? ?? 'N/A',
              ingredient: data['ingredient'] as String? ?? 'N/A',
              processSteps: data['processSteps'] as String? ?? 'N/A',
              description: data['description'] as String? ?? 'N/A',
              calories: (data['calories'] as num?)?.toInt() ?? 0,
              username: data['postUsername'] as String? ?? 'N/A',
              timestamp: data['timestamp']! as Timestamp,
            ));
          } catch (e) {
            // Handle corrupted documents in the sub-collection
            if (kDebugMode) {
              print('Error parsing favorite document ${doc.id}: $e');
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in getting user data: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleSocialFavorite(
      String postId,
      String ingredient,
      String process,
      String description,
      int calories,
      String username,
      Timestamp timestamp) async {
    // Check if the post is already a favorite using the single list
    final existingIndex =
        _favoritePosts.indexWhere((post) => post.postId == postId);

    if (existingIndex != -1) {
      // Post is a favorite, remove it
      _favoritePosts.removeAt(existingIndex);
      await _storeSocialFavoriteInFireBase(postId, false);
    } else {
      // Post is not a favorite, create and add the full SocialPost object
      final newPost = SocialPost(
        postId: postId,
        ingredient: ingredient,
        processSteps: process,
        description: description,
        calories: calories,
        username: username,
        timestamp: timestamp,
      );
      _favoritePosts.add(newPost);
      await _storeSocialFavoriteInFireBase(postId, true, post: newPost);
    }
    notifyListeners();
  }
// In FavoriteSocialProvider class

// THIS NEEDS TO BE REVIEWD FOR POTENTIAL ERRORS
// New method to be called after a post is deleted from the main collection
  Future<void> removeSocialFavorite(String postId) async {
    final existingIndex =
        _favoritePosts.indexWhere((post) => post.postId == postId);

    if (existingIndex != -1) {
      // Remove from local list
      _favoritePosts.removeAt(existingIndex);
      // Remove from Firestore sub-collection
      await _storeSocialFavoriteInFireBase(postId, false);

      notifyListeners(); // Notify listeners of this provider
      if (kDebugMode) {
        print("Removed favorite post $postId due to main post deletion.");
      }
    }
    // No need to notifyListeners if it wasn't a favorite.
  }
// THIS NEEDS TO BE REVIEWD FOR POTENTIAL ERRORS

  bool isSocialExist(String postId) {
    return _favoritePosts.any((post) => post.postId == postId);
  }
}
