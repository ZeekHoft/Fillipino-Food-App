import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FavoriteSocialPost extends ChangeNotifier {
  final List<String> _socialFavoriteId = [];

  final List<String> _postIngredients = [];
  final List<String> _postProcessSteps = [];
  final List<int> _postCalories = [];
  final List<String> _postDescriptoin = [];

  List<String> get postIngredients => _postIngredients;

  List<String> get socialFavoriteId => _socialFavoriteId;
  List<String> get postProcessSteps => _postProcessSteps;
  List<int> get postCalories => _postCalories;
  List<String> get postDescriptoin => _postDescriptoin;

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
}
