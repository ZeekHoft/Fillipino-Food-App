import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flilipino_food_app/pages/favorite/favorite_social_provider.dart';
import 'package:flilipino_food_app/pages/home_page/user_profile.dart';
import 'package:flilipino_food_app/themes/app_theme.dart';
import 'package:flutter/foundation.dart';

class SocialDataStoring extends ChangeNotifier {
  String? _userId;
  List<Map<String, dynamic>> _posts = [];
  List<Map<String, dynamic>> _historyPosts = [];

  String? _postID;
  String? _postPic;
  String? _postDescription = 'Loading...';
  String? _postUsername = 'N/A Username';
  DateTime? _dateTimePost;
  int? _shares = 0;
  int? _likeCount = 0;
  Set? _likedAccounts = <String>{};
  List<String>? _ingredients = [];
  List<String>? _processSteps = [];
  int? _calories = 0; // Added calories field
  bool _isLoading = true;

  //checks if the user is logged in or not, if not shows the loading data if they are logged in pulls their data
  late final StreamSubscription<User?> _authStateChangesSubscription;

  String? get userId => _userId;
  // The lists map posts and history are being referenced in social page to display posts data
  List<Map<String, dynamic>> get posts => _posts;
  List<Map<String, dynamic>> get history => _historyPosts;

  String? get postID => _postID;
  String? get postPic => _postPic;
  String? get postDescription => _postDescription;
  String? get postUsername => _postUsername;
  DateTime? get dateTimePost => _dateTimePost;
  int? get shares => _shares;
  int? get likeCount => _likeCount;
  Set? get likedAccounts => _likedAccounts;
  List<String>? get ingredients => _ingredients;
  List<String>? get processSteps => _processSteps;
  int? get calories => _calories; // Added calories getter
  bool get isLoading => _isLoading;

  SocialDataStoring() {
    _authStateChangesSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        fetchUserPost(user.uid);
        countUserPost(user.uid);
      } else {
        clearPostData();
      }
    });
  }

  Future<int?> countUserPost(String uid) async {
    int? numberOfDocuments;
    try {
      AggregateQuerySnapshot query = await FirebaseFirestore.instance
          .collection('social_data')
          .where("userId", isEqualTo: uid)
          .count()
          .get();

      numberOfDocuments = query.count;
    } catch (e) {
      if (kDebugMode) {
        print("Fetching Error in user posts: $e");
      }
    }
    // print("POSTSSSS: $numberOfDocuments");
    return numberOfDocuments;
  }

  Future<void> fetchUserPost(String uid) async {
    _isLoading = true;
    notifyListeners();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      clearPostData();
      return;
    }
