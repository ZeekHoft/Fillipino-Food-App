// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// /// 1. NEW DATA CLASS: SocialPost
// /// Encapsulates all the favorited post details into a single, cohesive object.
// class SocialPost {
//   final String postId;
//   final String ingredient;
//   final String processSteps;
//   final String description;
//   final int calories;

//   SocialPost({
//     required this.postId,
//     required this.ingredient,
//     required this.processSteps,
//     required this.description,
//     required this.calories,
//   });
// }

// class FavoriteSocialProvider extends ChangeNotifier {
//   // 2. REPLACED five lists with a single list of SocialPost objects
//   final List<SocialPost> _favoritePosts = [];

//   // Public getter for the main list of posts
//   List<SocialPost> get favoritePosts => _favoritePosts;

//   // 3. UPDATED GETTERS for backward compatibility
//   // These derive the old parallel lists from the single _favoritePosts list
//   List<String> get socialFavoriteId =>
//       _favoritePosts.map((p) => p.postId).toList();
//   List<String> get postIngredients =>
//       _favoritePosts.map((p) => p.ingredient).toList();
//   List<String> get postProcessSteps =>
//       _favoritePosts.map((p) => p.processSteps).toList();
//   List<int> get postCalories => _favoritePosts.map((p) => p.calories).toList();
//   List<String> get postDescriptoin =>
//       _favoritePosts.map((p) => p.description).toList();

//   Future<void> _storeSocialFavoriteInFireBase(
//       String postId, bool isAdding) async {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null || currentUser.email == null) {
//       if (kDebugMode) {
//         print(
//             "User not logged in or email not available in DBA, user: $currentUser ");
//       }
//       return;
//     }

//     try {
//       final userDocQuery = await FirebaseFirestore.instance
//           .collection('users_data')
//           .where('email', isEqualTo: currentUser.email)
//           .limit(1)
//           .get();

//       if (userDocQuery.docs.isEmpty) {
//         if (kDebugMode) {
//           print("User data document not found for email: ${currentUser.email}");
//         }
//         return;
//       }

//       final userDocRef = userDocQuery.docs.first.reference;

//       if (isAdding) {
//         // Add the post ID to the 'favorites_social' array field
//         await userDocRef.update({
//           'favorites_social': FieldValue.arrayUnion([postId]),
//         });
//         if (kDebugMode) {
//           print(
//               "Added $postId to Firestore favorites for ${currentUser.email}");
//         }
//       } else {
//         // Remove the post ID from the 'favorites_social' array field
//         await userDocRef.update({
//           'favorites_social': FieldValue.arrayRemove([postId]),
//         });
//         if (kDebugMode) {
//           print(
//               "Removed $postId from Firestore favorites for ${currentUser.email}");
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print("Error in updating firesoter: $e");
//       }
//     } finally {
//       // NOTE: notifyListeners() is called in the public toggleSocialFavorite
//       // to update the UI immediately, but we keep it here for safety.
//       // notifyListeners();
//     }
//   }

//   void loadSocialFavorites() async {
//     // 4. Clear the single, unified list
//     _favoritePosts.clear();

//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null || currentUser.email == null) {
//       if (kDebugMode) {
//         print("User not logged in. Cannot load favorites from Firestore.");
//       }
//       notifyListeners();
//       return;
//     }
//     try {
//       final userDocQuery = await FirebaseFirestore.instance
//           .collection('users_data')
//           .where('email', isEqualTo: currentUser.email)
//           .limit(1)
//           .get();

//       if (userDocQuery.docs.isNotEmpty) {
//         final userData = userDocQuery.docs.first.data();
//         final List<dynamic> firestoreSocialFavorites =
//             userData['favorites_social'] ?? [];

//         // 5. Fetch details for each favorited ID and populate the single list
//         if (firestoreSocialFavorites.isNotEmpty) {
//           final socialRecipeCollection =
//               FirebaseFirestore.instance.collection('social_data');

//           // Convert dynamic list of IDs to List<String>
//           final List<String> favoriteIds =
//               firestoreSocialFavorites.map((e) => e.toString()).toList();

//           for (String docId in favoriteIds) {
//             try {
//               DocumentSnapshot doc =
//                   await socialRecipeCollection.doc(docId).get();
//               if (doc.exists) {
//                 Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

//                 // Create the SocialPost object from fetched data
//                 final String ingredients =
//                     (data['ingredients'] as List<dynamic>? ?? []).join(', ');
//                 final String processSteps =
//                     (data['processSteps'] as List<dynamic>? ?? []).join(', ');
//                 final int calories = data['calories'] is int
//                     ? data['calories']
//                     : int.tryParse(data['calories'].toString()) ?? 0;
//                 final String description =
//                     data['postDescription']?.toString() ?? '';

