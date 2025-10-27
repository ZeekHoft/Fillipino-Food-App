// postID, postPic, postDescription, datetime, shares/reposts, likeCount,
// accounts that interacted, ingredients list, process steps, calories

import 'package:cloud_firestore/cloud_firestore.dart';

class SocialSetUpUtil {
  final String? userId;
  String? postID;
  String? postPic;
  String? postDescription;
  DateTime? dateTimePost;
  int? shares;
  int? likeCount;
  Set<String>? likedAccounts;
  List<String>? ingredients;
  List<String>? processSteps;
  int? calories; // Added calories field

  SocialSetUpUtil({
    this.userId,
    this.postID,
    this.postPic,
    this.postDescription,
    this.dateTimePost,
    this.shares = 0,
    this.likeCount = 0,
    this.likedAccounts,
    this.ingredients,
    this.processSteps,
    this.calories = 0, // Added calories parameter with default value 0
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'postID': postID,
      'postPic': postPic,
      'postDescription': postDescription,
      'dateTimePost': dateTimePost,
      'shares': shares,
      'likeCount': likeCount,
      'likedAccounts': likedAccounts?.toList(),
      'ingredients': ingredients,
      'processSteps': processSteps,
      'calories': calories, // Added calories to Firestore map
    };
  }

  // Factory constructor to create from Firestore Map
  factory SocialSetUpUtil.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SocialSetUpUtil(
      userId: data['userId'],
      postID: data['postID'] ?? '',
      postPic: data['postPic'] ?? '',
      postDescription: data['postDescription'] ?? '',
      dateTimePost: (data['dateTimePost'] as Timestamp?)?.toDate(),
      shares: data['shares'] ?? 0,
      likeCount: data['likeCount'] ?? 0,
      likedAccounts: (data['likedAccounts'] as List?)
          ?.map((account) => account.toString())
          .toSet(),
      ingredients: (data['ingredients'] as List?)
          ?.map((ingredient) => ingredient.toString())
          .toList(),
      processSteps: (data['processSteps'] as List?)
          ?.map((step) => step.toString())
          .toList(),
      calories: data['calories'] ?? 0, // Added calories from Firestore
    );
  }
  // might be helpful later
  // // Helper method to add an ingredient
  // void addIngredient(String ingredient) {
  //   ingredients ??= [];
  //   if (!ingredients!.contains(ingredient)) {
  //     ingredients!.add(ingredient);
  //   }
  // }

  // // Helper method to remove an ingredient
  // void removeIngredient(String ingredient) {
  //   ingredients?.remove(ingredient);
  // }

  // // Helper method to add a process step
  // void addProcessStep(String step) {
  //   processSteps ??= [];
  //   processSteps!.add(step);
  // }

  // // Helper method to remove a process step
  // void removeProcessStep(int index) {
  //   if (processSteps != null && index >= 0 && index < processSteps!.length) {
  //     processSteps!.removeAt(index);
  //   }
  // }

  // // Helper method to reorder process steps
  // void reorderProcessSteps(int oldIndex, int newIndex) {
  //   if (processSteps == null) return;
  //   if (newIndex > oldIndex) {
  //     newIndex -= 1;
  //   }
  //   final step = processSteps!.removeAt(oldIndex);
  //   processSteps!.insert(newIndex, step);
  // }
}