// QuerySnapshot<Map<String, dynamic>>
    try {
      final snapshotSocialPage =
          await FirebaseFirestore.instance.collection("social_data").get();
      final snapshotSocialHistory = await FirebaseFirestore.instance
          .collection("social_data")
          .where("userId", isEqualTo: uid)
          .get();
      socialDataInformation(snapshotSocialPage, snapshotSocialHistory);

      _userId = "N/A UserID";
      _postID = "N/A postID";
      _postPic = null;
      _postDescription = "N/A";
      _postUsername = "N/A";
      _dateTimePost = null;
      _shares = 0;
      _likeCount = 0;
      _likedAccounts = <String>{};
      _ingredients = [];
      _processSteps = [];
      _calories = 0; // Added calories to error state
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> socialDataInformation(
      QuerySnapshot<Map<String, dynamic>> socialSnapShot,
      QuerySnapshot<Map<String, dynamic>> historySnapShot) async {
    try {
      _posts = socialSnapShot.docs.map((doc) {
        final postsData = doc.data();
        print('fetched social: $postsData');
        return _mapPostData(postsData);
      }).toList();

      _historyPosts = historySnapShot.docs.map((doc) {
        final postsData = doc.data();
        print('fetched history: $postsData');
        return _mapPostData(postsData);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Fetching Error in user posts: $e");
      }
    }
  }

  Map<String, dynamic> _mapPostData(Map<String, dynamic> postsData) {
    return {
      "postID": postsData["postID"],
      "postPic": postsData["postPic"],
      "userId": postsData["userId"],
      "postDescription": postsData["postDescription"],
      "postUsername": postsData["postUsername"] ?? 'N/A Username',
      "dateTimePost": (postsData["dateTimePost"] as Timestamp).toDate(),
      "shares": postsData["shares"],
      "likeCount": postsData["likeCount"],
      "likedAccounts": postsData["likedAccounts"] != null
          ? (postsData["likedAccounts"] as List?)?.toSet()
          : <String>{},
      "ingredients": postsData["ingredients"] != null
          ? (postsData["ingredients"] as List?)
              ?.map((e) => e.toString())
              .toList()
          : <String>[],
      "processSteps": postsData["processSteps"] != null
          ? (postsData["processSteps"] as List?)
              ?.map((e) => e.toString())
              .toList()
          : <String>[],
      "calories": postsData["calories"] ?? 0,

      // Added calories mapping
    };
  }

  // Future<void> deletePost(String postId) async {
  //   try {
  //     await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
  //     print('Post with ID $postId deleted successfully!');
  //   } catch (e) {
  //     print('Error deleting post: $e');
  //   }
  // }

  // need
  // In SocialDataStoring class

  // THIS NEEDS TO BE REVIEWD FOR POTENTIAL ERRORS
  Future<void> deletePost(
      String postId, FavoriteSocialProvider favoriteProvider) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("social_data")
          .where("postID", isEqualTo: postId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs[0].reference.delete();
        print('Post with ID $postId deleted successfully from Firestore!');

        _posts.removeWhere((post) => post["postID"] == postId);
        _historyPosts.removeWhere((post) => post["postID"] == postId);

        await favoriteProvider.removeSocialFavorite(postId);

        notifyListeners();
      } else {
        print('Post with ID $postId not found in social_data.');
      }
    } catch (e) {
      print('Error deleting post: $e');
    }
  }
// THIS NEEDS TO BE REVIEWD FOR POTENTIAL ERRORS

  Future<void> triggerLike(
      String postId, String accountId, Set postLikedAccounts) async {
    if (postLikedAccounts.contains(accountId)) {
      // Remove account
      postLikedAccounts.remove(accountId);
    } else {
      postLikedAccounts.add(accountId);
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("social_data")
          .where("postID", isEqualTo: postId)
          .get();
      DocumentReference docRef = snapshot.docs[0].reference;
      await docRef.update({"likedAccounts": postLikedAccounts.toList()});

      print('Likes successfully updated!');
    } catch (e) {
      print('Error updating likes: $e');
    }

    notifyListeners();
  }

  // // Optional: Method to update calories for a specific post
  // Future<void> updateCalories(String postId, int calories) async {
  //   try {
  //     final snapshot = await FirebaseFirestore.instance
  //         .collection("social_data")
  //         .where("postID", isEqualTo: postId)
  //         .get();

  //     if (snapshot.docs.isNotEmpty) {
  //       DocumentReference docRef = snapshot.docs[0].reference;
  //       await docRef.update({"calories": calories});

  //       // Update local state
  //       final postIndex = _posts.indexWhere((post) => post["postID"] == postId);
  //       if (postIndex != -1) {
  //         _posts[postIndex]["calories"] = calories;
  //       }

  //       print('Calories successfully updated!');
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     print('Error updating calories: $e');
  //   }
  // }

  void clearPostData() {
    _userId = "N/A UserID";
    _postID = "N/A postID";
    _postPic = null;
    _postDescription = "N/A";
    _postUsername = "N/A";
    _dateTimePost = null;
    _shares = 0;
    _likeCount = 0;
    _likedAccounts = <String>{};
    _ingredients = [];
    _processSteps = [];
    _calories = 0; // Added calories to clear method
    notifyListeners();
  }

  @override
  void dispose() {
    _authStateChangesSubscription.cancel();
    super.dispose();
  }
}