//                 // Add the complete post object to the list
//                 _favoritePosts.add(
//                   SocialPost(
//                     postId: docId,
//                     ingredient: ingredients,
//                     processSteps: processSteps,
//                     description: description,
//                     calories: calories,
//                   ),
//                 );
//               } else {
//                 if (kDebugMode) {
//                   print('Document with ID ${docId} not found in Firebase DBA');
//                 }
//               }
//             } catch (e) {
//               if (kDebugMode) {
//                 print('Error fetching document $docId: $e');
//               }
//             }
//           }
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print("Error in getting user data: $e");
//       }
//     } finally {
//       notifyListeners();
//     }
//   }

//   // 6. Updated toggleSocialFavorite to use the SocialPost object
//   void toggleSocialFavorite(String postId, String ingredient, String porcess,
//       String description, int calories) {
//     // Check if the post is already a favorite using the single list
//     final existingIndex =
//         _favoritePosts.indexWhere((post) => post.postId == postId);

//     if (existingIndex != -1) {
//       // Post is a favorite, remove it
//       _favoritePosts.removeAt(existingIndex);
//       _storeSocialFavoriteInFireBase(postId, false);
//     } else {
//       // Post is not a favorite, create and add the full SocialPost object
//       final newPost = SocialPost(
//         postId: postId,
//         ingredient: ingredient,
//         processSteps:
//             porcess, // Note: using 'porcess' to match the parameter name in the original function signature
//         description: description,
//         calories: calories,
//       );
//       _favoritePosts.add(newPost);
//       _storeSocialFavoriteInFireBase(postId, true);
//     }
//     notifyListeners();
//   }

//   bool isSocialExist(String docId) {
//     // Check for existence is now simplified
//     return _favoritePosts.any((post) => post.postId == docId);
//   }
// }

// class FavoriteSocialScreen extends StatelessWidget {
//   const FavoriteSocialScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // 1. Listen to the provider for changes
//     final favoriteProvider = Provider.of<FavoriteSocialProvider>(context);
//     final favoritePosts = favoriteProvider.favoritePosts;

//     // 2. Call loadSocialFavorites when the screen is built
//     // Use `WidgetsBinding.instance.addPostFrameCallback` to ensure the build context is complete
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (favoritePosts.isEmpty) {
//         favoriteProvider.loadSocialFavorites();
//       }
//     });

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Favorite Social Recipes'),
//       ),
//       body: favoritePosts.isEmpty
//           ? const Center(
//               // Display a message when the list is empty
//               child: Text(
//                 'You haven\'t favorited any posts yet!',
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//             )
//           : ListView.builder(
//               itemCount: favoritePosts.length,
//               itemBuilder: (context, index) {
//                 // 3. Access the single SocialPost object
//                 final post = favoritePosts[index];

//                 return Card(
//                   margin:
//                       const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Display Post Description/Title
//                         Text(
//                           post.description.isEmpty
//                               ? 'No Description'
//                               : post.description,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 8),

//                         // Display Calories
//                         Text(
//                           '🔥 Calories: ${post.calories}',
//                           style: const TextStyle(color: Colors.redAccent),
//                         ),
//                         const SizedBox(height: 4),

//                         // Display Ingredients
//                         _buildDetailRow('Ingredients:', post.ingredient),
//                         const SizedBox(height: 4),

//                         // Display Process Steps
//                         _buildDetailRow('Process Steps:', post.processSteps),
//                         const SizedBox(height: 8),

//                         // Remove from Favorites Button
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: IconButton(
//                             icon: const Icon(Icons.bookmark_remove,
//                                 color: Colors.red),
//                             onPressed: () {
//                               // Use toggleSocialFavorite to remove the item
//                               favoriteProvider.toggleSocialFavorite(
//                                 post.postId,
//                                 post.ingredient,
//                                 post.processSteps,
//                                 post.description,
//                                 post.calories,
//                               );
//                               // Optional: Show a small confirmation snackbar
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                     content: Text('Removed from favorites!')),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }

//   // Helper method for cleaner code
//   Widget _buildDetailRow(String title, String content) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontWeight: FontWeight.w600),
//         ),
//         Text(
//           content.isEmpty ? 'No details provided.' : content,
//           style: const TextStyle(fontSize: 14),
//           maxLines: 3,
//           overflow: TextOverflow.ellipsis,
//         ),
//       ],
//     );
//   }
// }
